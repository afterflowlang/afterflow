use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};

pub use crate::compiler::air_ast::*;
use crate::compiler::builtins;
use crate::compiler::error::{Code, Error};
use crate::compiler::hir;
use crate::compiler::signature;
use crate::compiler::span::Span;
use crate::compiler::symbol::{self, SymbolRegistry};

const NUM_REMAINING_METADATA_WORD_OFFSET: usize = 5;

pub const ENTRY_FUNCTION_NAME: &str = "_start";

fn closure_unwrapper_label(name: &str) -> String {
    format!("{}_unwrapper", name)
}

fn closure_deep_release_label(name: &str) -> String {
    format!("{}_deep_release", name)
}

fn closure_deepcopy_label(name: &str) -> String {
    format!("{}_deepcopy", name)
}

fn conditional_builtin_branch_label(
    sig: &FunctionSig,
    continuation: &AirArg,
    branch: &str,
) -> String {
    let span = Span::unknown();
    format!(
        "{}_{}_{}_{}_{}",
        crate::sanitize_function_name(&sig.name),
        crate::sanitize_function_name(&continuation.name),
        branch,
        span.line,
        span.column
    )
}

impl AirNewClosure {
    pub fn unwrapper_label(&self) -> String {
        closure_unwrapper_label(&self.target.name)
    }

    pub fn deep_release_label(&self) -> String {
        closure_deep_release_label(&self.target.name)
    }

    pub fn deepcopy_label(&self) -> String {
        closure_deepcopy_label(&self.target.name)
    }
}

pub struct FunctionLowerer {
    pending: HashMap<String, hir::Function>,
    lowered: HashSet<String>,
    in_progress: HashSet<String>,
    specializations: HashMap<(String, Vec<SigKind>), FunctionSig>,
    next_specialization_id: usize,
    generated: Vec<AirFunction>,
}

impl FunctionLowerer {
    pub fn new(functions: HashMap<String, hir::Function>) -> Self {
        Self {
            pending: functions,
            lowered: HashSet::new(),
            in_progress: HashSet::new(),
            specializations: HashMap::new(),
            next_specialization_id: 0,
            generated: Vec::new(),
        }
    }

    pub fn ensure(&mut self, name: &str, symbols: &mut SymbolRegistry) -> Result<(), Error> {
        if self.lowered.contains(name) || self.in_progress.contains(name) {
            return Ok(());
        }
        let function = match self.pending.get(name).cloned() {
            Some(func) => func,
            None => {
                return Ok(());
            }
        };
        self.in_progress.insert(name.to_string());
        let lowered = lower_function(&function, symbols, self);
        self.in_progress.remove(name);
        match lowered {
            Ok(funcs) => {
                self.lowered.insert(name.to_string());
                self.generated.extend(funcs);
                Ok(())
            }
            Err(err) => Err(err),
        }
    }

    fn ensure_for_args(
        &mut self,
        target: &FunctionSig,
        arg_kinds: &[SigKind],
        symbols: &mut SymbolRegistry,
    ) -> Result<FunctionSig, Error> {
        let Some(function) = self.pending.get(&target.name).cloned() else {
            return Ok(target.clone());
        };
        if function.sig.generics.is_empty() {
            self.ensure(&target.name, symbols)?;
            return Ok(target.clone());
        }

        let mut bindings = HashMap::new();
        for (param, actual) in function.sig.items.iter().zip(arg_kinds) {
            bind_generic_kinds(&param.kind, actual, &function.sig.generics, &mut bindings)?;
        }
        let concrete_kinds = function
            .sig
            .generics
            .iter()
            .map(|name| {
                bindings
                    .entry(name.clone())
                    .or_insert_with(|| SigKind::Generic(name.clone()))
                    .clone()
            })
            .collect::<Vec<_>>();
        let key = (target.name.clone(), concrete_kinds);
        if let Some(sig) = self.specializations.get(&key) {
            return Ok(sig.clone());
        }

        let specialized_name = format!("{}__generic_{}", target.name, self.next_specialization_id);
        self.next_specialization_id += 1;
        let mut specialized = function;
        specialized.name = specialized_name;
        specialized.sig = signature::substitute_signature(&specialized.sig, &bindings);
        let specialized_sig = function_sig_from_hir(&specialized);
        self.specializations.insert(key, specialized_sig.clone());

        self.in_progress.insert(specialized.name.clone());
        let lowered = lower_function(&specialized, symbols, self);
        self.in_progress.remove(&specialized.name);
        match lowered {
            Ok(funcs) => {
                self.lowered.insert(specialized.name);
                self.generated.extend(funcs);
                Ok(specialized_sig)
            }
            Err(err) => Err(err),
        }
    }

    pub fn take_generated_functions(self) -> Vec<AirFunction> {
        self.generated
    }
}

pub struct AirLowerContext<'a> {
    symbols: &'a mut SymbolRegistry,
    function_lowerer: &'a mut FunctionLowerer,
    locals: HashSet<String>,
    generated_functions: Vec<AirFunction>,
    owned_values: HashMap<String, SigKind>,
    literals: HashMap<String, Lit>,
    value_kinds: HashMap<String, SigKind>,
    closure_remaining: HashMap<String, Vec<SigKind>>, // TODO: Why is this needed?
    remaining_uses: HashMap<String, usize>,
}

impl<'a> AirLowerContext<'a> {
    pub fn new(
        symbols: &'a mut SymbolRegistry,
        function_lowerer: &'a mut FunctionLowerer,
        remaining_uses: HashMap<String, usize>,
    ) -> Self {
        Self {
            symbols,
            function_lowerer,
            locals: HashSet::new(),
            generated_functions: Vec::new(),
            owned_values: HashMap::new(),
            literals: HashMap::new(),
            value_kinds: HashMap::new(),
            closure_remaining: HashMap::new(),
            remaining_uses,
        }
    }

    pub fn push_generated_function(&mut self, function: AirFunction) {
        self.generated_functions.push(function);
    }

    pub fn into_generated_functions(self) -> Vec<AirFunction> {
        self.generated_functions
    }

    pub fn count_remaining_use(&mut self, name: &str) -> usize {
        if let Some(count) = self.remaining_uses.get_mut(name) {
            let previous = *count;
            *count = count.saturating_sub(1);
            previous
        } else {
            0
        }
    }
}

fn collect_owned_values(params: &[SigItem]) -> HashMap<String, SigKind> {
    params
        .iter()
        .filter(|param| is_owned_type(&param.kind))
        .map(|param| (param.name.clone(), param.kind.clone()))
        .collect()
}

