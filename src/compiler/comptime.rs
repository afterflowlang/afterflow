use std::collections::{HashMap, HashSet};

use crate::compiler::builtins::{Builtin, ComptimeRoute};
use crate::compiler::error::{Code, Error};
use crate::compiler::hir;
use crate::compiler::span::Span;

const DEFAULT_FUEL: usize = 100_000;

/// Rewrites executions with compile-time parameters into runtime HIR plans.
pub fn rewrite(
    functions: &mut HashMap<String, hir::Function>,
    entry_items: &mut Vec<hir::BlockItem>,
    builtin_aliases: &HashMap<String, Builtin>,
) -> Result<(), Error> {
    let originals = functions.clone();
    let globals = collect_globals(entry_items, &originals, builtin_aliases)?;
    let mut used_names = originals.keys().cloned().collect::<HashSet<_>>();
    used_names.extend(globals.keys().cloned());
    used_names.extend(builtin_aliases.keys().cloned());

    let mut names = originals.keys().cloned().collect::<Vec<_>>();
    names.sort();
    for name in names {
        let function = originals.get(&name).ok_or_else(|| {
            Error::new(
                Code::Internal,
                format!("missing HIR function '{name}' during compile-time rewriting"),
                Span::unknown(),
            )
        })?;
        if function.has_comptime_params {
            continue;
        }
        let params = function
            .sig
            .items
            .iter()
            .map(|param| {
                (
                    param.name.clone(),
                    globals
                        .get(&param.name)
                        .cloned()
                        .unwrap_or_else(|| Value::Runtime {
                            name: param.name.clone(),
                            kind: param.kind.clone(),
                        }),
                )
            })
            .collect::<HashMap<_, _>>();

        if let Some(items) = rewrite_items(
            &function.body.items,
            params,
            &originals,
            &globals,
            builtin_aliases,
            &mut used_names,
        )? {
            let rewritten = functions.get_mut(&name).ok_or_else(|| {
                Error::new(
                    Code::Internal,
                    format!("missing mutable HIR function '{name}'"),
                    Span::unknown(),
                )
            })?;
            rewritten.body.items = items;
        }
    }

    if let Some(items) = rewrite_items(
        entry_items,
        HashMap::new(),
        &originals,
        &globals,
        builtin_aliases,
        &mut used_names,
    )? {
        *entry_items = items;
    }

    for function in functions.values_mut() {
        for item in &mut function.body.items {
            if let hir::BlockItem::Exec(exec) = item {
                exec.is_comptime = false;
            }
        }
    }

    Ok(())
}

#[derive(Clone, Debug)]
enum Value {
    Const(ConstValue),
    Function(String),
    Builtin {
        alias: String,
        builtin: Builtin,
    },
    Closure {
        of: Box<Value>,
        args: Vec<Value>,
    },
    Boundary(Box<Value>),
    Opaque {
        value: Box<Value>,
        parameter: String,
    },
    Runtime {
        name: String,
        kind: hir::SigKind,
    },
}

#[derive(Clone, Debug)]
enum ConstValue {
    Str(String),
    Bytes(Vec<u8>),
    Int(isize),
    UInt(u64),
    Fixed { kind: hir::FixedIntKind, bits: u128 },
    Rune(u32),
    F64(u64),
}

enum Action {
    Call { of: Value, args: Vec<Value> },
    Residual { of: Value, args: Vec<Value> },
}

fn rewrite_items(
    items: &[hir::BlockItem],
    mut env: HashMap<String, Value>,
    functions: &HashMap<String, hir::Function>,
    globals: &HashMap<String, Value>,
    builtin_aliases: &HashMap<String, Builtin>,
    used_names: &mut HashSet<String>,
) -> Result<Option<Vec<hir::BlockItem>>, Error> {
    let marked = items
        .iter()
        .enumerate()
        .filter_map(|(index, item)| match item {
            hir::BlockItem::Exec(exec) if exec.is_comptime => Some((index, exec)),
            _ => None,
        })
        .collect::<Vec<_>>();

    if marked.is_empty() {
        return Ok(None);
    }
    if marked.len() != 1 {
        return Err(Error::new(
            Code::Comptime,
            "a HIR block may contain only one compile-time execution",
            marked[1].1.span,
        ));
    }

    let (marked_index, exec) = marked[0];
    if marked_index + 1 != items.len() {
        return Err(Error::new(
            Code::Comptime,
            "compile-time execution must be the terminal execution in its block",
            exec.span,
        ));
    }

    evaluate_definitions(
        &items[..marked_index],
        &mut env,
        functions,
        globals,
        builtin_aliases,
        exec.span,
    )?;
    let of = resolve_name(
        &exec.of,
        &env,
        functions,
        globals,
        builtin_aliases,
        exec.span,
    )?;
    let args = exec
        .args
        .iter()
        .map(|name| resolve_name(name, &env, functions, globals, builtin_aliases, exec.span))
        .collect::<Result<Vec<_>, _>>()?;

    let mut evaluator = Evaluator {
        functions,
        globals,
        builtin_aliases,
        fuel: DEFAULT_FUEL,
        span: exec.span,
    };
    let plan = evaluator.run(of, args)?;

    for value in env.values() {
        collect_runtime_names(value, used_names);
    }
    let mut materializer = Materializer {
        next_id: 0,
        used_names,
        span: exec.span,
    };
    materializer.execute(plan).map(Some)
}

