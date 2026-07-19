use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs;
use std::io::Cursor;
use std::path::{Component, Path, PathBuf};

use crate::ast;
use crate::builtins;
use crate::error::{Code, Error, Source};
use crate::lexer::Lexer;
use crate::parser::Parser;
use crate::span::Span;

pub struct Project {
    pub items: Vec<ast::BlockItem>,
    pub target: String,
    pub sources: Vec<Source>,
}

struct SourceFile {
    path: PathBuf,
    items: Vec<ast::BlockItem>,
}

struct Module {
    path: PathBuf,
    files: Vec<SourceFile>,
    declarations: BTreeMap<String, PathBuf>,
}

pub fn load(entry_path: &Path, target: &str) -> Result<Project, Error> {
    let entry_path = entry_path.canonicalize()?;
    let project_root = entry_path
        .parent()
        .ok_or_else(|| source_error("entry source must have a containing folder"))?
        .canonicalize()?;
    let is_test = is_test_source(&entry_path);
    let mut loader = Loader {
        project_root: project_root.clone(),
        entry_path,
        is_test,
        visiting: Vec::new(),
        loaded: HashSet::new(),
        modules: Vec::new(),
        sources: Vec::new(),
        next_offset: 1,
    };
    if let Err(error) = loader.load_module(project_root.clone()) {
        return Err(attach_source(error, &loader.sources));
    }

    let declarations = loader
        .modules
        .iter()
        .map(|module| {
            let names = module
                .declarations
                .keys()
                .map(|name| (name.clone(), qualify(&project_root, &module.path, name)))
                .collect();
            (module.path.clone(), names)
        })
        .collect::<HashMap<PathBuf, HashMap<String, String>>>();
    let public_declarations = loader
        .modules
        .iter()
        .map(|module| {
            let names = module
                .declarations
                .iter()
                .filter(|(_, source)| !is_private_source(source))
                .map(|(name, _)| (name.clone(), qualify(&project_root, &module.path, name)))
                .collect();
            (module.path.clone(), names)
        })
        .collect::<HashMap<PathBuf, HashMap<String, String>>>();
    let target = public_declarations
        .get(&project_root)
        .and_then(|names| names.get(target))
        .cloned()
        .ok_or_else(|| source_error(format!("could not resolve target '{target}'")))?;
    let mut items = Vec::new();
    let sources = loader.sources;
    for module in loader.modules {
        rewrite_module(
            &project_root,
            module,
            &declarations,
            &public_declarations,
            &mut items,
        )
        .map_err(|error| attach_source(error, &sources))?;
    }
    let (functions, mut non_functions): (Vec<_>, Vec<_>) = items
        .into_iter()
        .partition(|item| matches!(item, ast::BlockItem::FunctionDef { .. }));
    non_functions.extend(functions);
    Ok(Project {
        items: non_functions,
        target,
        sources,
    })
}

struct Loader {
    project_root: PathBuf,
    entry_path: PathBuf,
    is_test: bool,
    visiting: Vec<PathBuf>,
    loaded: HashSet<PathBuf>,
    modules: Vec<Module>,
    sources: Vec<Source>,
    next_offset: usize,
}

impl Loader {
    fn load_module(&mut self, path: PathBuf) -> Result<(), Error> {
        if self.loaded.contains(&path) {
            return Ok(());
        }
        if let Some(start) = self.visiting.iter().position(|item| item == &path) {
            let mut cycle = self.visiting[start..]
                .iter()
                .map(|item| display_module(&self.project_root, item))
                .collect::<Vec<_>>();
            cycle.push(display_module(&self.project_root, &path));
            return Err(source_error(format!(
                "source import cycle: {}",
                cycle.join(" -> ")
            )));
        }

        self.visiting.push(path.clone());
        let module = read_module(
            &self.project_root,
            &path,
            &self.entry_path,
            self.is_test && path == self.project_root,
            &mut self.next_offset,
            &mut self.sources,
        )?;
        let import_paths = module
            .files
            .iter()
            .flat_map(|file| file.items.iter())
            .filter_map(|item| match item {
                ast::BlockItem::Import { path, span, .. } if path.starts_with('/') => {
                    Some((path.clone(), *span))
                }
                _ => None,
            })
            .collect::<Vec<_>>();
        for (import, span) in import_paths {
            let imported_path = resolve_import(&self.project_root, &import, span)?;
            self.load_module(imported_path)?;
        }
        self.visiting.pop();
        self.loaded.insert(path);
        self.modules.push(module);
        Ok(())
    }
}