fn drop_owned_value(name: String, kind: &SigKind) -> AirStmt {
    match kind {
        SigKind::Sig(_) => AirStmt::op(AirOp::DropClosure(AirDropClosure { name })),
        SigKind::Str | SigKind::Bytes => {
            AirStmt::op(AirOp::DropDescriptor(AirDropDescriptor { name }))
        }
        _ => unreachable!("only owned values may be dropped"),
    }
}

fn take_drop_statements(owned: &mut HashMap<String, SigKind>) -> Vec<AirStmt> {
    let values: BTreeMap<_, _> = owned.drain().collect();
    if values.is_empty() {
        return Vec::new();
    }
    values
        .into_iter()
        .map(|(name, kind)| drop_owned_value(name, &kind))
        .collect()
}

fn prepare_args(
    ctx: &mut AirLowerContext,
    args: &[String],
    statements: &mut Vec<AirStmt>,
) -> Result<(), Error> {
    for arg in args {
        // checks whether this argument is already a local binding before generating a closure for it.
        // This prevents re-wrapping a name that's already been bound/converted earlier
        // (e.g., because it was already turned into a captured closure or defined locally) and keeps the argument list stable.
        if ctx.locals.contains(arg) {
            continue;
        }
        if let Some(closure) = create_closure(ctx, arg, None)? {
            let name = closure.name.clone();
            let remaining = closure.target.param_kinds();
            statements.push(AirStmt::op(AirOp::NewClosure(closure)));
            ctx.locals.insert(name.clone());
            let kind = SigKind::Sig(hir::Signature::from_kinds(remaining.clone()));
            ctx.owned_values.insert(name.clone(), kind.clone());
            ctx.value_kinds.insert(name.clone(), kind);
            if !remaining.is_empty() {
                ctx.closure_remaining.insert(name, remaining);
            }
        }
    }
    Ok(())
}

fn create_closure(
    ctx: &mut AirLowerContext,
    target: &str,
    sig_override: Option<&mut FunctionSig>,
) -> Result<Option<AirNewClosure>, Error> {
    if sig_override.is_some() {
        return Ok(None);
    }

    if let Some(orig_sig) = ctx.symbols.get_function(target).cloned() {
        ctx.function_lowerer.ensure(target, ctx.symbols)?;
        return Ok(Some(AirNewClosure {
            target: orig_sig,
            args: Vec::new(),
            name: target.to_string(),
        }));
    }

    if let Some(builtin_name) = ctx.symbols.builtin_name_for_alias(target) {
        let builtin_sig = symbol::builtin_function_sig(builtin_name)?;
        return Ok(Some(AirNewClosure {
            target: builtin_sig,
            args: Vec::new(),
            name: target.to_string(),
        }));
    }

    Ok(None)
}

pub fn entry_function(
    entry_items: Vec<hir::BlockItem>,
    symbols: &mut SymbolRegistry,
    function_lowerer: &mut FunctionLowerer,
) -> Result<Vec<AirFunction>, Error> {
    let mut ctx = AirLowerContext::new(symbols, function_lowerer, count_block_uses(&entry_items));
    let mut items: Vec<AirStmt> = Vec::new();
    for item in entry_items.into_iter() {
        match item {
            hir::BlockItem::Import { .. }
            | hir::BlockItem::FunctionDef(..)
            | hir::BlockItem::SigDef { .. } => {} // already handled
            other => {
                items.extend(lower_block_item(&mut ctx, other)?);
            }
        }
    }
    ctx.push_generated_function(AirFunction {
        sig: FunctionSig {
            name: ENTRY_FUNCTION_NAME.into(),
            params: Vec::new(),
            generics: BTreeSet::new(),
            builtin: None,
        },
        items,
    });
    Ok(ctx.into_generated_functions())
}

pub fn lower_function(
    func: &hir::Function,
    symbols: &mut SymbolRegistry,
    function_lowerer: &mut FunctionLowerer,
) -> Result<Vec<AirFunction>, Error> {
    let sig = function_sig_from_hir(func);
    let params = sig.params.clone();
    symbols.declare_function(sig.clone());

    let mut ctx = AirLowerContext::new(
        symbols,
        function_lowerer,
        count_block_uses(&func.body.items),
    );
    for param in func.sig.items.iter() {
        ctx.locals.insert(param.name.clone());
        ctx.value_kinds.insert(
            param.name.clone(),
            air_sig_kind_from_hir(&param.kind, &func.sig.generics),
        );
        if let SigKind::Sig(signature) = &param.kind {
            ctx.closure_remaining
                .insert(param.name.clone(), signature.kinds());
        }
    }
    ctx.owned_values = collect_owned_values(&params);

    let mut lowered_items: Vec<AirStmt> = Vec::new();
    for item in func.body.items.iter() {
        let lowered = lower_block_item(&mut ctx, item.clone())?;
        lowered_items.extend(lowered);
    }

    let function = AirFunction {
        sig,
        items: lowered_items,
    };

    let mut functions: Vec<AirFunction> = vec![function.clone()];
    // TODO: Only generate these helpers if needed.
    functions.extend(build_closure_helpers(&function.sig));
    functions.extend(ctx.into_generated_functions());
    Ok(functions)
}

fn build_closure_helpers(sig: &FunctionSig) -> Vec<AirFunction> {
    let function = AirFunction {
        sig: sig.clone(),
        items: Vec::new(),
    };
    [
        build_closure_unwrapper(&function),
        build_deep_release_helper(&function),
        build_deep_copy_helper(&function),
    ]
    .into_iter()
    .flatten()
    .collect()
}

pub fn function_sig_from_hir(function: &hir::Function) -> FunctionSig {
    FunctionSig {
        name: function.name.clone(),
        params: air_sig_items_from_hir(&function.sig.items, &function.sig.generics),
        generics: function.sig.generics.clone(),
        builtin: None,
    }
}

fn air_sig_items_from_hir(items: &[SigItem], generics: &BTreeSet<String>) -> Vec<SigItem> {
    items
        .iter()
        .map(|item| SigItem {
            name: item.name.clone(),
            kind: air_sig_kind_from_hir(&item.kind, generics),
            is_comptime: item.is_comptime,
        })
        .collect()
}

