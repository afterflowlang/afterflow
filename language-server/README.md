# Afterflow language server

`afterflow-ls` is the editor-independent Language Server Protocol
implementation for Afterflow. It communicates over standard input and output.
An editor extension owns the process lifetime and associates `.af` documents
with the server.

## Run

Run a development build from the repository root:

```sh
cargo run -p afterflow-ls
```

Build the binary that an editor extension can launch:

```sh
cargo build -p afterflow-ls --release
```

The resulting executable is
`target/release/afterflow-ls`. It writes protocol messages to
standard output and reserves standard error for fatal startup or transport
errors. It accepts no command-line arguments yet.

The short binary name is intentional. Linux exposes process names through a
15-byte `comm` field; `afterflow-ls` remains recognizable there instead of
being truncated. The language server is part of the public `afterflow`
workspace so editor integrations do not depend on `afterflow-private`.

## Features

| LSP method | Behavior |
| --- | --- |
| `textDocument/publishDiagnostics` | Reports the compiler lexer's or parser's first error for an open, changed, saved, or closed document. |
| `textDocument/hover` | Shows Afterflow declarations, references, signatures, literals, imports, and builtin signatures. |
| `textDocument/definition` | Navigates within a file, across files in one source package, and through imports such as `fmt: /std/fmt` followed by `fmt.new`. |
| `textDocument/documentSymbol` | Lists top-level functions, signatures, constants, aliases, and source-package imports. |
| `textDocument/completion` | Suggests indexed declarations from the current document and top-level declarations from sibling files. |

The server uses full-document synchronization. Every edit creates a new document
overlay, so all supported features operate on unsaved content. LSP positions are
UTF-16 code-unit positions and correctly handle Unicode outside the Basic
Multilingual Plane and CRLF line endings.

Imported navigation follows compiler visibility rules. Declarations in
`_*.af` files remain visible within their own source package and are hidden from
importing packages.

## Workspace model

The first LSP workspace folder is the source-import root. The deprecated
`rootUri` initialization field is accepted as a fallback for older clients. For
example, `/std/fmt` maps to `<workspace>/std/fmt`. Open the folder that actually
contains imported paths. Opening a narrower folder limits cross-package
navigation. Without a workspace folder or `rootUri`, the server indexes only
documents opened by the client and cannot discover sibling or imported files.

At initialization, the server recursively indexes `.af` files under that root.
It skips `.git`, `backup`, and `target` folders. Editor documents then move
through this lifecycle:

```text
workspace file on disk
    didOpen
        unsaved editor overlay
            didChange
                replacement overlay and immutable snapshot
            didSave
                saved overlay remains current
    didClose
        reload file from disk or remove a deleted file
```

The server does not watch for filesystem changes made outside the editor. A file
changed by another process is refreshed when the editor opens or closes it. The
initial implementation uses only the first workspace folder and does not yet
provide multi-root workspace isolation.

## VS Code client contract

A VS Code extension should:

1. Register an `afterflow` language for files matching `**/*.af`.
2. Start `afterflow-ls` with no arguments and use standard input
   and output as the transport.
3. Set the document selector to `{ scheme: "file", language: "afterflow" }`.
4. Pass the opened project folder as an LSP workspace folder.
5. Let the language client perform the standard `initialize`, `initialized`,
   `shutdown`, and `exit` lifecycle.

After the protocol loop returns, the server must drop its connection before
joining the standard-I/O worker threads. Keeping the connection alive retains
channel senders and can make shutdown wait forever, forcing an editor to kill
the process. `tests/lifecycle.rs` exercises the complete protocol lifecycle and
guards this ordering.

The server advertises full text synchronization, UTF-16 positions, hover,
completion, definition, and document-symbol capabilities during initialization.
The extension should discover capabilities from that response instead of
duplicating a feature list.

## Architecture

The design follows the useful state boundaries in the
[gopls implementation](https://github.com/golang/tools/blob/master/gopls/doc/design/implementation.md)
at a smaller scale:

```text
stdio JSON-RPC
    server request handlers
        session
            immutable snapshot after each edit
                document overlay or disk content
                    shared Afterflow frontend and source index
```

The generic protocol transport is isolated in `kit/lsp`. The server depends on
the shared `afterflow-frontend` crate instead of either compiler backend.
Parsing and indexing do not depend on JSON-RPC, which keeps feature tests fast.
Each edit replaces the current immutable snapshot. Disk-backed documents and
unsaved overlays use the same `Document` representation.

The implementation is split by responsibility:

- `src/server.rs` owns protocol initialization, request dispatch, sessions,
  snapshots, workspace loading, and LSP result conversion.
- `src/document.rs` owns text, compiler analysis, byte offsets, and UTF-16
  position mapping.
- `src/analysis.rs` indexes shared frontend AST declarations, references, and lexical
  scopes without depending on LSP types.
- `kit/lsp` contains the reusable synchronous JSON-RPC transport and protocol
  types. It contains no Afterflow behavior.

## Current boundaries

Diagnostics currently report lexer and parser errors. Whole-project type,
resolution, and staged-execution diagnostics require a compiler analysis API
that accepts editor overlays instead of reading every source from disk. The
snapshot boundary can accept that API without changing the protocol layer or a
future VS Code client.

Completion is declaration-based and does not yet filter every result by the
precise lexical scope at the cursor. The server also does not yet implement
formatting, references, rename, signature help, semantic tokens, code actions,
workspace symbols, configuration, cancellation, or persistent caches.

## Development

Run the language-server tests while iterating:

```sh
cargo test -p afterflow-ls
```

Before submitting changes, run the repository checks:

```sh
cargo fmt --all
cargo test
make lint
```

The tests cover parser-error preservation, local parameter resolution,
cross-package definition lookup, private package declarations, builtin hover,
qualified-name ranges, UTF-16 mapping, Unicode surrogate pairs, and CRLF line
boundaries.
