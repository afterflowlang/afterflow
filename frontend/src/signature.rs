use crate::ast;
use crate::builtins;
use crate::error::Error;
use crate::hir;
use crate::hir_context as ctx;
use crate::span::Span;
use std::collections::{BTreeSet, HashMap, HashSet};

pub fn ast_signature_to_hir(signature: ast::Signature) -> hir::Signature {
    hir::Signature {
        items: signature
            .items
            .into_iter()
            .map(ast_sig_item_to_hir)
            .collect(),
        generics: signature.generics,
    }
}

pub fn hir_signature_to_ast(signature: hir::Signature) -> ast::Signature {
    ast::Signature {
        items: signature
            .items
            .into_iter()
            .map(hir_sig_item_to_ast)
            .collect(),
        span: Span::unknown(),
        generics: signature.generics,
    }
}

pub fn resolve_signature(
    signature: &hir::Signature,
    ctx: &mut ctx::Context,
) -> Result<hir::Signature, Error> {
    Ok(hir::Signature {
        items: signature
            .items
            .iter()
            .map(|item| -> Result<hir::SigItem, Error> {
                let name = if item.name.is_empty() {
                    ctx.new_name()
                } else {
                    item.name.clone()
                };
                let kind = lower_sig_kind(&item.kind, ctx)?;
                Ok(hir::SigItem {
                    name,
                    kind,
                    is_comptime: item.is_comptime,
                })
            })
            .collect::<Result<Vec<_>, _>>()?,
        generics: signature.generics.clone(),
    })
}
/// Normalize a HIR SigKind by resolving any `Ident` that refers to an imported builtin (ctxentry.is_builtin=true),
/// converting e.g. `Ident("str") -> SigKind::Str`, `Ident("int") -> SigKind::Int`, etc.
/// Uses a single canonical folder to avoid match duplication.
pub fn normalize_signature(signature: &hir::Signature, ctx: &ctx::Context) -> hir::Signature {
    let items = signature
        .items
        .iter()
        .map(|item| {
            let mut normalized_item = item.clone();
            normalized_item.kind = normalize_sig_kind(&item.kind, ctx);
            normalized_item
        })
        .collect();
    hir::Signature {
        items,
        generics: signature.generics.clone(),
    }
}

pub fn normalize_sig_kind(kind: &hir::SigKind, ctx: &ctx::Context) -> hir::SigKind {
    let mut seen = HashSet::new();
    normalize_sig_kind_inner(kind, ctx, &mut seen)
}

fn normalize_sig_kind_inner(
    kind: &hir::SigKind,
    ctx: &ctx::Context,
    seen: &mut HashSet<String>,
) -> hir::SigKind {
    match kind {
        hir::SigKind::Ident(ident) => {
            if seen.contains(&ident.name) {
                return hir::SigKind::Ident(ident.clone());
            }
            if let Some(entry) = ctx.get(&ident.name) {
                seen.insert(ident.name.clone());
                let resolved = normalize_sig_kind_inner(&entry.kind, ctx, seen);
                seen.remove(&ident.name);
                return resolved;
            }
            hir::SigKind::Ident(ident.clone())
        }
        hir::SigKind::Sig(signature) => {
            let items = signature
                .items
                .iter()
                .map(|item| {
                    let mut normalized_item = item.clone();
                    normalized_item.kind = normalize_sig_kind_inner(&item.kind, ctx, seen);
                    normalized_item
                })
                .collect();
            hir::SigKind::Sig(hir::Signature {
                items,
                generics: signature.generics.clone(),
            })
        }
        other => other.clone(),
    }
}

pub fn resolve_target_signature(target: &str, ctx: &ctx::Context) -> Option<hir::Signature> {
    let mut visited = HashSet::new();
    ctx.get(target)
        .and_then(|entry| signature_from_kind(&entry.kind, ctx, &mut visited))
}

pub fn signature_from_kind(
    kind: &hir::SigKind,
    ctx: &ctx::Context,
    visited: &mut HashSet<String>,
) -> Option<hir::Signature> {
    match kind {
        hir::SigKind::Sig(signature) => Some(signature.clone()),
        hir::SigKind::Ident(ident) => {
            let name = &ident.name;
            if !visited.insert(name.clone()) {
                return None;
            }
            let out = ctx
                .get(name)
                .and_then(|entry| signature_from_kind(&entry.kind, ctx, visited));
            visited.remove(name);
            out
        }
        _ => None,
    }
}

pub fn expected_params_for_args(
    params: &[hir::SigItem],
    args_len: usize,
) -> Vec<Option<&hir::SigItem>> {
    (0..args_len).map(|idx| params.get(idx)).collect()
}

fn resolve_ident(ident: &hir::SigIdent, ctx: &ctx::Context) -> hir::SigKind {
    if let Some(builtin_name) = ident.name.strip_prefix('@') {
        if let Some(builtins::BuiltinSpec::Type(kind)) = builtins::get_spec(builtin_name) {
            return kind;
        }
    }
    if let Some(entry) = ctx.get(&ident.name) {
        if entry.is_builtin || matches!(entry.kind, hir::SigKind::Generic(_)) {
            return entry.kind.clone();
        }
    }
    hir::SigKind::Ident(ident.clone())
}

fn ast_sig_item_to_hir(item: ast::SigItem) -> hir::SigItem {
    hir::SigItem {
        name: item.name,
        kind: ast_sig_kind_to_hir(item.kind),
        is_comptime: item.is_comptime,
    }
}

