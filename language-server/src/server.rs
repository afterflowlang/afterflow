use std::collections::{HashMap, HashSet};
use std::error::Error as StdError;
use std::fmt::{self, Display, Formatter};
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::Arc;

use afterflow_frontend::builtins::{self, BuiltinSpec};
use afterflow_frontend::hir;
use language_server_protocol::types::request::Request as _;
use language_server_protocol::types::{
    self, request, CompletionItem, CompletionItemKind, CompletionOptions, CompletionParams,
    CompletionResponse, Diagnostic, DiagnosticSeverity, DocumentSymbol, DocumentSymbolParams,
    DocumentSymbolResponse, GotoDefinitionParams, GotoDefinitionResponse, Hover, HoverContents,
    HoverParams, InitializeParams, InitializeResult, Location, MarkupContent, MarkupKind,
    NumberOrString, OneOf, PositionEncodingKind, PublishDiagnosticsParams, ServerCapabilities,
    ServerInfo, SymbolKind, TextDocumentSyncCapability, TextDocumentSyncKind, Url,
};
use language_server_protocol::{
    from_value, to_value, Connection, ErrorCode, Message, Notification, Request, Response,
    ResponseError, Value,
};

use crate::analysis::{Definition, DefinitionKind};
use crate::document::Document;

const SERVER_NAME: &str = "afterflow-ls";
const BUILTIN_SCHEME: &str = "afterflow-builtin";
const VIRTUAL_DOCUMENT_REQUEST: &str = "afterflow/virtualDocument";

#[derive(Debug)]
pub struct Error {
    message: String,
}

impl Error {
    fn new(error: impl Display) -> Self {
        Self {
            message: error.to_string(),
        }
    }
}

impl Display for Error {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        f.write_str(&self.message)
    }
}

impl StdError for Error {}

/// Runs an Afterflow language server over standard input and output.
///
/// # Errors
///
/// Returns an error when protocol initialization, message transport, or
/// serialization fails.
pub fn run() -> Result<(), Error> {
    let (connection, io_threads) = Connection::stdio();
    let (initialize_id, initialize_params) = connection.initialize_start().map_err(Error::new)?;
    let initialize_params: InitializeParams = from_value(initialize_params).map_err(Error::new)?;
    let root = workspace_root(&initialize_params);
    let result = InitializeResult {
        capabilities: server_capabilities(),
        server_info: Some(ServerInfo {
            name: SERVER_NAME.to_string(),
            version: Some(env!("CARGO_PKG_VERSION").to_string()),
        }),
    };
    connection
        .initialize_finish(initialize_id, to_value(result).map_err(Error::new)?)
        .map_err(Error::new)?;

    let mut server = Server::new(root);
    server.serve(&connection)?;
    drop(connection);
    io_threads.join().map_err(Error::new)
}

#[allow(deprecated)]
fn workspace_root(params: &InitializeParams) -> Option<PathBuf> {
    params
        .workspace_folders
        .as_ref()
        .and_then(|folders| folders.first())
        .map(|folder| &folder.uri)
        .or(params.root_uri.as_ref())
        .and_then(|uri| uri.to_file_path().ok())
}

fn server_capabilities() -> ServerCapabilities {
    ServerCapabilities {
        position_encoding: Some(PositionEncodingKind::UTF16),
        text_document_sync: Some(TextDocumentSyncCapability::Kind(TextDocumentSyncKind::FULL)),
        hover_provider: Some(types::HoverProviderCapability::Simple(true)),
        completion_provider: Some(CompletionOptions::default()),
        definition_provider: Some(OneOf::Left(true)),
        document_symbol_provider: Some(OneOf::Left(true)),
        ..ServerCapabilities::default()
    }
}

struct Server {
    session: Session,
}

impl Server {
    fn new(root: Option<PathBuf>) -> Self {
        Self {
            session: Session::new(root),
        }
    }