fn air_sig_kind_from_hir(kind: &SigKind, generics: &BTreeSet<String>) -> SigKind {
    match kind {
        SigKind::Generic(_) => kind.clone(),
        SigKind::Ident(ident) if generics.contains(&ident.name) => kind.clone(),
        SigKind::Sig(signature) => SigKind::Sig(hir::Signature {
            items: air_sig_items_from_hir(&signature.items, generics),
            generics: signature.generics.clone(),
        }),
        SigKind::GenericInst { name, args } => SigKind::GenericInst {
            name: name.clone(),
            args: args
                .iter()
                .map(|arg| air_sig_kind_from_hir(arg, generics))
                .collect(),
        },
        other => other.clone(),
    }
}

fn lower_block_item(
    ctx: &mut AirLowerContext,
    item: hir::BlockItem,
) -> Result<Vec<AirStmt>, Error> {
    let lowered = match item {
        hir::BlockItem::FunctionDef(..) => {
            // TODO: This should be unreachable?!
            vec![]
        }
        hir::BlockItem::LitDef { name, literal } => {
            ctx.locals.insert(name.clone());
            ctx.value_kinds.insert(
                name.clone(),
                match &literal {
                    Lit::Str(_) => SigKind::Str,
                    Lit::Int(_) => SigKind::Int,
                    Lit::F64(_) => SigKind::F64,
                },
            );
            ctx.literals.insert(name.clone(), literal);
            vec![]
        }
        hir::BlockItem::ClosureDef(closure) => {
            if ctx.locals.contains(&closure.of) && ctx.closure_remaining.contains_key(&closure.of) {
                lower_closure_curry(&closure, ctx)?
            } else {
                lower_new_closure(&closure, ctx)?
            }
        }
        hir::BlockItem::Exec(exec) => lower_exec(&exec, ctx)?,
        _ => unreachable!("unexpected block item: {:#?}", item),
    };
    Ok(lowered)
}

fn count_block_uses(items: &[hir::BlockItem]) -> HashMap<String, usize> {
    let mut uses: HashMap<String, usize> = HashMap::new();
    for item in items {
        match item {
            hir::BlockItem::ClosureDef(closure) => {
                *uses.entry(closure.of.clone()).or_insert(0) += 1;
                for arg in &closure.args {
                    *uses.entry(arg.clone()).or_insert(0) += 1;
                }
            }
            hir::BlockItem::Exec(exec) => {
                *uses.entry(exec.of.clone()).or_insert(0) += 1;
                for arg in &exec.args {
                    *uses.entry(arg.clone()).or_insert(0) += 1;
                }
            }
            _ => {}
        }
    }
    uses
}

fn ensure_target(
    ctx: &mut AirLowerContext,
    args: &[String],
    target_name: &str,
) -> Result<(Vec<AirStmt>, AirExecTarget, Vec<AirArg>), Error> {
    let mut block_items = Vec::new();
    prepare_args(ctx, args, &mut block_items)?;
    let mut target = if ctx.locals.contains(target_name) {
        AirExecTarget::Closure {
            name: target_name.to_string(),
        }
    } else {
        resolve_target(target_name, ctx.symbols)?
    };
    if let AirExecTarget::Function(sig) = &mut target {
        if !sig.generics.is_empty() {
            let arg_kinds = args
                .iter()
                .map(|arg| value_kind(ctx, arg))
                .collect::<Result<Vec<_>, _>>()?;
            *sig = ctx
                .function_lowerer
                .ensure_for_args(sig, &arg_kinds, ctx.symbols)?;
        } else {
            ctx.function_lowerer.ensure(&sig.name, ctx.symbols)?;
        }
        create_closure(ctx, target_name, Some(sig))?;
    }
    let args = extract_closure_sig_info(&target, args, &ctx.literals, &ctx.closure_remaining);
    Ok((block_items, target, args))
}

fn value_kind(ctx: &AirLowerContext, name: &str) -> Result<SigKind, Error> {
    if let Some(kind) = ctx.value_kinds.get(name) {
        return Ok(kind.clone());
    }
    if let Some(remaining) = ctx.closure_remaining.get(name) {
        return Ok(SigKind::Sig(hir::Signature::from_kinds(remaining.clone())));
    }
    Err(Error::new(
        Code::Internal,
        format!("missing AIR type for argument '{name}'"),
        Span::unknown(),
    ))
}

fn bind_generic_kinds(
    expected: &SigKind,
    actual: &SigKind,
    generics: &BTreeSet<String>,
    bindings: &mut HashMap<String, SigKind>,
) -> Result<(), Error> {
    let generic_name = match expected {
        SigKind::Generic(name) => Some(name),
        SigKind::Ident(ident) if generics.contains(&ident.name) => Some(&ident.name),
        _ => None,
    };
    if let Some(name) = generic_name {
        if let Some(bound) = bindings.get(name) {
            if bound != actual {
                return Err(Error::new(
                    Code::Internal,
                    format!("inconsistent AIR types for generic parameter '{name}'"),
                    Span::unknown(),
                ));
            }
        } else {
            bindings.insert(name.clone(), actual.clone());
        }
        return Ok(());
    }

    match (expected, actual) {
        (SigKind::Sig(expected), SigKind::Sig(actual)) => {
            for (expected, actual) in expected.items.iter().zip(&actual.items) {
                bind_generic_kinds(&expected.kind, &actual.kind, generics, bindings)?;
            }
        }
        (
            SigKind::GenericInst {
                name: expected_name,
                args: expected_args,
            },
            SigKind::GenericInst {
                name: actual_name,
                args: actual_args,
            },
        ) if expected_name == actual_name => {
            for (expected, actual) in expected_args.iter().zip(actual_args) {
                bind_generic_kinds(expected, actual, generics, bindings)?;
            }
        }
        _ => {}
    }
    Ok(())
}

fn closure_remaining_after_applying(
    closure_remaining: &HashMap<String, Vec<SigKind>>,
    target: &AirExecTarget,
    applied: usize,
) -> Option<Vec<SigKind>> {
    let remaining = match target {
        AirExecTarget::Function(sig) => sig.param_kinds(),
        AirExecTarget::Closure { name } => closure_remaining.get(name).cloned()?,
    };
    if remaining.is_empty() {
        return None;
    }
    let applied = applied.min(remaining.len());
    Some(remaining[applied..].to_vec())
}

