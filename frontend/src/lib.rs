//! Shared source parsing, project loading, and HIR construction for Afterflow.

pub mod ast;
pub mod builtins;
pub mod error;
pub mod format_hir;
pub mod formatter;
pub mod hir;
pub mod hir_ast;
pub mod hir_context;
pub mod lexer;
pub mod parser;
pub mod signature;
pub mod source;
pub mod span;
pub mod token;

#[cfg(test)]
mod lexer_test;
#[cfg(test)]
mod parser_test;

pub fn predeclare_package(
    ctx: &mut hir::Context,
    items: &[ast::BlockItem],
) -> Result<(), error::Error> {
    for item in items {
        if let ast::BlockItem::IdentDef {
            name, ident, span, ..
        } = item
        {
            if name.starts_with('@') {
                ctx.predeclare(
                    name,
                    hir::SigKind::Ident(hir::SigIdent {
                        name: ident.name.clone(),
                    }),
                    false,
                    *span,
                )?;
            }
        }
    }
    for item in items {
        match item {
            ast::BlockItem::FunctionDef { name, span, .. }
            | ast::BlockItem::SigDef { name, span, .. } => ctx.predeclare(
                name,
                hir::SigKind::Ident(hir::SigIdent { name: name.clone() }),
                false,
                *span,
            )?,
            ast::BlockItem::LitDef {
                name,
                literal,
                span,
            } => {
                let (kind, is_comptime) = match &literal.value {
                    ast::Lit::Str(_) => (hir::SigKind::Str, true),
                    ast::Lit::Int(_) => (hir::SigKind::Int, true),
                    ast::Lit::F64(_) => (hir::SigKind::F64, true),
                };
                ctx.predeclare(name, kind, is_comptime, *span)?;
            }
            ast::BlockItem::IdentDef { name, .. } if name.starts_with('@') => {}
            ast::BlockItem::IdentDef { name, ident, span }
                if ident.args.is_empty()
                    && ident.name.starts_with('@')
                    && ctx.get(&ident.name).is_none_or(|entry| entry.is_builtin) =>
            {
                let builtin = ident.name.trim_start_matches('@');
                hir_context::register_import(ctx, name, builtin, *span)?;
                ctx.mark_predeclared(name);
            }
            ast::BlockItem::IdentDef { name, ident, span } => ctx.predeclare(
                name,
                hir::SigKind::Ident(hir::SigIdent {
                    name: ident.name.clone(),
                }),
                false,
                *span,
            )?,
            ast::BlockItem::Import { .. }
            | ast::BlockItem::Ident(_)
            | ast::BlockItem::Lambda(_)
            | ast::BlockItem::ScopeCapture { .. } => {}
        }
    }

    for item in items {
        if let ast::BlockItem::SigDef { name, sig, span } = item {
            let sig = signature::ast_signature_to_hir(sig.clone());
            let resolved =
                signature::resolve_signature(&sig, ctx).map_err(|error| error.with_span(*span))?;
            let normalized = signature::normalize_signature(&resolved, ctx);
            if let Some(entry) = ctx.get_mut(name) {
                entry.kind = hir::SigKind::Sig(normalized);
            }
        }
    }
    for item in items {
        if let ast::BlockItem::FunctionDef { name, lambda, span } = item {
            let sig = signature::ast_signature_to_hir(lambda.params.clone());
            let mut signature_ctx = ctx.enter(name, Some(name), true);
            let resolved = signature::resolve_signature(&sig, &mut signature_ctx)
                .map_err(|error| error.with_span(*span))?;
            let normalized = signature::normalize_signature(&resolved, &signature_ctx);
            if let Some(entry) = ctx.get_mut(name) {
                entry.kind = hir::SigKind::Sig(normalized);
            }
        }
    }
    for _ in 0..items.len() {
        for item in items {
            if let ast::BlockItem::IdentDef { name, ident, .. } = item {
                if ident.args.is_empty() {
                    if let Some(target) = ctx.get(&ident.name).cloned() {
                        if let Some(entry) = ctx.get_mut(name) {
                            entry.name = target.name;
                            entry.kind = target.kind;
                            entry.is_builtin = target.is_builtin;
                        }
                    }
                } else if let Some(signature) =
                    signature::resolve_target_signature(&ident.name, ctx)
                {
                    if let Some(entry) = ctx.get_mut(name) {
                        entry.kind = hir::SigKind::Sig(hir::Signature {
                            items: signature.items.into_iter().skip(ident.args.len()).collect(),
                            generics: signature.generics,
                        });
                    }
                }
            }
        }
    }
    Ok(())
}