    fn serve(&mut self, connection: &Connection) -> Result<(), Error> {
        for message in &connection.receiver {
            match message {
                Message::Request(request) => {
                    if connection.handle_shutdown(&request).map_err(Error::new)? {
                        return Ok(());
                    }
                    let response = self.request(request);
                    connection
                        .sender
                        .send(Message::Response(response))
                        .map_err(Error::new)?;
                }
                Message::Notification(notification) => {
                    self.notification(notification, connection)?;
                }
                Message::Response(_) => {}
            }
        }
        Ok(())
    }

    fn request(&self, request: Request) -> Response {
        let result =
            match request.method.as_str() {
                request::HoverRequest::METHOD => self
                    .parse::<HoverParams>(request.params)
                    .and_then(|params| {
                        to_value(self.session.snapshot.hover(params)).map_err(Error::new)
                    }),
                request::GotoDefinition::METHOD => self
                    .parse::<GotoDefinitionParams>(request.params)
                    .and_then(|params| {
                        to_value(self.session.snapshot.definition(params)).map_err(Error::new)
                    }),
                request::DocumentSymbolRequest::METHOD => self
                    .parse::<DocumentSymbolParams>(request.params)
                    .and_then(|params| {
                        to_value(self.session.snapshot.document_symbols(params)).map_err(Error::new)
                    }),
                request::Completion::METHOD => self
                    .parse::<CompletionParams>(request.params)
                    .and_then(|params| {
                        to_value(self.session.snapshot.completion(params)).map_err(Error::new)
                    }),
                VIRTUAL_DOCUMENT_REQUEST => self
                    .parse::<HashMap<String, String>>(request.params)
                    .and_then(|params| {
                        let uri = params
                            .get("uri")
                            .ok_or_else(|| Error::new("missing virtual document URI"))?;
                        to_value(builtin_source_for_uri(uri)).map_err(Error::new)
                    }),
                _ => {
                    return Response {
                        id: request.id,
                        result: None,
                        error: Some(ResponseError {
                            code: ErrorCode::MethodNotFound as i32,
                            message: format!("unsupported request '{}'", request.method),
                            data: None,
                        }),
                    };
                }
            };
        match result {
            Ok(result) => Response::new_ok(request.id, result),
            Err(error) => Response::new_err(
                request.id,
                ErrorCode::InvalidParams as i32,
                error.to_string(),
            ),
        }
    }

    fn parse<T: language_server_protocol::DeserializeOwned>(
        &self,
        value: Value,
    ) -> Result<T, Error> {
        from_value(value).map_err(Error::new)
    }

    fn notification(
        &mut self,
        notification: Notification,
        connection: &Connection,
    ) -> Result<(), Error> {
        let changed = match notification.method.as_str() {
            "textDocument/didOpen" => {
                let params: types::DidOpenTextDocumentParams =
                    from_value(notification.params).map_err(Error::new)?;
                let uri = params.text_document.uri.clone();
                self.session.open(
                    uri.clone(),
                    params.text_document.version,
                    params.text_document.text,
                );
                Some(uri)
            }
            "textDocument/didChange" => {
                let params: types::DidChangeTextDocumentParams =
                    from_value(notification.params).map_err(Error::new)?;
                let uri = params.text_document.uri.clone();
                if let Some(change) = params.content_changes.into_iter().last() {
                    self.session
                        .change(uri.clone(), params.text_document.version, change.text);
                    Some(uri)
                } else {
                    None
                }
            }
            "textDocument/didSave" => {
                let params: types::DidSaveTextDocumentParams =
                    from_value(notification.params).map_err(Error::new)?;
                let uri = params.text_document.uri.clone();
                self.session.save(uri.clone(), params.text);
                Some(uri)
            }
            "textDocument/didClose" => {
                let params: types::DidCloseTextDocumentParams =
                    from_value(notification.params).map_err(Error::new)?;
                let uri = params.text_document.uri.clone();
                self.session.close(&uri);
                Some(uri)
            }
            _ => None,
        };
        if let Some(uri) = changed {
            self.publish_diagnostics(connection, uri)?;
        }
        Ok(())
    }