fn prepare_owned_arguments(
    ctx: &mut AirLowerContext,
    args: Vec<AirArg>,
    use_counts: &[usize],
    owner: &str,
    statements: &mut Vec<AirStmt>,
) -> Result<Vec<AirArg>, Error> {
    args.into_iter()
        .enumerate()
        .map(|(idx, arg)| {
            if !is_owned_type(&arg.kind) || arg.literal.is_some() {
                return Ok(arg);
            }
            if use_counts.get(idx).copied().unwrap_or_default() <= 1 {
                ctx.owned_values.remove(&arg.name);
                return Ok(arg);
            }
            let name = format!("__{owner}_arg_clone_{idx}");
            let op = match &arg.kind {
                SigKind::Sig(signature) => AirOp::CloneClosure(AirCloneClosure {
                    src: arg.name,
                    dst: name.clone(),
                    remaining: signature.kinds(),
                }),
                SigKind::Str | SigKind::Bytes => AirOp::CloneDescriptor(AirCloneDescriptor {
                    src: arg.name,
                    dst: name.clone(),
                }),
                _ => unreachable!("only owned arguments may be cloned"),
            };
            statements.push(AirStmt::op(op));
            Ok(AirArg {
                name,
                kind: arg.kind,
                literal: None,
            })
        })
        .collect()
}

fn lower_new_closure(
    closure: &hir::Closure,
    ctx: &mut AirLowerContext,
) -> Result<Vec<AirStmt>, Error> {
    ctx.count_remaining_use(&closure.of);
    let use_counts = closure
        .args
        .iter()
        .map(|arg| ctx.count_remaining_use(arg))
        .collect::<Vec<_>>();
    let (mut block_items, target, args) = ensure_target(ctx, &closure.args, &closure.of)?;
    ctx.locals.insert(closure.name.clone());
    let args = prepare_owned_arguments(ctx, args, &use_counts, &closure.name, &mut block_items)?;

    let new_remaining =
        closure_remaining_after_applying(&ctx.closure_remaining, &target, args.len());
    let target_sig = match target {
        AirExecTarget::Function(sig) => sig,
        _ => {
            return Err(Error::new(
                Code::Internal,
                "expected function target when creating new closure".to_string(),
                Span::unknown(),
            ));
        }
    };
    if target_sig.builtin.is_some() {
        for helper in build_closure_helpers(&target_sig) {
            ctx.push_generated_function(helper);
        }
    }
    block_items.push(AirStmt::op(AirOp::NewClosure(AirNewClosure {
        name: closure.name.clone(),
        target: target_sig.clone(),
        args,
    })));
    if let Some(remaining) = new_remaining {
        let kind = SigKind::Sig(hir::Signature::from_kinds(remaining.clone()));
        ctx.owned_values.insert(closure.name.clone(), kind.clone());
        ctx.value_kinds.insert(closure.name.clone(), kind);
        ctx.closure_remaining
            .insert(closure.name.clone(), remaining);
    }
    Ok(block_items)
}

fn lower_closure_curry(
    closure: &hir::Closure,
    ctx: &mut AirLowerContext,
) -> Result<Vec<AirStmt>, Error> {
    let source_use_count = ctx.count_remaining_use(&closure.of);
    let arg_use_counts = closure
        .args
        .iter()
        .map(|arg| ctx.count_remaining_use(arg))
        .collect::<Vec<_>>();
    let existing_remaining = ctx
        .closure_remaining
        .get(&closure.of)
        .cloned()
        .ok_or_else(|| {
            Error::new(
                Code::Internal,
                format!("missing closure signature for '{}'", closure.of),
                Span::unknown(),
            )
        })?;

    let (mut block_items, _, _) = ensure_target(ctx, &closure.args, &closure.of)?;

    let applied = closure.args.len().min(existing_remaining.len());
    let mut args = Vec::with_capacity(closure.args.len());
    for (idx, arg) in closure.args.iter().enumerate() {
        let kind = existing_remaining.get(idx).cloned().unwrap_or(SigKind::Int);
        args.push(AirArg {
            name: arg.clone(),
            kind,
            literal: literal_for_arg(arg, &ctx.literals),
        });
    }
    ctx.locals.insert(closure.name.clone());
    if source_use_count > 1 {
        block_items.push(AirStmt::op(AirOp::CloneClosure(AirCloneClosure {
            src: closure.of.clone(),
            dst: closure.name.clone(),
            remaining: existing_remaining.clone(),
        })));
    } else {
        block_items.push(AirStmt::op(AirOp::MoveClosure(AirMoveClosure {
            src: closure.of.clone(),
            dst: closure.name.clone(),
        })));
        ctx.owned_values.remove(&closure.of);
    }
    let stored_args =
        prepare_owned_arguments(ctx, args, &arg_use_counts, &closure.name, &mut block_items)?;

    let env_end_binding = format!("__{}_env_end", closure.name);
    block_items.push(AirStmt::op(AirOp::Pin(AirPin {
        result: env_end_binding.clone(),
        value: AirValue::Binding(closure.name.clone()),
    })));

    let suffix_word_counts = suffix_word_counts(&existing_remaining);
    for (idx, arg) in stored_args.iter().take(applied).enumerate() {
        let offset_words = suffix_word_counts[idx] as isize;
        block_items.push(AirStmt::op(AirOp::SetField(AirSetField {
            env_end: env_end_binding.clone(),
            offset: -offset_words,
            value: arg.clone(),
        })));
    }

    let remaining = existing_remaining[applied..].to_vec();
    let remaining_words = word_count_from_kinds(&remaining) as isize;
    block_items.push(AirStmt::op(AirOp::SetField(AirSetField {
        env_end: env_end_binding,
        offset: NUM_REMAINING_METADATA_WORD_OFFSET as isize,
        value: AirArg {
            name: format!("__{}_num_remaining_value", closure.name),
            kind: SigKind::Int,
            literal: Some(Lit::Int(remaining_words)),
        },
    })));

    ctx.closure_remaining
        .insert(closure.name.clone(), remaining.clone());
    let kind = SigKind::Sig(hir::Signature::from_kinds(remaining));
    ctx.owned_values.insert(closure.name.clone(), kind.clone());
    ctx.value_kinds.insert(closure.name.clone(), kind);

    Ok(block_items)
}

