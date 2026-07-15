use std::collections::HashMap;
use std::path::Path;

use crate::compiler::{
    air, ast,
    error::Error,
    hir, source,
    symbol::{self, SymbolRegistry},
};

pub fn generate_hir_block_items(path: &Path, target: &str) -> Result<Vec<hir::BlockItem>, Error> {
    let project = source::load(path, target)?;
    let sources = project.sources;
    let mut ctx = hir::Context::new();
    crate::compiler::predeclare_package(&mut ctx, &project.items)
        .map_err(|error| source::attach_source(error, &sources))?;
    let mut lowerer = hir::Lowerer::new();
    lowerer.register_package_functions(&project.items);
    let mut items = Vec::new();

    for item in project.items {
        lowerer
            .consume(&mut ctx, item)
            .map_err(|error| source::attach_source(error, &sources))?;
        while let Some(lowered) = lowerer.produce() {
            items.push(lowered);
        }
    }

    lowerer
        .consume(
            &mut ctx,
            ast::BlockItem::Ident(ast::Ident {
                name: project.target,
                args: Vec::new(),
                span: crate::compiler::span::Span::unknown(),
            }),
        )
        .map_err(|error| source::attach_source(error, &sources))?;
    while let Some(lowered) = lowerer.produce() {
        items.push(lowered);
    }
    Ok(items)
}

pub fn generate_air_functions(items: &[hir::BlockItem]) -> Result<Vec<air::AirFunction>, Error> {
    let mut symbols = SymbolRegistry::new();
    let mut functions = Vec::new();
    let mut entry_items = Vec::new();
    let mut hir_functions = HashMap::new();

    for item in items {
        match item {
            hir::BlockItem::Import { label, path } => {
                symbol::register_builtin_import(label, path, &mut symbols)?;
            }
            hir::BlockItem::SigDef { name, sig } => {
                symbols.install_type(name.to_string(), air::SigKind::Sig(sig.clone()))?;
            }
            hir::BlockItem::FunctionDef(function) => {
                symbols.declare_function(air::function_sig_from_hir(function))?;
                hir_functions.insert(function.name.clone(), function.clone());
            }
            _ => entry_items.push(item.clone()),
        }
    }

    if !entry_items.is_empty() {
        let mut function_lowerer = air::FunctionLowerer::new(hir_functions);
        let entry_funcs = air::entry_function(entry_items, &mut symbols, &mut function_lowerer)?;
        let mut generated = function_lowerer.take_generated_functions();
        generated.extend(entry_funcs);
        functions.extend(generated);
    }

    Ok(functions)
}