fn read_module(
    project_root: &Path,
    path: &Path,
    entry_path: &Path,
    include_tests: bool,
    next_offset: &mut usize,
    sources: &mut Vec<Source>,
) -> Result<Module, Error> {
    if !path.is_dir() {
        return Err(source_error(format!(
            "source import '{}' is not a folder",
            path.display()
        )));
    }
    let mut paths = fs::read_dir(path)?
        .filter_map(|entry| entry.ok().map(|entry| entry.path()))
        .filter(|path| {
            path.is_file()
                && path.extension().and_then(|extension| extension.to_str()) == Some("af")
                && (include_tests || !is_test_source(path))
        })
        .collect::<Vec<_>>();
    paths.sort();
    if paths.is_empty() {
        return Err(source_error(format!(
            "source folder '{}' contains no .af files",
            path.display()
        )));
    }

    let mut declarations = BTreeMap::new();
    let mut bindings = BTreeMap::new();
    let mut files = Vec::new();
    for file_path in paths {
        let source = fs::read(&file_path)?;
        let source_offset = *next_offset;
        *next_offset += source.len() + 1;
        let diagnostic_source = Source::new(
            relative_path(project_root, &file_path),
            String::from_utf8_lossy(&source).into_owned(),
            source_offset,
        );
        sources.push(diagnostic_source.clone());
        let items = (|| -> Result<Vec<ast::BlockItem>, Error> {
            let mut parser = Parser::new(Lexer::with_offset(Cursor::new(source), source_offset));
            let mut items = Vec::new();
            while let Some(item) = parser.next_block_item()? {
                reject_root_execution(&item)?;
                validate_builtin_override(&item, &file_path, entry_path)?;
                if let Some(name) = declaration_name(&item) {
                    if let Some(previous) = bindings.insert(name.to_string(), file_path.clone()) {
                        return Err(Error::new(
                            Code::Resolve,
                            format!(
                                "duplicate symbol `{name}` in folder '{}' (declared in '{}' and '{}')",
                                path.display(),
                                previous.display(),
                                file_path.display()
                            ),
                            item.span(),
                        ));
                    }
                }
                if !matches!(item, ast::BlockItem::Import { .. }) {
                    if let Some(name) = declaration_name(&item) {
                        if let Some(previous) =
                            declarations.insert(name.to_string(), file_path.clone())
                        {
                            return Err(Error::new(
                                Code::Resolve,
                                format!(
                                    "duplicate symbol `{name}` in folder '{}' (declared in '{}' and '{}')",
                                    path.display(),
                                    previous.display(),
                                    file_path.display()
                                ),
                                item.span(),
                            ));
                        }
                    }
                }
                items.push(item);
            }
            Ok(items)
        })()
        .map_err(|error| error.with_source(diagnostic_source))?;
        files.push(SourceFile {
            path: file_path,
            items,
        });
    }
    Ok(Module {
        path: path.to_path_buf(),
        files,
        declarations,
    })
}

fn resolve_import(project_root: &Path, import: &str, span: Span) -> Result<PathBuf, Error> {
    if import == "/" {
        return Err(Error::new(
            Code::Resolve,
            "the root package cannot be imported",
            span,
        ));
    }
    let path = Path::new(import);
    if !path.is_absolute() {
        return Err(Error::new(
            Code::Resolve,
            format!("source import '{import}' must start with '/'"),
            span,
        ));
    }
    let mut relative = PathBuf::new();
    for component in path.components() {
        match component {
            Component::RootDir => {}
            Component::Normal(part) => relative.push(part),
            _ => {
                return Err(Error::new(
                    Code::Resolve,
                    format!("source import '{import}' must not contain '.' or '..'"),
                    span,
                ))
            }
        }
    }
    let project_path = project_root.join(&relative);
    let resolved = project_path
        .canonicalize()
        .or_else(|project_error| {
            bundled_library_root()
                .join(&relative)
                .canonicalize()
                .map_err(|_| project_error)
        })
        .map_err(|error| {
            Error::new(
                Code::Io,
                format!("could not resolve source import '{import}': {error}"),
                span,
            )
        })?;
    if !resolved.starts_with(project_root) && !resolved.starts_with(bundled_library_root()) {
        return Err(Error::new(
            Code::Resolve,
            format!("source import '{import}' escapes the project root"),
            span,
        ));
    }
    Ok(resolved)
}