    fn publish_diagnostics(&self, connection: &Connection, uri: Url) -> Result<(), Error> {
        let (diagnostics, version) = self
            .session
            .snapshot
            .document(&uri)
            .map(|document| (diagnostics(document), document.version()))
            .unwrap_or_default();
        let params = PublishDiagnosticsParams::new(uri, diagnostics, version);
        let notification = Notification::new("textDocument/publishDiagnostics".to_string(), params);
        connection
            .sender
            .send(Message::Notification(notification))
            .map_err(Error::new)
    }
}

struct Session {
    root: Option<PathBuf>,
    open: HashSet<Url>,
    snapshot: Arc<Snapshot>,
}

impl Session {
    fn new(root: Option<PathBuf>) -> Self {
        let snapshot = Arc::new(Snapshot::load(root.clone()));
        Self {
            root,
            open: HashSet::new(),
            snapshot,
        }
    }

    fn open(&mut self, uri: Url, version: i32, text: String) {
        self.open.insert(uri.clone());
        self.replace(Document::new(uri, Some(version), text));
    }

    fn change(&mut self, uri: Url, version: i32, text: String) {
        if self.open.contains(&uri) {
            self.replace(Document::new(uri, Some(version), text));
        }
    }

    fn save(&mut self, uri: Url, text: Option<String>) {
        if let Some(text) = text {
            let version = self.snapshot.document(&uri).and_then(Document::version);
            self.replace(Document::new(uri, version, text));
        } else if !self.open.contains(&uri) {
            self.reload(uri);
        }
    }

    fn close(&mut self, uri: &Url) {
        self.open.remove(uri);
        self.reload(uri.clone());
    }

    fn reload(&mut self, uri: Url) {
        let mut documents = self.snapshot.documents.clone();
        if let Some(document) = read_document(uri.clone()) {
            documents.insert(uri, Arc::new(document));
        } else {
            documents.remove(&uri);
        }
        self.snapshot = Arc::new(Snapshot {
            root: self.root.clone(),
            documents,
        });
    }

    fn replace(&mut self, document: Document) {
        let mut documents = self.snapshot.documents.clone();
        documents.insert(document.uri().clone(), Arc::new(document));
        self.snapshot = Arc::new(Snapshot {
            root: self.root.clone(),
            documents,
        });
    }
}

struct Snapshot {
    root: Option<PathBuf>,
    documents: HashMap<Url, Arc<Document>>,
}

impl Snapshot {
    fn load(root: Option<PathBuf>) -> Self {
        let mut documents = HashMap::new();
        if let Some(root) = &root {
            let mut paths = Vec::new();
            collect_afterflow_files(root, &mut paths);
            for path in paths {
                if let Ok(uri) = Url::from_file_path(&path) {
                    if let Some(document) = read_document(uri.clone()) {
                        documents.insert(uri, Arc::new(document));
                    }
                }
            }
        }
        Self { root, documents }
    }

    fn document(&self, uri: &Url) -> Option<&Document> {
        self.documents.get(uri).map(Arc::as_ref)
    }

    fn hover(&self, params: HoverParams) -> Option<Hover> {
        let text_params = params.text_document_position_params;
        let document = self.document(&text_params.text_document.uri)?;
        let offset = document.position_to_offset(text_params.position)?;
        let detail = if let Some(definition) = document.analysis().definition_at(offset) {
            Some(definition.detail.clone())
        } else if let Some((name, _, scope)) = document.analysis().reference_at(offset) {
            self.resolve(document, name, scope, offset)
                .map(|(_, definition)| definition.detail.clone())
                .or_else(|| builtin_detail(name))
        } else {
            None
        }?;
        Some(Hover {
            contents: HoverContents::Markup(MarkupContent {
                kind: MarkupKind::Markdown,
                value: format!("```afterflow\n{detail}\n```"),
            }),
            range: None,
        })
    }

