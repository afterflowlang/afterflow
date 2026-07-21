use std::io::Cursor;

use afterflow_frontend::ast;
use afterflow_frontend::error;
use afterflow_frontend::lexer::Lexer;
use afterflow_frontend::parser::Parser;
use afterflow_frontend::span::Span;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(crate) enum DefinitionKind {
    Function,
    Type,
    Constant,
    Alias,
    Parameter,
    Namespace,
}

#[derive(Clone, Debug)]
pub(crate) struct Definition {
    pub(crate) name: String,
    pub(crate) detail: String,
    pub(crate) import_path: Option<String>,
    import_path_offset: Option<usize>,
    pub(crate) kind: DefinitionKind,
    pub(crate) span: Span,
    scope: usize,
}

#[derive(Clone, Debug)]
struct Reference {
    name: String,
    span: Span,
    scope: usize,
}

#[derive(Clone, Debug)]
struct Scope {
    parent: Option<usize>,
}

#[derive(Clone, Debug)]
pub(crate) struct Analysis {
    definitions: Vec<Definition>,
    references: Vec<Reference>,
    scopes: Vec<Scope>,
    parse_error: Option<error::Error>,
}

impl Analysis {
    pub(crate) fn new(text: &str) -> Self {
        let mut parser = Parser::new(Lexer::new(Cursor::new(text)));
        let mut items = Vec::new();
        let parse_error = loop {
            match parser.next_block_item() {
                Ok(Some(item)) => items.push(item),
                Ok(None) => break None,
                Err(error) => break Some(error),
            }
        };
        let mut index = Index {
            definitions: Vec::new(),
            references: Vec::new(),
            scopes: vec![Scope { parent: None }],
        };
        index.block_items(&items, 0, text);
        Self {
            definitions: index.definitions,
            references: index.references,
            scopes: index.scopes,
            parse_error,
        }
    }

    pub(crate) fn definitions(&self) -> &[Definition] {
        &self.definitions
    }

    pub(crate) fn top_level_definitions(&self) -> impl Iterator<Item = &Definition> {
        self.definitions
            .iter()
            .filter(|definition| definition.scope == 0)
    }

    pub(crate) fn parse_error(&self) -> Option<&error::Error> {
        self.parse_error.as_ref()
    }

    pub(crate) fn definition_at(&self, offset: usize) -> Option<&Definition> {
        self.definitions
            .iter()
            .find(|definition| contains_name(definition.span, &definition.name, offset))
    }

    pub(crate) fn import_at(&self, offset: usize) -> Option<&Definition> {
        self.definitions.iter().find(|definition| {
            definition
                .import_path
                .as_ref()
                .zip(definition.import_path_offset)
                .is_some_and(|(path, start)| start <= offset && offset < start + path.len())
        })
    }

    pub(crate) fn reference_at(&self, offset: usize) -> Option<(&str, Span, usize)> {
        self.references
            .iter()
            .find(|reference| contains_name(reference.span, &reference.name, offset))
            .map(|reference| (reference.name.as_str(), reference.span, reference.scope))
    }

    pub(crate) fn resolve_local(
        &self,
        name: &str,
        scope: usize,
        use_offset: usize,
    ) -> Option<&Definition> {
        let simple_name = name.split('.').next().unwrap_or(name);
        self.definitions
            .iter()
            .rev()
            .filter(|definition| definition.name == simple_name)
            .filter(|definition| self.is_scope_ancestor(definition.scope, scope))
            .find(|definition| definition.scope == 0 || definition.span.offset <= use_offset)
    }

    fn is_scope_ancestor(&self, ancestor: usize, mut scope: usize) -> bool {
        loop {
            if scope == ancestor {
                return true;
            }
            let Some(parent) = self.scopes[scope].parent else {
                return false;
            };
            scope = parent;
        }
    }
}

fn contains_name(span: Span, name: &str, offset: usize) -> bool {
    let end = span.offset.saturating_add(name.len());
    span.offset <= offset && offset < end
}

struct Index {
    definitions: Vec<Definition>,
    references: Vec<Reference>,
    scopes: Vec<Scope>,
}