fn rewrite_module(
    project_root: &Path,
    module: Module,
    declarations: &HashMap<PathBuf, HashMap<String, String>>,
    public_declarations: &HashMap<PathBuf, HashMap<String, String>>,
    output: &mut Vec<ast::BlockItem>,
) -> Result<(), Error> {
    let qualified = declarations
        .get(&module.path)
        .expect("loaded module has declaration names");
    for file in module.files {
        let imports = file
            .items
            .iter()
            .filter_map(|item| match item {
                ast::BlockItem::Import {
                    label, path, span, ..
                } if path.starts_with('/') => Some(
                    resolve_import(project_root, path, *span)
                        .map(|resolved| (label.clone(), resolved)),
                ),
                _ => None,
            })
            .collect::<Result<HashMap<_, _>, _>>()?;
        let sibling_names = module
            .declarations
            .iter()
            .filter(|(_, owner)| {
                *owner != &file.path && (is_test_source(&file.path) || !is_test_source(owner))
            })
            .map(|(name, _)| name.clone())
            .collect::<HashSet<_>>();
        let mut state = RewriteState {
            project_root,
            file_path: &file.path,
            public_declarations,
            owners: &module.declarations,
            qualified,
            available: sibling_names,
            imports: imports.clone(),
            available_imports: HashSet::new(),
        };
        for item in file.items {
            if let ast::BlockItem::Import { label, path, .. } = &item {
                if path.starts_with('/') {
                    state.available_imports.insert(label.clone());
                }
                continue;
            }
            let name = declaration_name(&item).map(str::to_string);
            let is_recursive = matches!(
                item,
                ast::BlockItem::FunctionDef { .. } | ast::BlockItem::SigDef { .. }
            );
            if is_recursive {
                if let Some(name) = &name {
                    state.available.insert(name.clone());
                }
            }
            output.push(state.rewrite_root_item(item)?);
            if let Some(name) = name {
                state.available.insert(name);
            }
        }
    }
    Ok(())
}

struct RewriteState<'a> {
    project_root: &'a Path,
    file_path: &'a Path,
    public_declarations: &'a HashMap<PathBuf, HashMap<String, String>>,
    owners: &'a BTreeMap<String, PathBuf>,
    qualified: &'a HashMap<String, String>,
    available: HashSet<String>,
    imports: HashMap<String, PathBuf>,
    available_imports: HashSet<String>,
}