    fn definition(&self, params: GotoDefinitionParams) -> Option<GotoDefinitionResponse> {
        let text_params = params.text_document_position_params;
        let document = self.document(&text_params.text_document.uri)?;
        let offset = document.position_to_offset(text_params.position)?;
        if let Some(definition) = document.analysis().definition_at(offset) {
            return Some(source_definition_location(document, definition));
        }
        let (name, _, scope) = document.analysis().reference_at(offset)?;
        if let Some((target_document, definition)) = self.resolve(document, name, scope, offset) {
            return Some(source_definition_location(target_document, definition));
        }
        builtin_location(name).map(GotoDefinitionResponse::Scalar)
    }

    fn document_symbols(&self, params: DocumentSymbolParams) -> Option<DocumentSymbolResponse> {
        let document = self.document(&params.text_document.uri)?;
        let symbols = document
            .analysis()
            .top_level_definitions()
            .map(|definition| document_symbol(document, definition))
            .collect();
        Some(DocumentSymbolResponse::Nested(symbols))
    }

    fn completion(&self, params: CompletionParams) -> Option<CompletionResponse> {
        let uri = &params.text_document_position.text_document.uri;
        let document = self.document(uri)?;
        let mut seen = HashSet::new();
        let mut items = Vec::new();
        for definition in document.analysis().definitions() {
            push_completion(&mut items, &mut seen, definition);
        }
        let directory = file_directory(document.uri());
        for candidate in self.documents.values().map(Arc::as_ref) {
            if candidate.uri() == document.uri() || file_directory(candidate.uri()) != directory {
                continue;
            }
            for definition in candidate.analysis().top_level_definitions() {
                push_completion(&mut items, &mut seen, definition);
            }
        }
        items.sort_by(|a, b| a.label.cmp(&b.label));
        Some(CompletionResponse::Array(items))
    }

    fn resolve<'a>(
        &'a self,
        document: &'a Document,
        name: &str,
        scope: usize,
        offset: usize,
    ) -> Option<(&'a Document, &'a Definition)> {
        let first = name.split('.').next().unwrap_or(name);
        if let Some(definition) = document.analysis().resolve_local(first, scope, offset) {
            if let Some(member) = name
                .strip_prefix(first)
                .and_then(|rest| rest.strip_prefix('.'))
            {
                return self.resolve_import(definition, member);
            }
            return Some((document, definition));
        }
        let directory = file_directory(document.uri());
        let found = self
            .documents
            .values()
            .map(Arc::as_ref)
            .filter(|candidate| file_directory(candidate.uri()) == directory)
            .find_map(|candidate| {
                candidate
                    .analysis()
                    .top_level_definitions()
                    .find(|definition| definition.name == first)
                    .map(|definition| (candidate, definition))
            })?;
        if let Some(member) = name
            .strip_prefix(first)
            .and_then(|rest| rest.strip_prefix('.'))
        {
            self.resolve_import(found.1, member)
        } else {
            Some(found)
        }
    }

    fn resolve_import<'a>(
        &'a self,
        import: &Definition,
        member: &str,
    ) -> Option<(&'a Document, &'a Definition)> {
        let root = self.root.as_ref()?;
        let path = import.import_path.as_deref()?.strip_prefix('/')?;
        let directory = root.join(path);
        self.documents
            .values()
            .map(Arc::as_ref)
            .filter(|document| file_directory(document.uri()).as_deref() == Some(&directory))
            .filter(|document| !is_private_source(document.uri()))
            .find_map(|document| {
                document
                    .analysis()
                    .top_level_definitions()
                    .find(|definition| definition.name == member)
                    .map(|definition| (document, definition))
            })
    }
}

fn collect_afterflow_files(path: &Path, output: &mut Vec<PathBuf>) {
    let Ok(entries) = fs::read_dir(path) else {
        return;
    };
    for entry in entries.flatten() {
        let path = entry.path();
        if path.is_dir() {
            let name = path.file_name().and_then(|name| name.to_str());
            if !matches!(name, Some(".git" | "backup" | "target")) {
                collect_afterflow_files(&path, output);
            }
        } else if path.extension().and_then(|extension| extension.to_str()) == Some("af") {
            output.push(path);
        }
    }
}

fn read_document(uri: Url) -> Option<Document> {
    let path = uri.to_file_path().ok()?;
    let text = fs::read_to_string(path).ok()?;
    Some(Document::new(uri, None, text))
}