fn ast_sig_kind_to_hir(kind: ast::SigKind) -> hir::SigKind {
    match kind {
        ast::SigKind::Byte => hir::SigKind::Byte,
        ast::SigKind::Int => hir::SigKind::Int,
        ast::SigKind::Str => hir::SigKind::Str,
        ast::SigKind::F64 => hir::SigKind::F64,
        ast::SigKind::Ident(ident) => hir::SigKind::Ident(hir::SigIdent { name: ident.name }),
        ast::SigKind::Sig(signature) => hir::SigKind::Sig(ast_signature_to_hir(signature)),
        ast::SigKind::GenericInst { name, args } => hir::SigKind::GenericInst {
            name,
            args: args.into_iter().map(ast_sig_kind_to_hir).collect(),
        },
        ast::SigKind::Generic(name) => hir::SigKind::Generic(name),
    }
}

fn hir_sig_item_to_ast(item: hir::SigItem) -> ast::SigItem {
    ast::SigItem {
        name: item.name,
        kind: hir_sig_kind_to_ast(item.kind),
        is_comptime: item.is_comptime,
        span: Span::unknown(),
    }
}

fn hir_sig_kind_to_ast(kind: hir::SigKind) -> ast::SigKind {
    match kind {
        hir::SigKind::Byte => ast::SigKind::Byte,
        hir::SigKind::Int => ast::SigKind::Int,
        hir::SigKind::UInt => ast::SigKind::Ident(ast::SigIdent {
            name: "uint".to_string(),
            span: Span::unknown(),
        }),
        hir::SigKind::Rune => ast::SigKind::Ident(ast::SigIdent {
            name: "rune".to_string(),
            span: Span::unknown(),
        }),
        hir::SigKind::FixedInt(kind) => ast::SigKind::Ident(ast::SigIdent {
            name: kind.name(),
            span: Span::unknown(),
        }),
        hir::SigKind::Bytes => ast::SigKind::Ident(ast::SigIdent {
            name: "bytes".to_string(),
            span: Span::unknown(),
        }),
        hir::SigKind::Str => ast::SigKind::Str,
        hir::SigKind::F64 => ast::SigKind::F64,
        hir::SigKind::Ident(ident) => ast::SigKind::Ident(ast::SigIdent {
            name: ident.name,
            span: Span::unknown(),
        }),
        hir::SigKind::Sig(signature) => ast::SigKind::Sig(hir_signature_to_ast(signature)),
        hir::SigKind::GenericInst { name, args } => ast::SigKind::GenericInst {
            name,
            args: args.into_iter().map(hir_sig_kind_to_ast).collect(),
        },
        hir::SigKind::Generic(name) => ast::SigKind::Generic(name),
    }
}

fn lower_sig_kind(kind: &hir::SigKind, ctx: &mut ctx::Context) -> Result<hir::SigKind, Error> {
    Ok(match kind {
        hir::SigKind::Ident(ident) => resolve_ident(ident, ctx),
        hir::SigKind::Sig(signature) => hir::SigKind::Sig(resolve_signature(signature, ctx)?),
        hir::SigKind::GenericInst { name, args } => {
            let resolved_args = args
                .iter()
                .map(|arg| lower_sig_kind(arg, ctx))
                .collect::<Result<Vec<_>, _>>()?;

            instantiate_generic_inst(name, &resolved_args, ctx)
                .unwrap_or_else(|| hir::SigKind::Ident(hir::SigIdent { name: name.clone() }))
        }
        hir::SigKind::Generic(name) => hir::SigKind::Generic(name.clone()),
        hir::SigKind::Byte
        | hir::SigKind::Int
        | hir::SigKind::UInt
        | hir::SigKind::Rune
        | hir::SigKind::FixedInt(_)
        | hir::SigKind::Bytes
        | hir::SigKind::Str
        | hir::SigKind::F64 => kind.clone(),
    })
}

fn instantiate_generic_inst(
    name: &str,
    args: &[hir::SigKind],
    ctx: &ctx::Context,
) -> Option<hir::SigKind> {
    let entry = ctx.get(name)?;
    let signature = if let hir::SigKind::Sig(signature) = &entry.kind {
        signature
    } else {
        return None;
    };

    if signature.generics.len() != args.len() {
        return None;
    }

    let mapping: HashMap<String, hir::SigKind> = signature
        .generics
        .iter()
        .cloned()
        .zip(args.iter().cloned())
        .collect();

    Some(hir::SigKind::Sig(substitute_signature(signature, &mapping)))
}

pub fn substitute_signature(
    signature: &hir::Signature,
    mapping: &HashMap<String, hir::SigKind>,
) -> hir::Signature {
    let items = signature
        .items
        .iter()
        .map(|item| {
            let mut out = item.clone();
            out.kind = substitute_kind(&item.kind, mapping);
            out
        })
        .collect();

    hir::Signature {
        items,
        generics: BTreeSet::new(),
    }
}

// TODO: Remove this
fn substitute_kind(kind: &hir::SigKind, mapping: &HashMap<String, hir::SigKind>) -> hir::SigKind {
    match kind {
        hir::SigKind::Sig(signature) => hir::SigKind::Sig(substitute_signature(signature, mapping)),
        hir::SigKind::Ident(ident) => {
            if let Some(mapped) = mapping.get(&ident.name) {
                mapped.clone()
            } else {
                hir::SigKind::Ident(ident.clone())
            }
        }
        hir::SigKind::Generic(name) => {
            if let Some(mapped) = mapping.get(name) {
                mapped.clone()
            } else {
                hir::SigKind::Generic(name.clone())
            }
        }
        hir::SigKind::GenericInst { name, args } => hir::SigKind::GenericInst {
            name: name.clone(),
            args: args
                .iter()
                .map(|arg| substitute_kind(arg, mapping))
                .collect(),
        },
        _ => kind.clone(),
    }
}