impl Index {
    fn block_items(&mut self, items: &[ast::BlockItem], scope: usize, text: &str) {
        for item in items {
            self.block_item(item, scope, text);
        }
    }

    fn block_item(&mut self, item: &ast::BlockItem, scope: usize, text: &str) {
        match item {
            ast::BlockItem::Import { label, path, span } => {
                self.definitions.push(Definition {
                    name: label.clone(),
                    detail: format!("{label}: {path}"),
                    import_path: Some(path.clone()),
                    import_path_offset: source_path_offset(text, *span, label, path),
                    kind: DefinitionKind::Namespace,
                    span: *span,
                    scope,
                });
            }
            ast::BlockItem::SigDef { name, sig, span } => {
                self.signature_references(sig, scope);
                self.define(
                    name,
                    format!("{name}: {}", format_signature(sig, false)),
                    DefinitionKind::Type,
                    *span,
                    scope,
                );
            }
            ast::BlockItem::FunctionDef { name, lambda, span } => {
                self.define(
                    name,
                    format!("{name}: {}", format_signature(&lambda.params, true)),
                    DefinitionKind::Function,
                    *span,
                    scope,
                );
                self.lambda(lambda, scope, text);
            }
            ast::BlockItem::LitDef {
                name,
                literal,
                span,
            } => self.define(
                name,
                format!("{name}: {}", format_literal(literal)),
                DefinitionKind::Constant,
                *span,
                scope,
            ),
            ast::BlockItem::IdentDef { name, ident, span } => {
                self.ident(ident, scope, text);
                self.define(
                    name,
                    format!("{name}: {}", format_ident(ident)),
                    DefinitionKind::Alias,
                    *span,
                    scope,
                );
            }
            ast::BlockItem::Lambda(lambda) => self.lambda(lambda, scope, text),
            ast::BlockItem::Ident(ident) => self.ident(ident, scope, text),
            ast::BlockItem::ScopeCapture {
                params,
                continuation,
                term,
                ..
            } => {
                self.term(term, scope, text);
                let continuation_scope = self.new_scope(scope);
                self.signature(params, continuation_scope);
                self.block_items(&continuation.items, continuation_scope, text);
            }
        }
    }

    fn lambda(&mut self, lambda: &ast::Lambda, parent_scope: usize, text: &str) {
        let scope = self.new_scope(parent_scope);
        self.signature(&lambda.params, scope);
        for argument in &lambda.args {
            self.term(&argument.term, parent_scope, text);
        }
        self.block_items(&lambda.body.items, scope, text);
    }

    fn signature(&mut self, signature: &ast::Signature, scope: usize) {
        for item in &signature.items {
            self.sig_kind_references(&item.kind, scope);
            if !item.name.is_empty() {
                self.define(
                    &item.name,
                    format!("{}: {}", item.name, format_sig_kind(&item.kind)),
                    DefinitionKind::Parameter,
                    item.span,
                    scope,
                );
            }
        }
    }

    fn signature_references(&mut self, signature: &ast::Signature, scope: usize) {
        for item in &signature.items {
            self.sig_kind_references(&item.kind, scope);
        }
    }

    fn sig_kind_references(&mut self, kind: &ast::SigKind, scope: usize) {
        match kind {
            ast::SigKind::Ident(ident) => self.references.push(Reference {
                name: ident.name.clone(),
                span: ident.span,
                scope,
            }),
            ast::SigKind::Sig(signature) => self.signature_references(signature, scope),
            ast::SigKind::GenericInst { args, .. } => {
                for argument in args {
                    self.sig_kind_references(argument, scope);
                }
            }
            ast::SigKind::Byte
            | ast::SigKind::Int
            | ast::SigKind::Str
            | ast::SigKind::F64
            | ast::SigKind::Generic(_) => {}
        }
    }

    fn term(&mut self, term: &ast::Term, scope: usize, text: &str) {
        match term {
            ast::Term::Lit(_) => {}
            ast::Term::Lambda(lambda) => self.lambda(lambda, scope, text),
            ast::Term::Ident(ident) => self.ident(ident, scope, text),
        }
    }