fn lower_exec(exec: &hir::Exec, ctx: &mut AirLowerContext) -> Result<Vec<AirStmt>, Error> {
    if exec.is_comptime {
        return Err(Error::new(
            Code::Internal,
            "compile-time execution reached AIR without being residualized",
            exec.span,
        ));
    }
    let exec = exec.clone();
    let target_use_count = ctx.count_remaining_use(&exec.of);
    let arg_use_counts = exec
        .args
        .iter()
        .map(|arg| ctx.count_remaining_use(arg))
        .collect::<Vec<_>>();
    let (mut block_items, mut target, args) = ensure_target(ctx, &exec.args, &exec.of)?;
    if let AirExecTarget::Closure { name } = &target {
        if target_use_count > 1 {
            let remaining = match value_kind(ctx, name)? {
                SigKind::Sig(signature) => signature.kinds(),
                _ => {
                    return Err(Error::new(
                        Code::Internal,
                        format!("expected closure type for '{name}'"),
                        Span::unknown(),
                    ));
                }
            };
            let clone_name = format!("__{}_target_clone", exec.of);
            block_items.push(AirStmt::op(AirOp::CloneClosure(AirCloneClosure {
                src: name.clone(),
                dst: clone_name.clone(),
                remaining,
            })));
            target = AirExecTarget::Closure { name: clone_name };
        } else {
            ctx.owned_values.remove(name);
        }
    }
    let args = prepare_owned_arguments(ctx, args, &arg_use_counts, &exec.of, &mut block_items)?;

    if let AirExecTarget::Function(sig) = &target {
        if let Some(builtin) = sig.builtin {
            match builtin.air_route() {
                builtins::AirRoute::Call => {
                    block_items.extend(take_drop_statements(&mut ctx.owned_values));
                    let builtin_items = lower_builtin_call(builtin, args)?;
                    block_items.extend(builtin_items);
                    return Ok(block_items);
                }
                _ => {
                    block_items.extend(take_drop_statements(&mut ctx.owned_values));
                    block_items.extend(build_builtin_statements(sig, builtin, args));
                    return Ok(block_items);
                }
            }
        }
    }

    block_items.extend(take_drop_statements(&mut ctx.owned_values));
    match target {
        AirExecTarget::Function(sig) => {
            block_items.push(AirStmt::op(AirOp::JumpArgs(AirJumpArgs {
                target: sig,
                args,
            })));
        }
        AirExecTarget::Closure { name } => {
            block_items.push(AirStmt::op(AirOp::JumpClosure(AirJumpClosure {
                env_end: name,
                args,
            })));
        }
    }
    Ok(block_items)
}

fn lower_builtin_call(
    builtin: builtins::Builtin,
    args: Vec<AirArg>,
) -> Result<Vec<AirStmt>, Error> {
    Ok(vec![AirStmt::op(call_op(builtin, args))])
}

// TODO: Simplify this.
fn resolve_target(name: &str, symbols: &SymbolRegistry) -> Result<AirExecTarget, Error> {
    if let Some(sig) = symbols.get_function(name) {
        return Ok(AirExecTarget::Function(sig.clone()));
    }
    if let Some(builtin_name) = symbols.builtin_name_for_alias(name) {
        let sig = symbol::builtin_function_sig(builtin_name)?;
        return Ok(AirExecTarget::Function(sig));
    }
    Ok(AirExecTarget::Closure {
        name: name.to_string(),
    })
}

fn build_closure_unwrapper(function: &AirFunction) -> Option<AirFunction> {
    let env_param = SigItem {
        name: "env_end".to_string(),
        kind: SigKind::Int,
        is_comptime: false,
    };

    Some(build_unwrapper_function(
        closure_unwrapper_label(&function.sig.name),
        function.sig.clone(),
        env_param,
        function.sig.params.clone(),
    ))
}

fn extract_closure_sig_info(
    target: &AirExecTarget,
    args: &[String],
    literals: &HashMap<String, Lit>,
    closure_remaining: &HashMap<String, Vec<SigKind>>,
) -> Vec<AirArg> {
    match target {
        AirExecTarget::Function(sig) => {
            return consume_signature_for_args(&sig.params, args, literals);
        }
        AirExecTarget::Closure { name } => {
            if let Some(kinds) = closure_remaining.get(name) {
                return consume_kinds_for_args(kinds, args, literals);
            }
        }
    }
    args.iter()
        .map(|arg| AirArg {
            name: arg.clone(),
            kind: SigKind::Int,
            literal: literal_for_arg(arg, literals),
        })
        .collect()
}

fn consume_signature_for_args(
    params: &[SigItem],
    args: &[String],
    literals: &HashMap<String, Lit>,
) -> Vec<AirArg> {
    let kinds = params
        .iter()
        .map(|param| param.kind.clone())
        .collect::<Vec<_>>();
    consume_kinds_for_args(&kinds, args, literals)
}

fn consume_kinds_for_args(
    kinds: &[SigKind],
    args: &[String],
    literals: &HashMap<String, Lit>,
) -> Vec<AirArg> {
    let mut consumed = 0;
    let mut sig_index = 0;
    let total = kinds.len();
    let mut air_args = Vec::with_capacity(args.len());
    while consumed < args.len() && sig_index < total {
        let ty = &kinds[sig_index];
        air_args.push(AirArg {
            name: args[consumed].clone(),
            kind: ty.clone(),
            literal: literal_for_arg(&args[consumed], literals),
        });
        consumed += 1;
        sig_index += 1;
    }

    while consumed < args.len() {
        air_args.push(AirArg {
            name: args[consumed].clone(),
            kind: SigKind::Int,
            literal: literal_for_arg(&args[consumed], literals),
        });
        consumed += 1;
    }

    air_args
}

fn literal_for_arg(name: &str, literals: &HashMap<String, Lit>) -> Option<Lit> {
    literals.get(name).cloned()
}

fn build_unwrapper_function(
    name: String,
    target_sig: FunctionSig,
    env_param: SigItem,
    field_sig_items: Vec<SigItem>,
) -> AirFunction {
    let env_end_reg = "__env_end".to_string();
    let env_word_count = env_word_count_from_params(&field_sig_items);
    let env_word_count_isize = env_word_count as isize;
    let offsets = env_word_offsets_from_params(&field_sig_items);
    let mut items = Vec::with_capacity(field_sig_items.len() + 1);

    items.push(AirStmt::op(AirOp::Pin(AirPin {
        result: env_end_reg.clone(),
        value: AirValue::Binding(env_param.name.clone()),
    })));

    for (idx, sig_item) in field_sig_items.iter().enumerate() {
        let offset = offsets[idx] as isize - env_word_count_isize;
        items.push(AirStmt::op(AirOp::Field(AirField {
            result: sig_item.name.clone(),
            ptr: env_end_reg.clone(),
            offset,
            kind: sig_item.kind.clone(),
        })));
    }

    items.push(AirStmt::op(AirOp::ReleaseHeap(AirReleaseHeap {
        name: env_end_reg.clone(),
    })));

    let builtin_args = field_sig_items
        .iter()
        .map(|item| AirArg {
            name: item.name.clone(),
            kind: item.kind.clone(),
            literal: None,
        })
        .collect::<Vec<_>>();

    if let Some(builtin) = target_sig.builtin {
        items.extend(build_builtin_statements(&target_sig, builtin, builtin_args));
    } else {
        items.push(AirStmt::op(AirOp::JumpArgs(AirJumpArgs {
            target: target_sig.clone(),
            args: builtin_args,
        })));
    }

    AirFunction {
        sig: FunctionSig {
            name,
            params: vec![env_param],
            generics: BTreeSet::new(),
            builtin: None,
        },
        items,
    }
}