fn file_directory(uri: &Url) -> Option<PathBuf> {
    uri.to_file_path().ok()?.parent().map(Path::to_path_buf)
}

fn is_private_source(uri: &Url) -> bool {
    uri.to_file_path()
        .ok()
        .and_then(|path| path.file_name().map(|name| name.to_owned()))
        .and_then(|name| name.to_str().map(|name| name.starts_with('_')))
        .unwrap_or(false)
}

fn diagnostics(document: &Document) -> Vec<Diagnostic> {
    document
        .analysis()
        .parse_error()
        .map(|error| {
            vec![Diagnostic {
                range: document.span_range(error.span),
                severity: Some(DiagnosticSeverity::ERROR),
                code: Some(NumberOrString::String(error.code.to_string())),
                code_description: None,
                source: Some("afterflow".to_string()),
                message: error.message.clone(),
                related_information: None,
                tags: None,
                data: None,
            }]
        })
        .unwrap_or_default()
}

fn document_symbol(document: &Document, definition: &Definition) -> DocumentSymbol {
    let range = document.name_range(definition.span, &definition.name);
    #[allow(deprecated)]
    DocumentSymbol {
        name: definition.name.clone(),
        detail: Some(definition.detail.clone()),
        kind: symbol_kind(definition.kind),
        tags: None,
        deprecated: None,
        range,
        selection_range: range,
        children: None,
    }
}

fn symbol_kind(kind: DefinitionKind) -> SymbolKind {
    match kind {
        DefinitionKind::Function => SymbolKind::FUNCTION,
        DefinitionKind::Type => SymbolKind::INTERFACE,
        DefinitionKind::Constant => SymbolKind::CONSTANT,
        DefinitionKind::Alias => SymbolKind::VARIABLE,
        DefinitionKind::Parameter => SymbolKind::VARIABLE,
        DefinitionKind::Namespace => SymbolKind::NAMESPACE,
    }
}

fn completion_kind(kind: DefinitionKind) -> CompletionItemKind {
    match kind {
        DefinitionKind::Function => CompletionItemKind::FUNCTION,
        DefinitionKind::Type => CompletionItemKind::INTERFACE,
        DefinitionKind::Constant => CompletionItemKind::CONSTANT,
        DefinitionKind::Alias => CompletionItemKind::VARIABLE,
        DefinitionKind::Parameter => CompletionItemKind::VARIABLE,
        DefinitionKind::Namespace => CompletionItemKind::MODULE,
    }
}

fn push_completion(
    items: &mut Vec<CompletionItem>,
    seen: &mut HashSet<String>,
    definition: &Definition,
) {
    if seen.insert(definition.name.clone()) {
        items.push(CompletionItem {
            label: definition.name.clone(),
            kind: Some(completion_kind(definition.kind)),
            detail: Some(definition.detail.clone()),
            ..CompletionItem::default()
        });
    }
}

fn builtin_detail(name: &str) -> Option<String> {
    let name = name.strip_prefix('@')?;
    match builtins::get_spec(name)? {
        BuiltinSpec::Function(signature) => {
            Some(format!("@{name}: {}", format_builtin_signature(&signature)))
        }
        BuiltinSpec::Type(kind) => Some(format!("@{name}: {}", format_builtin_kind(&kind))),
    }
}

fn format_builtin_signature(signature: &hir::Signature) -> String {
    let items = signature
        .items
        .iter()
        .map(|item| {
            let mut kind = format_builtin_kind(&item.kind);
            if item.is_comptime {
                kind.push('!');
            }
            if item.name.is_empty() {
                kind
            } else if kind.starts_with('(') {
                format!("{}:{kind}", item.name)
            } else {
                format!("{}: {kind}", item.name)
            }
        })
        .collect::<Vec<_>>()
        .join(", ");
    format!("({items})")
}

