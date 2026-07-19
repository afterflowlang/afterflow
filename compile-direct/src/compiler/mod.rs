use std::collections::HashMap;
use std::io::{BufRead, Write};
use std::path::Path;

pub mod air;
pub mod air_ast;
pub mod builtins;
pub mod codegen;
pub mod comptime;
pub mod format_air;
pub mod runtime;
pub mod symbol;

pub use afterflow_frontend::{
    ast, error, format_hir, hir, hir_ast, hir_context, lexer, parser, predeclare_package,
    signature, source, span, token,
};

#[cfg(test)]
mod codegen_test;

use error::Error;
use error::{Code, Error as CompilerError};
use hir::Lowerer;
use lexer::Lexer;
use parser::Parser;
use span::Span;
use symbol::SymbolRegistry;

pub fn compile<R: BufRead, W: Write>(input: R, target: &str, out: &mut W) -> Result<(), Error> {
    let lexer = Lexer::new(input);
    let mut parser = Parser::new(lexer);
    let mut items = Vec::new();
    while let Some(item) = parser.next_block_item()? {
        reject_root_execution(&item)?;
        reject_builtin_override(&item)?;
        items.push(item);
    }
    compile_items(items, target, hir::Context::new(), out)
}

fn reject_builtin_override(item: &ast::BlockItem) -> Result<(), Error> {
    let name = match item {
        ast::BlockItem::SigDef { name, .. }
        | ast::BlockItem::FunctionDef { name, .. }
        | ast::BlockItem::LitDef { name, .. }
        | ast::BlockItem::IdentDef { name, .. } => name,
        _ => return Ok(()),
    };
    if name.starts_with('@') {
        return Err(CompilerError::new(
            Code::Parse,
            "builtin overrides are only allowed in the selected _test.af entry source",
            item.span(),
        ));
    }
    Ok(())
}

pub fn compile_path<W: Write>(input: &Path, target: &str, out: &mut W) -> Result<(), Error> {
    if !input.is_file() {
        return Err(CompilerError::new(
            Code::Io,
            format!("entry source '{}' is not a file", input.display()),
            Span::unknown(),
        ));
    }
    let project = source::load(input, target)?;
    let sources = project.sources;
    let mut ctx = hir::Context::new();
    predeclare_package(&mut ctx, &project.items)
        .map_err(|error| source::attach_source(error, &sources))?;
    compile_items(project.items, &project.target, ctx, out)
        .map_err(|error| source::attach_source(error, &sources))
}

fn compile_items<W: Write>(
    items: Vec<ast::BlockItem>,
    target: &str,
    mut hir_ctx: hir::Context,
    out: &mut W,
) -> Result<(), Error> {
    let mut symbols = SymbolRegistry::new();
    let mut air_functions: Vec<air::AirFunction> = Vec::new();
    let mut hir_functions: HashMap<String, hir::Function> = HashMap::new();
    let mut builtin_aliases: HashMap<String, builtins::Builtin> = HashMap::new();

    // Emit preamble (globals, default labels, etc.).
    codegen::write_preamble(out)?;

    let mut lowerer = Lowerer::new();
    let mut entry_items: Vec<hir::BlockItem> = Vec::new();

    for item in items {
        lowerer.consume(&mut hir_ctx, item)?; // consume one function/item

        // produce many functions/types etc (hoisted)
        while let Some(lowered) = lowerer.produce() {
            match lowered {
                hir::BlockItem::Import { label, path } => {
                    if matches!(path.as_str(), "__bytes_len" | "__bytes_len_comptime") {
                        symbol::register_internal_builtin_import(
                            &label,
                            builtins::Builtin::BytesLen,
                            (path == "__bytes_len_comptime").then_some(1),
                            &mut symbols,
                        )?;
                        builtin_aliases.insert(label, builtins::Builtin::BytesLen);
                    } else {
                        symbol::register_builtin_import(&label, &path, &mut symbols)?;
                        if let Some(builtin) = builtins::function_from_name(&path) {
                            builtin_aliases.insert(label, builtin);
                        }
                    }
                }
                hir::BlockItem::SigDef { name, sig } => {
                    symbols.install_type(name.to_string(), air::SigKind::Sig(sig.clone()))?;
                }
                hir::BlockItem::FunctionDef(function) => {
                    let sig = air::function_sig_from_hir(&function);
                    symbols.declare_function(sig)?;
                    hir_functions.insert(function.name.clone(), function);
                }
                other => entry_items.push(other),
            }
        }
    }

    let target_exec = ast::BlockItem::Ident(ast::Ident {
        name: target.to_string(),
        args: Vec::new(),
        span: Span::unknown(),
    });
    lowerer.consume(&mut hir_ctx, target_exec)?;
    while let Some(lowered) = lowerer.produce() {
        match lowered {
            hir::BlockItem::Import { .. }
            | hir::BlockItem::SigDef { .. }
            | hir::BlockItem::FunctionDef(_) => {
                return Err(CompilerError::new(
                    Code::Internal,
                    "entry target lowering produced a declaration",
                    Span::unknown(),
                ));
            }
            other => entry_items.push(other),
        }
    }

    comptime::rewrite(&mut hir_functions, &mut entry_items, &builtin_aliases)?;

    let mut function_lowerer = air::FunctionLowerer::new(hir_functions);
    let entry_funcs = air::entry_function(entry_items, &mut symbols, &mut function_lowerer)?;
    let mut generated = function_lowerer.take_generated_functions();
    generated.extend(entry_funcs);
    air_functions.extend(generated);

    let mut artifacts = codegen::Artifacts::collect(&air_functions);
    codegen::emit_native_externs(&artifacts, out)?;
    for func in air_functions {
        codegen::function(func, &mut artifacts, out)?;
    }
    codegen::emit_data(artifacts.string_literals(), out)?;
    Ok(())
}

fn reject_root_execution(item: &ast::BlockItem) -> Result<(), Error> {
    match item {
        ast::BlockItem::Ident(_)
        | ast::BlockItem::Lambda(_)
        | ast::BlockItem::ScopeCapture { .. } => Err(CompilerError::new(
            Code::Parse,
            "root-level invocation is not supported; choose a target function",
            item.span(),
        )),
        _ => Ok(()),
    }
}