fn build_deep_release_helper(function: &AirFunction) -> Option<AirFunction> {
    let env_param = SigItem {
        name: "env_end".to_string(),
        kind: SigKind::Int,
        is_comptime: false,
    };

    let offsets = env_word_offsets_from_params(&function.sig.params);
    let env_word_count = env_word_count_from_params(&function.sig.params);
    let env_word_count_isize = env_word_count as isize;
    let mut items = Vec::new();
    let num_remaining_binding = "__num_remaining".to_string();
    let env_end_reg = "__env_end".to_string();

    items.push(AirStmt::op(AirOp::Pin(AirPin {
        result: env_end_reg.clone(),
        value: AirValue::Binding(env_param.name.clone()),
    })));

    let reference_fields = function
        .sig
        .params
        .iter()
        .enumerate()
        .filter_map(|(idx, param)| {
            if !is_owned_type(&param.kind) {
                return None;
            }
            let offset_from_end = env_word_count.saturating_sub(offsets[idx]);
            Some((
                idx,
                offsets[idx] as isize - env_word_count_isize,
                offset_from_end,
                param.kind.clone(),
            ))
        })
        .collect::<Vec<_>>();

    if !reference_fields.is_empty() {
        items.push(AirStmt::op(AirOp::Field(AirField {
            result: num_remaining_binding.clone(),
            ptr: env_end_reg.clone(),
            offset: NUM_REMAINING_METADATA_WORD_OFFSET as isize,
            kind: SigKind::Int,
        })));
        for (idx, offset, offset_from_end, kind) in &reference_fields {
            let skip_label = format!("{}_release_skip_{}", function.sig.name, idx);
            let threshold = offset_from_end.saturating_sub(1);
            items.push(AirStmt::op(AirOp::JumpGt(AirJumpGt {
                left: AirValue::Binding(num_remaining_binding.clone()),
                right: AirValue::Literal(threshold as i64),
                target: skip_label.clone(),
            })));
            let location = format!("{}_release_field_{}", function.sig.name, idx);
            items.push(AirStmt::op(AirOp::Field(AirField {
                result: location.clone(),
                ptr: env_end_reg.clone(),
                offset: *offset,
                kind: kind.clone(),
            })));
            items.push(drop_owned_value(location, kind));
            items.push(AirStmt::Label(AirLabel { name: skip_label }));
        }
    }

    items.push(AirStmt::op(AirOp::ReleaseHeap(AirReleaseHeap {
        name: env_end_reg.clone(),
    })));

    items.push(AirStmt::op(AirOp::Return(AirReturn { value: None })));

    Some(AirFunction {
        sig: FunctionSig {
            name: closure_deep_release_label(&function.sig.name),
            params: vec![env_param],
            generics: BTreeSet::new(),
            builtin: None,
        },
        items,
    })
}

fn build_deep_copy_helper(function: &AirFunction) -> Option<AirFunction> {
    let env_param = SigItem {
        name: "env_end".to_string(),
        kind: SigKind::Int,
        is_comptime: false,
    };

    let offsets = env_word_offsets_from_params(&function.sig.params);
    let env_word_count = env_word_count_from_params(&function.sig.params);
    let mut items = Vec::new();
    let num_remaining_binding = "num_remaining".to_string();
    let env_end_reg = "__env_end".to_string();

    items.push(AirStmt::op(AirOp::Pin(AirPin {
        result: env_end_reg.clone(),
        value: AirValue::Binding(env_param.name.clone()),
    })));

    let reference_fields = function
        .sig
        .params
        .iter()
        .enumerate()
        .filter_map(|(idx, param)| {
            if !is_owned_type(&param.kind) {
                return None;
            }
            let env_offset_from_start = offsets[idx];
            Some((idx, env_offset_from_start, param.kind.clone()))
        })
        .collect::<Vec<_>>();

    if !reference_fields.is_empty() {
        items.push(AirStmt::op(AirOp::Field(AirField {
            result: num_remaining_binding.clone(),
            ptr: env_end_reg.clone(),
            offset: NUM_REMAINING_METADATA_WORD_OFFSET as isize,
            kind: SigKind::Int,
        })));
        for (idx, env_offset_from_start, kind) in &reference_fields {
            let skip_label = format!("{}_deepcopy_skip_{}", function.sig.name, idx);
            let offset_from_end = env_word_count.saturating_sub(*env_offset_from_start);
            let threshold = offset_from_end.saturating_sub(1);
            items.push(AirStmt::op(AirOp::JumpGt(AirJumpGt {
                left: AirValue::Binding(num_remaining_binding.clone()),
                right: AirValue::Literal(threshold as i64),
                target: skip_label.clone(),
            })));
            items.push(AirStmt::op(AirOp::CopyField(AirField {
                result: format!("{}_deepcopy_field_{}", function.sig.name, idx),
                ptr: env_end_reg.clone(),
                offset: -(offset_from_end as isize),
                kind: kind.clone(),
            })));
            items.push(AirStmt::Label(AirLabel { name: skip_label }));
        }
    }

    items.push(AirStmt::op(AirOp::Return(AirReturn { value: None })));

    Some(AirFunction {
        sig: FunctionSig {
            name: closure_deepcopy_label(&function.sig.name),
            params: vec![env_param],
            generics: BTreeSet::new(),
            builtin: None,
        },
        items,
    })
}

fn env_word_count_from_params(params: &[SigItem]) -> usize {
    params
        .iter()
        .map(|param| word_count_from_kind(&param.kind))
        .sum()
}

fn env_word_offsets_from_params(params: &[SigItem]) -> Vec<usize> {
    let mut offset = 0;
    params
        .iter()
        .map(|param| {
            let current = offset;
            offset += word_count_from_kind(&param.kind);
            current
        })
        .collect()
}

fn word_count_from_kinds(kinds: &[SigKind]) -> usize {
    kinds.iter().map(word_count_from_kind).sum()
}

fn suffix_word_counts(kinds: &[SigKind]) -> Vec<usize> {
    let mut remaining = word_count_from_kinds(kinds);
    kinds
        .iter()
        .map(|kind| {
            let current = remaining;
            remaining -= word_count_from_kind(kind);
            current
        })
        .collect()
}