impl RewriteState<'_> {
    fn rewrite_root_item(&self, item: ast::BlockItem) -> Result<ast::BlockItem, Error> {
        let mut item = item;
        match &mut item {
            ast::BlockItem::SigDef { name, .. }
            | ast::BlockItem::FunctionDef { name, .. }
            | ast::BlockItem::LitDef { name, .. }
            | ast::BlockItem::IdentDef { name, .. } => {
                *name =
                    self.qualified.get(name).cloned().ok_or_else(|| {
                        source_error(format!("missing package declaration '{name}'"))
                    })?;
            }
            _ => {}
        }
        let mut locals = HashSet::new();
        self.rewrite_item(item, &mut locals)
    }

    fn rewrite_item(
        &self,
        item: ast::BlockItem,
        locals: &mut HashSet<String>,
    ) -> Result<ast::BlockItem, Error> {
        Ok(match item {
            ast::BlockItem::Import { span, .. } => {
                return Err(Error::new(
                    Code::Parse,
                    "source imports are only allowed at file root",
                    span,
                ))
            }
            ast::BlockItem::SigDef { name, sig, span } => {
                let mut type_locals = locals.clone();
                type_locals.extend(sig.generics.iter().cloned());
                let sig = self.rewrite_signature(sig, &type_locals)?;
                locals.insert(name.clone());
                ast::BlockItem::SigDef { name, sig, span }
            }
            ast::BlockItem::FunctionDef { name, lambda, span } => {
                locals.insert(name.clone());
                ast::BlockItem::FunctionDef {
                    name,
                    lambda: self.rewrite_lambda(lambda, locals)?,
                    span,
                }
            }
            ast::BlockItem::LitDef {
                name,
                literal,
                span,
            } => {
                locals.insert(name.clone());
                ast::BlockItem::LitDef {
                    name,
                    literal,
                    span,
                }
            }
            ast::BlockItem::IdentDef {
                name,
                mut ident,
                span,
            } => {
                self.rewrite_ident(&mut ident, locals)?;
                locals.insert(name.clone());
                ast::BlockItem::IdentDef { name, ident, span }
            }
            ast::BlockItem::Ident(mut ident) => {
                self.rewrite_ident(&mut ident, locals)?;
                ast::BlockItem::Ident(ident)
            }
            ast::BlockItem::Lambda(lambda) => {
                ast::BlockItem::Lambda(self.rewrite_lambda(lambda, locals)?)
            }
            ast::BlockItem::ScopeCapture {
                params,
                continuation,
                mut term,
                span,
            } => {
                let params = self.rewrite_signature(params, locals)?;
                self.rewrite_term(&mut term, locals)?;
                let mut continuation_locals = locals.clone();
                continuation_locals.extend(params.items.iter().map(|item| item.name.clone()));
                ast::BlockItem::ScopeCapture {
                    params,
                    continuation: self.rewrite_block(continuation, &mut continuation_locals)?,
                    term,
                    span,
                }
            }
        })
    }

    fn rewrite_block(
        &self,
        block: ast::Block,
        locals: &mut HashSet<String>,
    ) -> Result<ast::Block, Error> {
        let mut items = Vec::with_capacity(block.items.len());
        for item in block.items {
            items.push(self.rewrite_item(item, locals)?);
        }
        Ok(ast::Block {
            items,
            span: block.span,
        })
    }

    fn rewrite_lambda(
        &self,
        mut lambda: ast::Lambda,
        locals: &HashSet<String>,
    ) -> Result<ast::Lambda, Error> {
        lambda.params = self.rewrite_signature(lambda.params, locals)?;
        for arg in &mut lambda.args {
            self.rewrite_term(&mut arg.term, locals)?;
        }
        let mut body_locals = locals.clone();
        body_locals.extend(lambda.params.generics.iter().cloned());
        body_locals.extend(lambda.params.items.iter().map(|item| item.name.clone()));
        lambda.body = self.rewrite_block(lambda.body, &mut body_locals)?;
        Ok(lambda)
    }

    fn rewrite_signature(
        &self,
        mut signature: ast::Signature,
        locals: &HashSet<String>,
    ) -> Result<ast::Signature, Error> {
        for item in &mut signature.items {
            self.rewrite_type(&mut item.kind, locals)?;
        }
        Ok(signature)
    }

    fn rewrite_type(&self, kind: &mut ast::SigKind, locals: &HashSet<String>) -> Result<(), Error> {
        match kind {
            ast::SigKind::Ident(ident) => {
                ident.name = self.rewrite_name(&ident.name, locals, ident.span)?
            }
            ast::SigKind::Sig(signature) => {
                *signature = self.rewrite_signature(signature.clone(), locals)?;
            }
            ast::SigKind::GenericInst { name, args } => {
                *name = self.rewrite_name(name, locals, Span::unknown())?;
                for arg in args {
                    self.rewrite_type(arg, locals)?;
                }
            }
            _ => {}
        }
        Ok(())
    }

    fn rewrite_ident(&self, ident: &mut ast::Ident, locals: &HashSet<String>) -> Result<(), Error> {
        ident.name = self.rewrite_name(&ident.name, locals, ident.span)?;
        for arg in &mut ident.args {
            self.rewrite_term(&mut arg.term, locals)?;
        }
        Ok(())
    }

    fn rewrite_term(&self, term: &mut ast::Term, locals: &HashSet<String>) -> Result<(), Error> {
        match term {
            ast::Term::Ident(ident) => self.rewrite_ident(ident, locals),
            ast::Term::Lambda(lambda) => {
                *lambda = self.rewrite_lambda(lambda.clone(), locals)?;
                Ok(())
            }
            ast::Term::Lit(_) => Ok(()),
        }
    }

    fn rewrite_name(
        &self,
        name: &str,
        locals: &HashSet<String>,
        span: Span,
    ) -> Result<String, Error> {
        if name.starts_with('@') || locals.contains(name) {
            return Ok(name.to_string());
        }
        if name.contains('.') {
            let parts = name.split('.').collect::<Vec<_>>();
            if parts.len() != 2 {
                return Err(Error::new(
                    Code::Resolve,
                    format!("source import access '{name}' must contain one member name"),
                    span,
                ));
            }
            let module_path = self.imports.get(parts[0]).ok_or_else(|| {
                Error::new(
                    Code::Resolve,
                    format!("unknown source import label '{}'", parts[0]),
                    span,
                )
            })?;
            if !self.available_imports.contains(parts[0]) {
                return Err(Error::new(
                    Code::HIR,
                    format!(
                        "source import '{}' is not defined before this use",
                        parts[0]
                    ),
                    span,
                ));
            }
            return self
                .public_declarations
                .get(module_path)
                .and_then(|names| names.get(parts[1]))
                .cloned()
                .ok_or_else(|| {
                    Error::new(
                        Code::Resolve,
                        format!(
                            "folder '{}' has no label '{}'",
                            display_module(self.project_root, module_path),
                            parts[1]
                        ),
                        span,
                    )
                });
        }
        if self.available.contains(name) {
            return Ok(self
                .qualified
                .get(name)
                .expect("available declaration is qualified")
                .clone());
        }
        if self
            .owners
            .get(name)
            .is_some_and(|owner| owner == self.file_path)
        {
            return Err(Error::new(
                Code::HIR,
                format!("`{name}` is not defined before this use"),
                span,
            ));
        }
        if !is_test_source(self.file_path)
            && self
                .owners
                .get(name)
                .is_some_and(|owner| is_test_source(owner))
        {
            return Err(Error::new(
                Code::Resolve,
                format!("`{name}` is only available to _test.af sources"),
                span,
            ));
        }
        Ok(name.to_string())
    }
}

