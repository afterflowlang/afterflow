# Afterflow frontend

`afterflow-frontend` owns the language-wide source boundary shared by compiler
implementations and editor tooling. It contains source loading, lexing, parsing, AST
and HIR types, HIR construction and formatting, builtin signatures, spans, and
structured diagnostics.

Backend lowering, compile-time execution strategy, memory management, AIR, and
code generation remain compiler-specific.
