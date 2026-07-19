# std

`std` is Afterflow's small, conservative foundation of broadly useful operations.
Its public surface favors familiar names, unsurprising behavior, and functions
that remain useful across unrelated programs.

## Public contract

- `pipe` forwards a value to a continuation.
- `end` discards a value and enters a unit continuation.
- `print` writes an `@str` unchanged.
- `println` writes an `@str` followed by a newline.

Formatting is a domain-specific typed DSL and lives in [`/std/fmt`](fmt/README.md),
not in the root package.

Numerical operations live in [`/std/math`](math/README.md). Its unsuffixed
operations use `@int`, the language's default numeric type. Scientific source
evaluation lives in the focused [`/std/math/calc`](math/calc/README.md)
subpackage.

## Boundary

An operation belongs in `std` only when its purpose is generic, its name and
behavior are familiar from established languages, and concrete Afterflow programs
demonstrate that it removes recurring ceremony. Domain types, protocol
adapters, parsers, builders, and specialized conversions belong in focused
subpackages.

The package is intentionally not a collection point for every reusable helper.
Private implementation details belong in `_*.af` files, and a public addition
must be strong enough to support as a compatibility commitment.