fn format_builtin_kind(kind: &hir::SigKind) -> String {
    match kind {
        hir::SigKind::Byte => "@byte".to_string(),
        hir::SigKind::Int => "@int".to_string(),
        hir::SigKind::UInt => "@uint".to_string(),
        hir::SigKind::Rune => "@rune".to_string(),
        hir::SigKind::FixedInt(kind) => format!("@{}", kind.name()),
        hir::SigKind::Bytes => "@bytes".to_string(),
        hir::SigKind::Str => "@str".to_string(),
        hir::SigKind::F64 => "@f64".to_string(),
        hir::SigKind::Sig(signature) => {
            let items = signature
                .items
                .iter()
                .map(|item| {
                    let mut kind = format_builtin_kind(&item.kind);
                    if item.is_comptime {
                        kind.push('!');
                    }
                    kind
                })
                .collect::<Vec<_>>()
                .join(", ");
            format!("({items})")
        }
        hir::SigKind::Ident(ident) => ident.name.clone(),
        hir::SigKind::GenericInst { name, args } => {
            let args = args
                .iter()
                .map(format_builtin_kind)
                .collect::<Vec<_>>()
                .join(", ");
            format!("{name}<{args}>")
        }
        hir::SigKind::Generic(name) => name.clone(),
    }
}

fn source_definition_location(
    document: &Document,
    definition: &Definition,
) -> GotoDefinitionResponse {
    GotoDefinitionResponse::Scalar(Location::new(
        document.uri().clone(),
        document.name_range(definition.span, &definition.name),
    ))
}

fn builtin_location(name: &str) -> Option<Location> {
    let builtin_name = name.strip_prefix('@')?;
    builtins::get_spec(builtin_name)?;
    let uri = Url::parse(&format!("{BUILTIN_SCHEME}:/{builtin_name}.af")).ok()?;
    Some(Location::new(
        uri,
        types::Range::new(
            types::Position::new(0, 0),
            types::Position::new(0, name.encode_utf16().count() as u32),
        ),
    ))
}