fn declaration_name(item: &ast::BlockItem) -> Option<&str> {
    match item {
        ast::BlockItem::SigDef { name: label, .. }
        | ast::BlockItem::FunctionDef { name: label, .. }
        | ast::BlockItem::LitDef { name: label, .. }
        | ast::BlockItem::IdentDef { name: label, .. } => Some(label),
        ast::BlockItem::Import { .. }
        | ast::BlockItem::Ident(_)
        | ast::BlockItem::Lambda(_)
        | ast::BlockItem::ScopeCapture { .. } => None,
    }
}

fn validate_builtin_override(
    item: &ast::BlockItem,
    source_path: &Path,
    entry_path: &Path,
) -> Result<(), Error> {
    let Some(name) = declaration_name(item).filter(|name| name.starts_with('@')) else {
        return Ok(());
    };
    if source_path != entry_path || !is_test_source(source_path) {
        return Err(Error::new(
            Code::Parse,
            "builtin overrides are only allowed in the selected _test.af entry source",
            item.span(),
        ));
    }
    let builtin = name.trim_start_matches('@');
    if builtins::function_from_name(builtin).is_none() {
        return Err(Error::new(
            Code::Resolve,
            format!("only callable builtins can be overridden; '@{builtin}' is not callable"),
            item.span(),
        ));
    }
    if !matches!(item, ast::BlockItem::IdentDef { ident, .. } if ident.args.is_empty()) {
        return Err(Error::new(
            Code::Parse,
            format!("builtin override '@{builtin}' must alias a function"),
            item.span(),
        ));
    }
    Ok(())
}

fn is_private_source(path: &Path) -> bool {
    path.file_name()
        .is_some_and(|name| name.as_encoded_bytes().starts_with(b"_"))
}

fn is_test_source(path: &Path) -> bool {
    path.file_name()
        .is_some_and(|name| name.as_encoded_bytes().ends_with(b"_test.af"))
}

fn qualify(project_root: &Path, module_path: &Path, name: &str) -> String {
    let relative = module_relative(project_root, module_path);
    if relative.as_os_str().is_empty() {
        return name.to_string();
    }
    let module = relative
        .to_string_lossy()
        .as_bytes()
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect::<String>();
    format!("__rgo_{module}__{name}")
}

fn display_module(project_root: &Path, path: &Path) -> String {
    let relative = module_relative(project_root, path);
    format!("/{}", relative.display())
}

fn bundled_library_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .expect("frontend manifest must be inside the repository")
        .join("lib")
}

fn module_relative<'a>(project_root: &'a Path, path: &'a Path) -> &'a Path {
    path.strip_prefix(project_root)
        .or_else(|_| path.strip_prefix(bundled_library_root()))
        .unwrap_or(path)
}

fn reject_root_execution(item: &ast::BlockItem) -> Result<(), Error> {
    match item {
        ast::BlockItem::Ident(_)
        | ast::BlockItem::Lambda(_)
        | ast::BlockItem::ScopeCapture { .. } => Err(Error::new(
            Code::Parse,
            "root-level invocation is not supported; choose a target function",
            item.span(),
        )),
        _ => Ok(()),
    }
}

fn source_error(message: impl Into<String>) -> Error {
    Error::new(Code::Resolve, message, Span::unknown())
}

pub fn attach_source(error: Error, sources: &[Source]) -> Error {
    if error.source.is_some() {
        return error;
    }
    let Some(source) = sources
        .iter()
        .find(|source| source.contains(error.span))
        .cloned()
    else {
        return error;
    };
    error.with_source(source)
}

fn relative_path(project_root: &Path, path: &Path) -> PathBuf {
    let current_dir = std::env::current_dir()
        .ok()
        .and_then(|path| path.canonicalize().ok());
    if let Some(relative) = current_dir
        .as_deref()
        .and_then(|current_dir| path.strip_prefix(current_dir).ok())
    {
        return relative.to_path_buf();
    }
    module_relative(project_root, path).to_path_buf()
}