    fn ident(&mut self, ident: &ast::Ident, scope: usize, text: &str) {
        self.references.push(Reference {
            name: ident.name.clone(),
            span: ident.span,
            scope,
        });
        for argument in &ident.args {
            self.term(&argument.term, scope, text);
        }
    }

    fn define(
        &mut self,
        name: &str,
        detail: String,
        kind: DefinitionKind,
        span: Span,
        scope: usize,
    ) {
        self.definitions.push(Definition {
            name: name.to_string(),
            detail,
            import_path: None,
            import_path_offset: None,
            kind,
            span,
            scope,
        });
    }

    fn new_scope(&mut self, parent: usize) -> usize {
        let id = self.scopes.len();
        self.scopes.push(Scope {
            parent: Some(parent),
        });
        id
    }
}

fn source_path_offset(text: &str, span: Span, label: &str, path: &str) -> Option<usize> {
    let start = span.offset.checked_add(label.len())?;
    let line_end = text[start..]
        .find(['\n', '\r'])
        .map_or(text.len(), |end| start + end);
    text[start..line_end]
        .find(path)
        .map(|offset| start + offset)
}

fn format_signature(signature: &ast::Signature, has_parameter_names: bool) -> String {
    let generics = if signature.generics.is_empty() {
        String::new()
    } else {
        format!(
            "<{}>",
            signature
                .generics
                .iter()
                .cloned()
                .collect::<Vec<_>>()
                .join(", ")
        )
    };
    let items = signature
        .items
        .iter()
        .map(|item| {
            let kind = format_sig_kind(&item.kind);
            let kind = if item.is_comptime {
                format!("{kind}!")
            } else {
                kind
            };
            if has_parameter_names && !item.name.is_empty() {
                format!("{}: {kind}", item.name)
            } else {
                kind
            }
        })
        .collect::<Vec<_>>()
        .join(", ");
    format!("{generics}({items})")
}

fn format_sig_kind(kind: &ast::SigKind) -> String {
    match kind {
        ast::SigKind::Byte => "@byte".to_string(),
        ast::SigKind::Int => "@int".to_string(),
        ast::SigKind::Str => "@str".to_string(),
        ast::SigKind::F64 => "@f64".to_string(),
        ast::SigKind::Ident(ident) => ident.name.clone(),
        ast::SigKind::Sig(signature) => format_signature(signature, true),
        ast::SigKind::GenericInst { name, args } => format!(
            "{name}<{}>",
            args.iter()
                .map(format_sig_kind)
                .collect::<Vec<_>>()
                .join(", ")
        ),
        ast::SigKind::Generic(name) => name.clone(),
    }
}

fn format_literal(literal: &ast::Literal) -> String {
    match &literal.value {
        ast::Lit::Str(value) => format!("{value:?}"),
        ast::Lit::Int(value) => value.to_string(),
        ast::Lit::F64(value) => value.to_string(),
    }
}

fn format_ident(ident: &ast::Ident) -> String {
    if ident.args.is_empty() {
        return ident.name.clone();
    }
    format!("{}(…)", ident.name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn indexes_nested_parameters_and_references() {
        let analysis = Analysis::new("id: <T>(value: T, ok: (T)) {\n    ok(value)\n}\n");
        assert!(analysis.parse_error().is_none());
        assert!(analysis
            .definitions()
            .iter()
            .any(|definition| definition.name == "value"));
        let reference = analysis
            .references
            .iter()
            .find(|reference| reference.name == "value")
            .expect("value reference");
        assert_eq!(
            analysis
                .resolve_local("value", reference.scope, reference.span.offset)
                .map(|definition| definition.kind),
            Some(DefinitionKind::Parameter)
        );
    }

    #[test]
    fn keeps_items_before_a_parse_error_available() {
        let analysis = Analysis::new("name: \"Alice\"\nbroken: {\n");
        assert!(analysis.parse_error().is_some());
        assert_eq!(analysis.definitions()[0].name, "name");
    }
}