fn builtin_source_for_uri(uri: &str) -> Option<String> {
    let uri = Url::parse(uri).ok()?;
    if uri.scheme() != BUILTIN_SCHEME || uri.query().is_some() || uri.fragment().is_some() {
        return None;
    }
    let name = uri.path().strip_prefix('/')?.strip_suffix(".af")?;
    if name.is_empty() || name.contains('/') {
        return None;
    }
    match builtins::get_spec(name)? {
        BuiltinSpec::Function(signature) => Some(format!(
            "@{name}: {} {{\n    // internal\n}}\n",
            format_builtin_signature(&signature)
        )),
        BuiltinSpec::Type(kind) => Some(format!(
            "@{name}: {}\n\n// internal compiler type\n",
            format_builtin_kind(&kind)
        )),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn snapshot(documents: &[(&str, &str)]) -> Snapshot {
        let documents = documents
            .iter()
            .map(|(uri, text)| {
                let uri = Url::parse(uri).expect("valid test URI");
                (
                    uri.clone(),
                    Arc::new(Document::new(uri, Some(1), (*text).to_string())),
                )
            })
            .collect();
        Snapshot {
            root: Some(PathBuf::from("/workspace")),
            documents,
        }
    }

    #[test]
    fn resolves_a_local_parameter() {
        let snapshot = snapshot(&[(
            "file:///workspace/main.af",
            "main: (name: @str) {\n    @write(name, ok: @exit(0))\n}\n",
        )]);
        let document = snapshot
            .document(&Url::parse("file:///workspace/main.af").expect("valid URI"))
            .expect("test document");
        let offset = document.text().find("name, ok").expect("name use");
        let (name, _, scope) = document
            .analysis()
            .reference_at(offset)
            .expect("name reference");
        let (_, definition) = snapshot
            .resolve(document, name, scope, offset)
            .expect("parameter definition");
        assert_eq!(definition.kind, DefinitionKind::Parameter);
    }

    #[test]
    fn reports_parser_errors_with_the_compiler_code() {
        let snapshot = snapshot(&[("file:///workspace/main.af", "main: {")]);
        let document = snapshot.documents.values().next().expect("test document");
        let diagnostics = diagnostics(document);
        assert_eq!(diagnostics.len(), 1);
        assert_eq!(
            diagnostics[0].code,
            Some(NumberOrString::String("parse".to_string()))
        );
    }

    #[test]
    fn resolves_members_of_imported_source_packages() {
        let snapshot = snapshot(&[
            (
                "file:///workspace/main.af",
                "fmt: /std/fmt\nmain: () { fmt.new(@exit) }\n",
            ),
            ("file:///workspace/std/fmt/new.af", "new: (ok: ()) { ok }\n"),
        ]);
        let document = snapshot
            .document(&Url::parse("file:///workspace/main.af").expect("valid URI"))
            .expect("main document");
        let offset = document.text().find("fmt.new").expect("member use");
        let (name, _, scope) = document
            .analysis()
            .reference_at(offset)
            .expect("member reference");
        let (target, definition) = snapshot
            .resolve(document, name, scope, offset)
            .expect("imported definition");
        assert_eq!(definition.name, "new");
        assert_eq!(target.uri().as_str(), "file:///workspace/std/fmt/new.af");
    }

    #[test]
    fn imported_packages_hide_private_source_declarations() {
        let snapshot = snapshot(&[
            (
                "file:///workspace/main.af",
                "fmt: /std/fmt\nmain: () { fmt.private(@exit) }\n",
            ),
            (
                "file:///workspace/std/fmt/_private.af",
                "private: (ok: ()) { ok }\n",
            ),
        ]);
        let document = snapshot
            .document(&Url::parse("file:///workspace/main.af").expect("valid URI"))
            .expect("main document");
        let offset = document.text().find("fmt.private").expect("member use");
        let (name, _, scope) = document
            .analysis()
            .reference_at(offset)
            .expect("member reference");
        assert!(snapshot.resolve(document, name, scope, offset).is_none());
    }

    #[test]
    fn exposes_builtin_hover_details() {
        let detail = builtin_detail("@exit").expect("known builtin");
        assert!(detail.starts_with("@exit: ("));
    }

    #[test]
    fn resolves_builtin_references_to_virtual_documents() {
        let snapshot = snapshot(&[(
            "file:///workspace/main.af",
            "main: () { @add(1, 2, @exit) }\n",
        )]);
        let uri = Url::parse("file:///workspace/main.af").expect("valid URI");
        let response = snapshot
            .definition(GotoDefinitionParams {
                text_document_position_params: types::TextDocumentPositionParams::new(
                    types::TextDocumentIdentifier::new(uri),
                    types::Position::new(0, 11),
                ),
                work_done_progress_params: Default::default(),
                partial_result_params: Default::default(),
            })
            .expect("builtin definition");
        let GotoDefinitionResponse::Scalar(location) = response else {
            panic!("expected one builtin location");
        };
        assert_eq!(location.uri.as_str(), "afterflow-builtin:/add.af");
        assert_eq!(location.range.start, types::Position::new(0, 0));
        assert_eq!(location.range.end, types::Position::new(0, 4));
    }

    #[test]
    fn renders_builtin_virtual_documents_from_the_frontend_registry() {
        assert_eq!(
            builtin_source_for_uri("afterflow-builtin:/add.af").as_deref(),
            Some("@add: (x: @int, y: @int, ok:(@int)) {\n    // internal\n}\n")
        );
        assert!(builtin_source_for_uri("afterflow-builtin:/unknown.af").is_none());
        assert!(builtin_source_for_uri("file:///add.af").is_none());
    }

    #[test]
    fn serves_virtual_documents_from_object_request_params() {
        let server = Server::new(None);
        let response = server.request(Request {
            id: 1.into(),
            method: VIRTUAL_DOCUMENT_REQUEST.to_string(),
            params: to_value(HashMap::from([(
                "uri".to_string(),
                "afterflow-builtin:/write.af".to_string(),
            )]))
            .expect("serializable params"),
        });

        assert!(response.error.is_none());
        let content: Option<String> =
            from_value(response.result.expect("request result")).expect("string result");
        assert!(content.expect("known builtin").starts_with("@write: ("));
    }
}