fn collect_globals(
    items: &[hir::BlockItem],
    functions: &HashMap<String, hir::Function>,
    builtin_aliases: &HashMap<String, Builtin>,
) -> Result<HashMap<String, Value>, Error> {
    let mut globals = HashMap::new();
    for item in items {
        match item {
            hir::BlockItem::LitDef { name, literal } => {
                globals.insert(name.clone(), Value::Const(const_from_literal(literal)));
            }
            hir::BlockItem::ClosureDef(closure) => {
                let of = resolve_name(
                    &closure.of,
                    &globals,
                    functions,
                    &HashMap::new(),
                    builtin_aliases,
                    Span::unknown(),
                )?;
                let args = closure
                    .args
                    .iter()
                    .map(|name| {
                        resolve_name(
                            name,
                            &globals,
                            functions,
                            &HashMap::new(),
                            builtin_aliases,
                            Span::unknown(),
                        )
                    })
                    .collect::<Result<Vec<_>, _>>()?;
                globals.insert(
                    closure.name.clone(),
                    Value::Closure {
                        of: Box::new(of),
                        args,
                    },
                );
            }
            _ => {}
        }
    }
    Ok(globals)
}

fn evaluate_definitions(
    items: &[hir::BlockItem],
    env: &mut HashMap<String, Value>,
    functions: &HashMap<String, hir::Function>,
    globals: &HashMap<String, Value>,
    builtin_aliases: &HashMap<String, Builtin>,
    span: Span,
) -> Result<(), Error> {
    for item in items {
        match item {
            hir::BlockItem::LitDef { name, literal } => {
                env.insert(name.clone(), Value::Const(const_from_literal(literal)));
            }
            hir::BlockItem::ClosureDef(closure) => {
                let of = resolve_name(&closure.of, env, functions, globals, builtin_aliases, span)?;
                let args = closure
                    .args
                    .iter()
                    .map(|name| resolve_name(name, env, functions, globals, builtin_aliases, span))
                    .collect::<Result<Vec<_>, _>>()?;
                env.insert(
                    closure.name.clone(),
                    Value::Closure {
                        of: Box::new(of),
                        args,
                    },
                );
            }
            hir::BlockItem::Import { .. } | hir::BlockItem::SigDef { .. } => {}
            hir::BlockItem::Exec(other) => {
                return Err(Error::new(
                    Code::Comptime,
                    format!(
                        "execution of '{}' precedes the terminal compile-time execution",
                        other.of
                    ),
                    other.span,
                ));
            }
            hir::BlockItem::FunctionDef(_) => {
                return Err(Error::new(
                    Code::Internal,
                    "nested HIR function was not hoisted before compile-time execution",
                    span,
                ));
            }
        }
    }
    Ok(())
}

struct Evaluator<'a> {
    functions: &'a HashMap<String, hir::Function>,
    globals: &'a HashMap<String, Value>,
    builtin_aliases: &'a HashMap<String, Builtin>,
    fuel: usize,
    span: Span,
}