fn word_count_from_kind(kind: &SigKind) -> usize {
    match kind {
        SigKind::FixedInt(kind) if kind.bit_width == 128 => 2,
        _ => 1,
    }
}

fn is_owned_type(ty: &SigKind) -> bool {
    matches!(ty, SigKind::Sig(_) | SigKind::Str | SigKind::Bytes)
}

fn instruction_op(builtin: builtins::Builtin, args: Vec<AirArg>) -> AirOp {
    let arg_len = args.len();
    let continuation_target = args
        .last()
        .expect("builtin invocation requires a continuation target")
        .name
        .clone();
    let inputs = args[..arg_len - 1].to_vec();

    match builtin {
        builtins::Builtin::Add => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs); // TODO: Maybe use a dedicated instruction_op alternative for this?
            AirOp::Add(AirAdd {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::AddUInt => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::AddUInt(AirAdd {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::AddF64 => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::AddF64(AirAddF64 {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::SubF64 => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::SubF64(AirSubF64 {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::AddBits(bit_width) => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::AddBits(AirBinaryBits {
                input_a,
                input_b,
                target: continuation_target,
                bit_width,
            })
        }
        builtins::Builtin::Sub => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::Sub(AirSub {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::SubUInt => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::SubUInt(AirSub {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::SubBits(bit_width) => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::SubBits(AirBinaryBits {
                input_a,
                input_b,
                target: continuation_target,
                bit_width,
            })
        }
        builtins::Builtin::Mul => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::Mul(AirMul {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::MulBits(bit_width) => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::MulBits(AirBinaryBits {
                input_a,
                input_b,
                target: continuation_target,
                bit_width,
            })
        }
        builtins::Builtin::MulF64 => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::MulF64(AirMulF64 {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::Div => {
            let err_target = args
                .get(arg_len - 2)
                .expect("div requires an error continuation")
                .name
                .clone();
            let (input_a, input_b) =
                binary_input_args(builtin.name(), args[..arg_len - 2].to_vec());
            AirOp::DivInt(AirDivInt {
                input_a,
                input_b,
                err_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::DivBits {
            bit_width,
            is_signed,
        } => {
            let err_target = args
                .get(arg_len - 2)
                .expect("fixed division requires an error continuation")
                .name
                .clone();
            let (input_a, input_b) =
                binary_input_args(builtin.name(), args[..arg_len - 2].to_vec());
            AirOp::DivBits(AirDivBits {
                input_a,
                input_b,
                err_target,
                ok_target: continuation_target,
                bit_width,
                is_signed,
            })
        }
        builtins::Builtin::DivF64 => {
            let (input_a, input_b) = binary_input_args(builtin.name(), inputs);
            AirOp::DivF64(AirDivF64 {
                input_a,
                input_b,
                target: continuation_target,
            })
        }
        builtins::Builtin::Native(function) => AirOp::NativeCall(AirNativeCall {
            function,
            inputs,
            target: continuation_target,
        }),
        builtins::Builtin::ConvertFixed { from, to } => {
            let input = inputs
                .into_iter()
                .next()
                .expect("fixed integer conversion requires one input");
            AirOp::ConvertFixed(AirConvertFixed {
                input,
                target: continuation_target,
                from,
                to,
            })
        }
        builtins::Builtin::RuneFromU32 => {
            let invalid_target = args
                .get(arg_len - 2)
                .expect("rune_from_u32 requires an invalid continuation")
                .name
                .clone();
            let input = args
                .first()
                .cloned()
                .expect("rune_from_u32 requires one input");
            AirOp::RuneFromU32(AirRuneFromU32 {
                input,
                invalid_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::U32FromRune => {
            let input = inputs
                .into_iter()
                .next()
                .expect("u32_from_rune requires one input");
            AirOp::U32FromRune(AirU32FromRune {
                input,
                target: continuation_target,
            })
        }
        builtins::Builtin::StrRuneLen => {
            let value = inputs
                .into_iter()
                .next()
                .expect("str_rune_len requires a string");
            AirOp::StrRuneLen(AirStrRuneLen {
                value,
                target: continuation_target,
            })
        }
        builtins::Builtin::StrRuneNth => {
            let empty_target = args
                .get(arg_len - 2)
                .expect("str_rune_nth requires an empty continuation")
                .name
                .clone();
            let mut inputs = args[..arg_len - 2].iter().cloned();
            let value = inputs.next().expect("str_rune_nth requires a string");
            let idx = inputs.next().expect("str_rune_nth requires an index");
            AirOp::StrRuneNth(AirStrRuneNth {
                value,
                idx,
                empty_target,
                one_target: continuation_target,
            })
        }
        builtins::Builtin::StrFromUtf8 => {
            let invalid_target = args
                .get(arg_len - 2)
                .expect("str_from_utf8 requires an invalid continuation")
                .name
                .clone();
            let value = args.first().cloned().expect("str_from_utf8 requires bytes");
            AirOp::StrFromUtf8(AirStrFromUtf8 {
                value,
                invalid_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::BytesLen => {
            let value = inputs.into_iter().next().expect("bytes_len requires bytes");
            AirOp::BytesLen(AirBytesLen {
                value,
                target: continuation_target,
            })
        }
        builtins::Builtin::BytesNth => {
            let empty_target = args
                .get(arg_len - 2)
                .expect("bytes_nth requires an empty continuation")
                .name
                .clone();
            let mut inputs = args[..arg_len - 2].iter().cloned();
            let value = inputs.next().expect("bytes_nth requires bytes");
            let idx = inputs.next().expect("bytes_nth requires an index");
            AirOp::BytesNth(AirBytesNth {
                value,
                idx,
                empty_target,
                one_target: continuation_target,
            })
        }
        builtins::Builtin::BytesFromStr => {
            let value = inputs
                .into_iter()
                .next()
                .expect("bytes_from_str requires a string");
            AirOp::BytesFromStr(AirBytesFromStr {
                value,
                target: continuation_target,
            })
        }
        builtins::Builtin::U8FromInt => {
            let invalid_target = args
                .get(arg_len - 2)
                .expect("u8_from_int requires an invalid continuation")
                .name
                .clone();
            let value = args
                .first()
                .cloned()
                .expect("u8_from_int requires an integer");
            AirOp::IntToU8(AirIntToU8 {
                value,
                invalid_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::EqInt => AirOp::JumpEqInt(AirJumpEq {
            args: inputs,
            target: continuation_target,
        }),
        builtins::Builtin::EqUInt => AirOp::JumpEqUInt(AirJumpEq {
            args: inputs,
            target: continuation_target,
        }),
        builtins::Builtin::EqBits(_) => AirOp::JumpEqBits(AirJumpEq {
            args: inputs,
            target: continuation_target,
        }),
        builtins::Builtin::EqStr => AirOp::JumpEqStr(AirJumpEq {
            args: inputs,
            target: continuation_target,
        }),
        _ => unreachable!("unexpected instruction op: {}", builtin.name()),
    }
}

fn binary_operands(name: &str, inputs: Vec<AirArg>) -> (AirValue, AirValue) {
    let (input_a, input_b) = binary_input_args(name, inputs);
    (arg_to_operand(input_a), arg_to_operand(input_b))
}

fn binary_input_args(name: &str, inputs: Vec<AirArg>) -> (AirArg, AirArg) {
    let mut iter = inputs.into_iter();
    let input_a = iter
        .next()
        .unwrap_or_else(|| panic!("{} requires two operands", name));
    let input_b = iter
        .next()
        .unwrap_or_else(|| panic!("{} requires two operands", name));
    (input_a, input_b)
}

fn arg_to_operand(arg: AirArg) -> AirValue {
    if let Some(literal) = arg.literal {
        match literal {
            Lit::Int(value) => AirValue::Literal(value as i64),
            Lit::Str(_) => panic!("unexpected string literal in numeric operation"),
            Lit::F64(_) => panic!("unexpected float literal in integer numeric operation"),
        }
    } else {
        AirValue::Binding(arg.name)
    }
}

fn call_op(builtin: builtins::Builtin, args: Vec<AirArg>) -> AirOp {
    let arg_len = args.len();
    let continuation_target = args
        .last()
        .expect("builtin invocation requires a continuation target")
        .name
        .clone();
    let call_args = args[..arg_len - 1].to_vec();
    let arg_kinds = call_args
        .iter()
        .map(|arg| arg.kind.clone())
        .collect::<Vec<_>>();

    match builtin {
        builtins::Builtin::Write => AirOp::Write(AirWrite {
            args: call_args,
            arg_kinds,
            target: continuation_target,
        }),
        builtins::Builtin::FileRead => {
            let err_target = call_args
                .last()
                .expect("file_read requires an error continuation")
                .name
                .clone();
            let path = call_args
                .first()
                .cloned()
                .expect("file_read requires a path argument");
            AirOp::FileRead(AirFileRead {
                path,
                err_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::BytesBuild => {
            let invalid_target = call_args
                .last()
                .expect("bytes_build requires an invalid continuation")
                .name
                .clone();
            let source = call_args
                .first()
                .cloned()
                .expect("bytes_build requires a source");
            AirOp::BytesBuild(AirBytesBuild {
                source,
                invalid_target,
                ok_target: continuation_target,
            })
        }
        builtins::Builtin::Exit => AirOp::SysExit(AirSysExit { args }),
        _ => unreachable!("unexpected call op: {}", builtin.name()),
    }
}

fn build_conditional_builtin_bridge(
    sig: &FunctionSig,
    builtin: builtins::Builtin,
    args: Vec<AirArg>,
) -> Vec<AirStmt> {
    let arg_len = args.len();
    let true_cont = &args[arg_len - 2];
    let false_cont = &args[arg_len - 1];
    let true_label = conditional_builtin_branch_label(sig, true_cont, "true");
    let false_label = conditional_builtin_branch_label(sig, false_cont, "false");
    let inputs = args[..arg_len - 2].to_vec();

    let branch = match builtin {
        builtins::Builtin::EqInt => AirOp::JumpEqInt(AirJumpEq {
            args: inputs,
            target: true_label.clone(),
        }),
        builtins::Builtin::EqStr => AirOp::JumpEqStr(AirJumpEq {
            args: inputs,
            target: true_label.clone(),
        }),
        builtins::Builtin::EqUInt => AirOp::JumpEqUInt(AirJumpEq {
            args: inputs,
            target: true_label.clone(),
        }),
        builtins::Builtin::EqBits(_) => AirOp::JumpEqBits(AirJumpEq {
            args: inputs,
            target: true_label.clone(),
        }),
        builtins::Builtin::LtUInt => {
            let (left, right) = binary_operands(builtin.name(), inputs);
            AirOp::JumpLtUInt(AirJumpLt {
                left,
                right,
                target: true_label.clone(),
            })
        }
        builtins::Builtin::Lt => {
            let (left, right) = binary_operands(builtin.name(), inputs);
            AirOp::JumpLt(AirJumpLt {
                left,
                right,
                target: true_label.clone(),
            })
        }
        builtins::Builtin::Gt => {
            let (left, right) = binary_operands(builtin.name(), inputs);
            AirOp::JumpGt(AirJumpGt {
                left,
                right,
                target: true_label.clone(),
            })
        }
        _ => unreachable!("unexpected conditional builtin: {}", builtin.name()),
    };

    vec![
        AirStmt::op(branch),
        AirStmt::Label(AirLabel {
            name: false_label.clone(),
        }),
        drop_owned_value(true_cont.name.clone(), &true_cont.kind),
        AirStmt::op(AirOp::JumpClosure(AirJumpClosure {
            env_end: false_cont.name.clone(),
            args: Vec::new(),
        })),
        AirStmt::Label(AirLabel {
            name: true_label.clone(),
        }),
        drop_owned_value(false_cont.name.clone(), &false_cont.kind),
        AirStmt::op(AirOp::JumpClosure(AirJumpClosure {
            env_end: true_cont.name.clone(),
            args: Vec::new(),
        })),
    ]
}

fn build_builtin_statements(
    sig: &FunctionSig,
    builtin: builtins::Builtin,
    args: Vec<AirArg>,
) -> Vec<AirStmt> {
    match builtin.air_route() {
        builtins::AirRoute::Instruction => vec![AirStmt::op(instruction_op(builtin, args))],
        builtins::AirRoute::Conditional => build_conditional_builtin_bridge(sig, builtin, args),
        builtins::AirRoute::Call => vec![AirStmt::op(call_op(builtin, args))],
        builtins::AirRoute::RuntimeFallback => {
            let continuation = args
                .last()
                .expect("compile-error builtin requires a runtime continuation");
            vec![AirStmt::op(AirOp::JumpClosure(AirJumpClosure {
                env_end: continuation.name.clone(),
                args: Vec::new(),
            }))]
        }
    }
}