impl Evaluator<'_> {
    fn run(&mut self, mut of: Value, mut args: Vec<Value>) -> Result<Value, Error> {
        (of, args) = flatten_call(of, args);

        loop {
            if self.fuel == 0 {
                return Err(self.error("compile-time execution exceeded its evaluation limit"));
            }
            self.fuel -= 1;

            (of, args) = flatten_call(of, args);
            args = self.bind_staged_inputs(&of, args)?;
            let action = match of {
                Value::Function(name) => self.call_function(&name, args)?,
                Value::Builtin { alias, builtin } => self.call_builtin(&alias, builtin, args)?,
                Value::Boundary(of) => return Ok(Value::Closure { of, args }),
                Value::Opaque { parameter, .. } => {
                    return Err(self.error(format!(
                        "compile-time execution cannot invoke unmarked parameter '{parameter}'"
                    )))
                }
                Value::Runtime { name, kind } => {
                    if matches!(kind, hir::SigKind::Sig(_)) {
                        return Ok(Value::Closure {
                            of: Box::new(Value::Runtime { name, kind }),
                            args,
                        });
                    }
                    return Err(self.error(format!(
                        "compile-time execution invokes non-callable runtime value '{name}'"
                    )));
                }
                Value::Const(_) => {
                    return Err(self.error("compile-time execution target is not callable"))
                }
                Value::Closure { .. } => unreachable!("flatten_call leaves no outer closure"),
            };

            match action {
                Action::Call {
                    of: next_of,
                    args: next_args,
                } => {
                    of = next_of;
                    args = next_args;
                }
                Action::Residual { of, args } => {
                    return Ok(Value::Closure {
                        of: Box::new(of),
                        args,
                    })
                }
            }
        }
    }

    fn bind_staged_inputs(&self, of: &Value, args: Vec<Value>) -> Result<Vec<Value>, Error> {
        let (signature, has_comptime_params) = match of {
            Value::Function(name) => {
                let function = self
                    .functions
                    .get(name)
                    .ok_or_else(|| self.error(format!("unknown compile-time function '{name}'")))?;
                (&function.sig, function.has_comptime_params)
            }
            Value::Builtin { builtin, .. } => {
                let signature = builtin.signature();
                let has_comptime_params = signature.items.iter().any(|param| param.is_comptime);
                return Ok(bind_staged_inputs(&signature, has_comptime_params, args));
            }
            Value::Runtime { .. } | Value::Const(_) | Value::Boundary(_) | Value::Opaque { .. } => {
                return Ok(args)
            }
            Value::Closure { .. } => unreachable!("flatten_call leaves no outer closure"),
        };
        Ok(bind_staged_inputs(signature, has_comptime_params, args))
    }

    fn call_function(&self, name: &str, args: Vec<Value>) -> Result<Action, Error> {
        let function = self
            .functions
            .get(name)
            .ok_or_else(|| self.error(format!("unknown compile-time function '{name}'")))?;
        if args.len() != function.sig.items.len() {
            return Err(self.error(format!(
                "compile-time function '{}' expected {} arguments but got {}",
                name,
                function.sig.items.len(),
                args.len()
            )));
        }

        let mut env = function
            .sig
            .items
            .iter()
            .map(|param| param.name.clone())
            .zip(args)
            .collect::<HashMap<_, _>>();

        for item in &function.body.items {
            match item {
                hir::BlockItem::LitDef { name, literal } => {
                    env.insert(name.clone(), Value::Const(const_from_literal(literal)));
                }
                hir::BlockItem::ClosureDef(closure) => {
                    let of = self.resolve(&closure.of, &env)?;
                    let args = closure
                        .args
                        .iter()
                        .map(|name| self.resolve(name, &env))
                        .collect::<Result<Vec<_>, _>>()?;
                    env.insert(
                        closure.name.clone(),
                        Value::Closure {
                            of: Box::new(of),
                            args,
                        },
                    );
                }
                hir::BlockItem::Exec(exec) => {
                    let of = self.resolve(&exec.of, &env)?;
                    let args = exec
                        .args
                        .iter()
                        .map(|name| self.resolve(name, &env))
                        .collect::<Result<Vec<_>, _>>()?;
                    return Ok(Action::Call { of, args });
                }
                hir::BlockItem::Import { .. } | hir::BlockItem::SigDef { .. } => {}
                hir::BlockItem::FunctionDef(_) => {
                    return Err(self.error(
                        "nested HIR function was not hoisted before compile-time execution",
                    ))
                }
            }
        }

        Err(self.error(format!(
            "compile-time function '{name}' has no terminal execution"
        )))
    }

    fn call_builtin(
        &self,
        alias: &str,
        builtin: Builtin,
        args: Vec<Value>,
    ) -> Result<Action, Error> {
        let expected = builtin.signature().items.len();
        if args.len() != expected {
            return Err(self.error(format!(
                "compile-time builtin '@{}' expected {} arguments but got {}",
                builtin.name(),
                expected,
                args.len()
            )));
        }

        if builtin.comptime_route() == ComptimeRoute::Residual {
            if args.iter().any(contains_boundary) {
                return Ok(Action::Residual {
                    of: Value::Builtin {
                        alias: alias.to_string(),
                        builtin,
                    },
                    args,
                });
            }
            return Err(self.error(format!(
                "builtin '@{}' has no compile-time implementation before the runtime continuation",
                builtin.name()
            )));
        }

        if let Some(parameter) = args.iter().find_map(|value| match value {
            Value::Opaque { parameter, .. } => Some(parameter),
            _ => None,
        }) {
            return Err(self.error(format!(
                "compile-time builtin '@{}' cannot inspect unmarked parameter '{parameter}' before the runtime continuation; mark it with '!'",
                builtin.name()
            )));
        }

        match builtin {
            Builtin::CompileError => {
                let message = const_str(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "diagnostic message"))?;
                Err(self.error(message.to_string()))
            }
            Builtin::BytesFromStr => {
                let value = const_str(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "string value"))?;
                call(
                    &args[1],
                    vec![Value::Const(ConstValue::Bytes(value.as_bytes().to_vec()))],
                )
            }
            Builtin::BytesLen => {
                let value = const_bytes(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "bytes value"))?;
                let length = u64::try_from(value.len())
                    .map_err(|_| self.error("compile-time byte string length does not fit uint"))?;
                call(&args[1], vec![Value::Const(ConstValue::UInt(length))])
            }
            Builtin::BytesNth => {
                let value = const_bytes(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "bytes value"))?;
                let index = const_uint(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "byte index"))?;
                match usize::try_from(index)
                    .ok()
                    .and_then(|index| value.get(index))
                {
                    Some(value) => call(
                        &args[3],
                        vec![Value::Const(ConstValue::Fixed {
                            kind: hir::FixedIntKind::unsigned(8),
                            bits: u128::from(*value),
                        })],
                    ),
                    None => call(&args[2], Vec::new()),
                }
            }
            Builtin::StrRuneLen => {
                let value = const_str(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "string value"))?;
                let length = u64::try_from(value.chars().count())
                    .map_err(|_| self.error("compile-time string length does not fit uint"))?;
                call(&args[1], vec![Value::Const(ConstValue::UInt(length))])
            }
            Builtin::StrRuneNth => {
                let value = const_str(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "string value"))?;
                let index = const_uint(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "rune index"))?;
                let rune = usize::try_from(index)
                    .ok()
                    .and_then(|index| value.chars().nth(index));
                match rune {
                    Some(value) => call(
                        &args[3],
                        vec![Value::Const(ConstValue::Rune(u32::from(value)))],
                    ),
                    None => call(&args[2], Vec::new()),
                }
            }
            Builtin::StrFromUtf8 => {
                let value = const_bytes(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "bytes value"))?;
                match std::str::from_utf8(value) {
                    Ok(value) => call(
                        &args[2],
                        vec![Value::Const(ConstValue::Str(value.to_string()))],
                    ),
                    Err(_) => call(&args[1], Vec::new()),
                }
            }
            Builtin::Add | Builtin::Sub | Builtin::Mul => {
                let left = const_int(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_int(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                let value = match builtin {
                    Builtin::Add => left.wrapping_add(right),
                    Builtin::Sub => left.wrapping_sub(right),
                    Builtin::Mul => left.wrapping_mul(right),
                    _ => unreachable!(),
                };
                call(&args[2], vec![Value::Const(ConstValue::Int(value))])
            }
            Builtin::AddUInt | Builtin::SubUInt => {
                let left = const_uint(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_uint(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                let value = match builtin {
                    Builtin::AddUInt => left.wrapping_add(right),
                    Builtin::SubUInt => left.wrapping_sub(right),
                    _ => unreachable!(),
                };
                call(&args[2], vec![Value::Const(ConstValue::UInt(value))])
            }
            Builtin::AddBits(bit_width)
            | Builtin::SubBits(bit_width)
            | Builtin::MulBits(bit_width) => {
                let left = const_bits(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_bits(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                let value = match builtin {
                    Builtin::AddBits(_) => left.wrapping_add(right),
                    Builtin::SubBits(_) => left.wrapping_sub(right),
                    Builtin::MulBits(_) => left.wrapping_mul(right),
                    _ => unreachable!(),
                } & bit_mask(bit_width);
                call(
                    &args[2],
                    vec![Value::Const(ConstValue::Fixed {
                        kind: hir::FixedIntKind::bits(bit_width),
                        bits: value,
                    })],
                )
            }
            Builtin::ConvertFixed { to, .. } => {
                let value = const_bits(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "converted value"))?;
                call(
                    &args[1],
                    vec![Value::Const(ConstValue::Fixed {
                        kind: to,
                        bits: value & bit_mask(to.bit_width),
                    })],
                )
            }
            Builtin::U32FromRune => {
                let rune = const_rune(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "rune value"))?;
                call(
                    &args[1],
                    vec![Value::Const(ConstValue::Fixed {
                        kind: hir::FixedIntKind::unsigned(32),
                        bits: u128::from(rune),
                    })],
                )
            }
            Builtin::RuneFromU32 => {
                let value = const_bits(&args[0])
                    .and_then(|value| u32::try_from(value).ok())
                    .ok_or_else(|| self.runtime_dependency(builtin, "u32 value"))?;
                if char::from_u32(value).is_some() {
                    call(&args[2], vec![Value::Const(ConstValue::Rune(value))])
                } else {
                    call(&args[1], Vec::new())
                }
            }
            Builtin::U8FromInt => {
                let value = const_int(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "integer value"))?;
                if let Ok(value) = u8::try_from(value) {
                    call(
                        &args[2],
                        vec![Value::Const(ConstValue::Fixed {
                            kind: hir::FixedIntKind::unsigned(8),
                            bits: u128::from(value),
                        })],
                    )
                } else {
                    call(&args[1], Vec::new())
                }
            }
            Builtin::EqInt | Builtin::Lt | Builtin::Gt => {
                let left = const_int(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_int(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                let is_true = match builtin {
                    Builtin::EqInt => left == right,
                    Builtin::Lt => left < right,
                    Builtin::Gt => left > right,
                    _ => unreachable!(),
                };
                branch(is_true, &args[2], &args[3])
            }
            Builtin::EqUInt | Builtin::LtUInt => {
                let left = const_uint(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_uint(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                let is_true = match builtin {
                    Builtin::EqUInt => left == right,
                    Builtin::LtUInt => left < right,
                    _ => unreachable!(),
                };
                branch(is_true, &args[2], &args[3])
            }
            Builtin::EqBits(bit_width) => {
                let left = const_bits(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_bits(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                branch(
                    (left & bit_mask(bit_width)) == (right & bit_mask(bit_width)),
                    &args[2],
                    &args[3],
                )
            }
            Builtin::EqStr => {
                let left = const_str(&args[0])
                    .ok_or_else(|| self.runtime_dependency(builtin, "left operand"))?;
                let right = const_str(&args[1])
                    .ok_or_else(|| self.runtime_dependency(builtin, "right operand"))?;
                branch(left == right, &args[2], &args[3])
            }
            _ => unreachable!(
                "builtin '@{}' is routed to compile-time evaluation without an implementation",
                builtin.name()
            ),
        }
    }

    fn resolve(&self, name: &str, env: &HashMap<String, Value>) -> Result<Value, Error> {
        resolve_name(
            name,
            env,
            self.functions,
            self.globals,
            self.builtin_aliases,
            self.span,
        )
    }

    fn runtime_dependency(&self, builtin: Builtin, value: &str) -> Error {
        self.error(format!(
            "compile-time builtin '@{}' requires a known {value} before the runtime continuation",
            builtin.name()
        ))
    }

    fn error(&self, message: impl Into<String>) -> Error {
        Error::new(Code::Comptime, message, self.span)
    }
}

struct Materializer<'a> {
    next_id: usize,
    used_names: &'a mut HashSet<String>,
    span: Span,
}

impl Materializer<'_> {
    fn execute(&mut self, plan: Value) -> Result<Vec<hir::BlockItem>, Error> {
        let (of, args) = flatten_call(plan, Vec::new());
        let mut items = Vec::new();
        let of = self.emit_callable_head(of, &mut items)?;
        let args = args
            .into_iter()
            .map(|value| self.emit_value(value, &mut items))
            .collect::<Result<Vec<_>, _>>()?;
        items.push(hir::BlockItem::Exec(hir::Exec {
            of,
            args,
            is_comptime: false,
            span: self.span,
        }));
        Ok(items)
    }

    fn emit_callable_head(
        &mut self,
        value: Value,
        items: &mut Vec<hir::BlockItem>,
    ) -> Result<String, Error> {
        match value {
            Value::Function(name) | Value::Builtin { alias: name, .. } => Ok(name),
            Value::Boundary(value) => self.emit_callable_head(*value, items),
            Value::Opaque { value, .. } => self.emit_callable_head(*value, items),
            Value::Runtime { name, kind } => {
                if !matches!(kind, hir::SigKind::Sig(_)) {
                    return Err(self.error(format!(
                        "runtime value '{name}' is not callable at the residual boundary"
                    )));
                }
                Ok(name)
            }
            Value::Closure { .. } => {
                let (of, args) = flatten_call(value, Vec::new());
                let of = self.emit_callable_head(of, items)?;
                if args.is_empty() {
                    return Ok(of);
                }
                let args = args
                    .into_iter()
                    .map(|value| self.emit_value(value, items))
                    .collect::<Result<Vec<_>, _>>()?;
                let name = self.new_name();
                items.push(hir::BlockItem::ClosureDef(hir::Closure {
                    name: name.clone(),
                    of,
                    args,
                }));
                Ok(name)
            }
            Value::Const(_) => Err(self.error("residual execution target is not callable")),
        }
    }

    fn emit_value(
        &mut self,
        value: Value,
        items: &mut Vec<hir::BlockItem>,
    ) -> Result<String, Error> {
        match value {
            Value::Function(name) | Value::Builtin { alias: name, .. } => Ok(name),
            Value::Boundary(value) => self.emit_value(*value, items),
            Value::Opaque { value, .. } => self.emit_value(*value, items),
            Value::Runtime { name, .. } => Ok(name),
            Value::Closure { .. } => self.emit_callable_head(value, items),
            Value::Const(value) => {
                let literal = match value {
                    ConstValue::Str(value) => hir::Lit::Str(value),
                    ConstValue::Int(value) => hir::Lit::Int(value),
                    ConstValue::UInt(value) => hir::Lit::Int(isize::try_from(value).map_err(|_| {
                        self.error("residual uint constant does not fit an Afterflow integer literal")
                    })?),
                    ConstValue::Fixed { kind, bits } => {
                        let value = residual_fixed_value(kind, bits).ok_or_else(|| {
                            self.error("residual fixed-width constant does not fit an Afterflow integer literal")
                        })?;
                        hir::Lit::Int(value)
                    }
                    ConstValue::Rune(value) => hir::Lit::Int(isize::try_from(value).map_err(|_| {
                        self.error("residual rune does not fit an Afterflow integer literal")
                    })?),
                    ConstValue::F64(bits) => hir::Lit::F64(f64::from_bits(bits)),
                    ConstValue::Bytes(_) => {
                        return Err(self.error(
                            "compile-time bytes cannot cross the runtime continuation; retain their source string instead",
                        ))
                    }
                };
                let name = self.new_name();
                items.push(hir::BlockItem::LitDef {
                    name: name.clone(),
                    literal,
                });
                Ok(name)
            }
        }
    }

    fn new_name(&mut self) -> String {
        loop {
            let name = format!("__comptime_{}", self.next_id);
            self.next_id += 1;
            if self.used_names.insert(name.clone()) {
                return name;
            }
        }
    }

    fn error(&self, message: impl Into<String>) -> Error {
        Error::new(Code::Comptime, message, self.span)
    }
}

fn resolve_name(
    name: &str,
    env: &HashMap<String, Value>,
    functions: &HashMap<String, hir::Function>,
    globals: &HashMap<String, Value>,
    builtin_aliases: &HashMap<String, Builtin>,
    span: Span,
) -> Result<Value, Error> {
    if let Some(value) = env.get(name) {
        return Ok(value.clone());
    }
    if let Some(value) = globals.get(name) {
        return Ok(value.clone());
    }
    if functions.contains_key(name) {
        return Ok(Value::Function(name.to_string()));
    }
    if let Some(builtin) = builtin_aliases.get(name) {
        return Ok(Value::Builtin {
            alias: name.to_string(),
            builtin: *builtin,
        });
    }
    Err(Error::new(
        Code::Comptime,
        format!("unknown value '{name}' during compile-time execution"),
        span,
    ))
}

fn flatten_call(mut of: Value, mut args: Vec<Value>) -> (Value, Vec<Value>) {
    while let Value::Closure {
        of: closure_of,
        args: closure_args,
    } = of
    {
        let mut combined = closure_args;
        combined.extend(args);
        args = combined;
        of = *closure_of;
    }
    (of, args)
}

fn call(of: &Value, args: Vec<Value>) -> Result<Action, Error> {
    Ok(Action::Call {
        of: of.clone(),
        args,
    })
}

fn branch(is_true: bool, on_true: &Value, on_false: &Value) -> Result<Action, Error> {
    call(if is_true { on_true } else { on_false }, Vec::new())
}

fn const_from_literal(literal: &hir::Lit) -> ConstValue {
    match literal {
        hir::Lit::Str(value) => ConstValue::Str(value.clone()),
        hir::Lit::Int(value) => ConstValue::Int(*value),
        hir::Lit::F64(value) => ConstValue::F64(value.to_bits()),
    }
}

fn const_str(value: &Value) -> Option<&str> {
    match value {
        Value::Const(ConstValue::Str(value)) => Some(value),
        _ => None,
    }
}

fn const_bytes(value: &Value) -> Option<&[u8]> {
    match value {
        Value::Const(ConstValue::Bytes(value)) => Some(value),
        _ => None,
    }
}

fn const_int(value: &Value) -> Option<isize> {
    match value {
        Value::Const(ConstValue::Int(value)) => Some(*value),
        _ => None,
    }
}

fn const_uint(value: &Value) -> Option<u64> {
    match value {
        Value::Const(ConstValue::UInt(value)) => Some(*value),
        Value::Const(ConstValue::Int(value)) => u64::try_from(*value).ok(),
        Value::Const(ConstValue::Fixed { bits, .. }) => u64::try_from(*bits).ok(),
        Value::Const(ConstValue::Rune(value)) => Some(u64::from(*value)),
        _ => None,
    }
}

fn const_bits(value: &Value) -> Option<u128> {
    match value {
        Value::Const(ConstValue::Fixed { bits, .. }) => Some(*bits),
        Value::Const(ConstValue::Int(value)) => Some((*value as i128) as u128),
        Value::Const(ConstValue::UInt(value)) => Some(u128::from(*value)),
        Value::Const(ConstValue::Rune(value)) => Some(u128::from(*value)),
        _ => None,
    }
}

fn const_rune(value: &Value) -> Option<u32> {
    match value {
        Value::Const(ConstValue::Rune(value)) => Some(*value),
        Value::Const(ConstValue::Int(value)) => u32::try_from(*value).ok(),
        Value::Const(ConstValue::Fixed { bits, .. }) => u32::try_from(*bits).ok(),
        _ => None,
    }
}

fn bit_mask(bit_width: u16) -> u128 {
    match bit_width {
        128 => u128::MAX,
        width => (1_u128 << width) - 1,
    }
}

fn residual_fixed_value(kind: hir::FixedIntKind, bits: u128) -> Option<isize> {
    let bits = bits & bit_mask(kind.bit_width);
    match kind.interpretation {
        hir::FixedIntInterpretation::Signed => {
            let signed = if kind.bit_width == 128 {
                bits as i128
            } else {
                let sign = 1_u128 << (kind.bit_width - 1);
                if bits & sign == 0 {
                    bits as i128
                } else {
                    (bits | !bit_mask(kind.bit_width)) as i128
                }
            };
            isize::try_from(signed).ok()
        }
        hir::FixedIntInterpretation::Bits | hir::FixedIntInterpretation::Unsigned => {
            isize::try_from(bits).ok()
        }
    }
}

fn collect_runtime_names(value: &Value, names: &mut HashSet<String>) {
    match value {
        Value::Runtime { name, .. } => {
            names.insert(name.clone());
        }
        Value::Closure { of, args } => {
            collect_runtime_names(of, names);
            for arg in args {
                collect_runtime_names(arg, names);
            }
        }
        Value::Boundary(value) | Value::Opaque { value, .. } => collect_runtime_names(value, names),
        Value::Const(_) | Value::Function(_) | Value::Builtin { .. } => {}
    }
}

fn contains_boundary(value: &Value) -> bool {
    match value {
        Value::Boundary(_) => true,
        Value::Opaque { value, .. } => contains_boundary(value),
        Value::Closure { of, args } => contains_boundary(of) || args.iter().any(contains_boundary),
        Value::Const(_) | Value::Function(_) | Value::Builtin { .. } | Value::Runtime { .. } => {
            false
        }
    }
}

fn bind_staged_inputs(
    signature: &hir::Signature,
    has_comptime_params: bool,
    args: Vec<Value>,
) -> Vec<Value> {
    if signature.items.len() != args.len() || !has_comptime_params {
        return args;
    }
    signature
        .items
        .iter()
        .zip(args)
        .map(|(param, value)| {
            if param.is_comptime {
                value
            } else if matches!(param.kind, hir::SigKind::Sig(_)) {
                if matches!(value, Value::Boundary(_)) {
                    value
                } else {
                    Value::Boundary(Box::new(value))
                }
            } else if matches!(value, Value::Opaque { .. }) {
                value
            } else {
                Value::Opaque {
                    value: Box::new(value),
                    parameter: param.name.clone(),
                }
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use std::collections::BTreeSet;

    use super::*;

    #[test]
    fn evaluates_known_code_and_materializes_the_runtime_plan() {
        let mut functions = HashMap::from([
            (
                "compute".to_string(),
                function(
                    "compute",
                    vec![
                        comptime_param("value", hir::SigKind::Int),
                        param("ok", hir::SigKind::tuple([hir::SigKind::Int])),
                    ],
                    vec![
                        literal("b", hir::Lit::Int(2)),
                        exec("@add", ["value", "b", "ok"], false),
                    ],
                ),
            ),
            (
                "forward".to_string(),
                function(
                    "forward",
                    vec![
                        comptime_param("value", hir::SigKind::Int),
                        param("ok", hir::SigKind::tuple([hir::SigKind::Int])),
                    ],
                    vec![exec("compute", ["value", "ok"], true)],
                ),
            ),
            (
                "main".to_string(),
                function(
                    "main",
                    Vec::new(),
                    vec![
                        literal("value", hir::Lit::Int(1)),
                        exec("forward", ["value", "@exit"], true),
                    ],
                ),
            ),
        ]);
        let aliases = HashMap::from([
            ("@add".to_string(), Builtin::Add),
            ("@exit".to_string(), Builtin::Exit),
        ]);

        rewrite(&mut functions, &mut Vec::new(), &aliases).unwrap();

        let items = &functions["main"].body.items;
        assert_eq!(items.len(), 2);
        let hir::BlockItem::LitDef { name, literal } = &items[0] else {
            panic!("expected residual literal")
        };
        assert_eq!(*literal, hir::Lit::Int(3));
        let hir::BlockItem::Exec(residual) = &items[1] else {
            panic!("expected residual execution")
        };
        assert_eq!(residual.of, "@exit");
        assert_eq!(residual.args, vec![name.clone()]);
        assert!(!residual.is_comptime);
    }

    #[test]
    fn residualizes_runtime_effects_that_lead_into_a_boundary() {
        let mut functions = HashMap::from([
            (
                "emit".to_string(),
                function(
                    "emit",
                    vec![
                        comptime_param("marker", hir::SigKind::Int),
                        param("message", hir::SigKind::Str),
                        param("ok", hir::SigKind::tuple([])),
                    ],
                    vec![exec("@write", ["message", "ok"], false)],
                ),
            ),
            (
                "main".to_string(),
                function(
                    "main",
                    Vec::new(),
                    vec![
                        literal("marker", hir::Lit::Int(0)),
                        literal("message", hir::Lit::Str("hello".to_string())),
                        exec("emit", ["marker", "message", "@exit"], true),
                    ],
                ),
            ),
        ]);
        let aliases = HashMap::from([
            ("@write".to_string(), Builtin::Write),
            ("@exit".to_string(), Builtin::Exit),
        ]);

        rewrite(&mut functions, &mut Vec::new(), &aliases).unwrap();

        let items = &functions["main"].body.items;
        assert_eq!(items.len(), 2);
        let hir::BlockItem::LitDef { name, literal } = &items[0] else {
            panic!("expected residual message")
        };
        assert_eq!(*literal, hir::Lit::Str("hello".to_string()));
        let hir::BlockItem::Exec(residual) = &items[1] else {
            panic!("expected residual write")
        };
        assert_eq!(residual.of, "@write");
        assert_eq!(residual.args, vec![name.clone(), "@exit".to_string()]);
        assert!(!residual.is_comptime);
    }

    #[test]
    fn rejects_a_literal_in_an_unmarked_staged_slot() {
        let mut functions = HashMap::from([
            (
                "inspect".to_string(),
                function(
                    "inspect",
                    vec![
                        param("template", hir::SigKind::Str),
                        comptime_param("marker", hir::SigKind::Int),
                        param("ok", hir::SigKind::tuple([hir::SigKind::Bytes])),
                    ],
                    vec![exec("@bytes_from_str", ["template", "ok"], false)],
                ),
            ),
            (
                "main".to_string(),
                function(
                    "main",
                    Vec::new(),
                    vec![
                        literal("template", hir::Lit::Str("value".to_string())),
                        literal("marker", hir::Lit::Int(0)),
                        exec("inspect", ["template", "marker", "@exit"], true),
                    ],
                ),
            ),
        ]);
        let aliases = HashMap::from([
            ("@bytes_from_str".to_string(), Builtin::BytesFromStr),
            ("@exit".to_string(), Builtin::Exit),
        ]);

        let error = rewrite(&mut functions, &mut Vec::new(), &aliases).unwrap_err();

        assert_eq!(error.code, Code::Comptime);
        assert_eq!(
            error.message,
            "compile-time builtin '@bytes_from_str' cannot inspect unmarked parameter 'template' before the runtime continuation; mark it with '!'"
        );
    }

    #[test]
    fn materializes_an_unmarked_literal_after_the_runtime_boundary() {
        let mut functions = HashMap::from([
            (
                "forward".to_string(),
                function(
                    "forward",
                    vec![
                        comptime_param("marker", hir::SigKind::Int),
                        param("value", hir::SigKind::Int),
                        param("ok", hir::SigKind::tuple([hir::SigKind::Int])),
                    ],
                    vec![exec("ok", ["value"], false)],
                ),
            ),
            (
                "main".to_string(),
                function(
                    "main",
                    Vec::new(),
                    vec![
                        literal("marker", hir::Lit::Int(0)),
                        literal("value", hir::Lit::Int(7)),
                        exec("forward", ["marker", "value", "@exit"], true),
                    ],
                ),
            ),
        ]);
        let aliases = HashMap::from([("@exit".to_string(), Builtin::Exit)]);

        rewrite(&mut functions, &mut Vec::new(), &aliases).unwrap();

        let items = &functions["main"].body.items;
        assert_eq!(items.len(), 2);
        let hir::BlockItem::LitDef { name, literal } = &items[0] else {
            panic!("expected residual literal")
        };
        assert_eq!(*literal, hir::Lit::Int(7));
        let hir::BlockItem::Exec(residual) = &items[1] else {
            panic!("expected residual execution")
        };
        assert_eq!(residual.of, "@exit");
        assert_eq!(residual.args, vec![name.clone()]);
        assert!(!residual.is_comptime);
    }

    #[test]
    fn compile_error_uses_the_marked_call_span() {
        let span = Span {
            line: 7,
            column: 9,
            offset: 11,
        };
        let mut functions = HashMap::from([(
            "main".to_string(),
            hir::Function {
                name: "main".to_string(),
                sig: signature(Vec::new()),
                body: hir::Block {
                    items: vec![
                        literal("message", hir::Lit::Str("invalid DSL".to_string())),
                        hir::BlockItem::Exec(hir::Exec {
                            of: "@compile_error".to_string(),
                            args: vec!["message".to_string(), "fallback".to_string()],
                            is_comptime: true,
                            span,
                        }),
                    ],
                },
                has_comptime_params: false,
            },
        )]);
        functions.insert(
            "fallback".to_string(),
            function("fallback", Vec::new(), vec![exec("@exit", ["code"], false)]),
        );
        let mut entry = vec![literal("code", hir::Lit::Int(1))];
        let aliases = HashMap::from([
            ("@compile_error".to_string(), Builtin::CompileError),
            ("@exit".to_string(), Builtin::Exit),
        ]);

        let error = rewrite(&mut functions, &mut entry, &aliases).unwrap_err();

        assert_eq!(error.code, Code::Comptime);
        assert_eq!(error.message, "invalid DSL");
        assert_eq!(error.span.line, span.line);
        assert_eq!(error.span.column, span.column);
        assert_eq!(error.span.offset, span.offset);
    }

    fn function(
        name: &str,
        params: Vec<hir::SigItem>,
        items: Vec<hir::BlockItem>,
    ) -> hir::Function {
        hir::Function {
            name: name.to_string(),
            has_comptime_params: params.iter().any(|param| param.is_comptime),
            sig: signature(params),
            body: hir::Block { items },
        }
    }

    fn signature(items: Vec<hir::SigItem>) -> hir::Signature {
        hir::Signature {
            items,
            generics: BTreeSet::new(),
        }
    }

    fn param(name: &str, kind: hir::SigKind) -> hir::SigItem {
        hir::SigItem {
            name: name.to_string(),
            kind,
            is_comptime: false,
        }
    }

    fn comptime_param(name: &str, kind: hir::SigKind) -> hir::SigItem {
        hir::SigItem {
            name: name.to_string(),
            kind,
            is_comptime: true,
        }
    }

    fn literal(name: &str, literal: hir::Lit) -> hir::BlockItem {
        hir::BlockItem::LitDef {
            name: name.to_string(),
            literal,
        }
    }

    fn exec<const N: usize>(of: &str, args: [&str; N], is_comptime: bool) -> hir::BlockItem {
        hir::BlockItem::Exec(hir::Exec {
            of: of.to_string(),
            args: args.into_iter().map(str::to_string).collect(),
            is_comptime,
            span: Span::unknown(),
        })
    }
}
