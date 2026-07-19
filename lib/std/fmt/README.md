# fmt

`fmt` is Afterflow's typed, I/O-free DSL for building formatted strings. It owns the
format source, its typed argument chain, validation of that combination, and
production of the resulting `@str`.

The package has one canonical entrypoint: `fmt.new`. Its signature marks the
template, invalid continuation, and argument chain for compile-time
consumption, while its final unmarked `@str` continuation receives the runtime
result.

## Usage

`fmt.new(...)` validates the known format source and argument-chain structure
during compilation. There is no call-level bang. Its final continuation is
unmarked, so payload conversion and string construction remain runtime work.

```af
fmt: /std/fmt

main: () {
    fmt.new(
        "hello %, count %, price %\n",
        @compile_error("invalid format", @exit(1)),
        fmt.str("Alice")
        fmt.int(3)
        fmt.f64(12.5)
        fmt.end,
        @write(ok: @exit(0))
    )
}
```

`fmt.end` is the format-chain alias for `std.end`.

This writes `hello Alice, count 3, price 12.5`. The write is performed by the
continuation provided by the caller; `fmt` itself only produces the string.

The format source has type `@str!` because validation inspects it before the
runtime continuation. Passing an ordinary runtime string fails type checking,
even when some callers happen to pass literals through that parameter.

Prefer right-associated indentation for the argument chain:

```af
fmt: /std/fmt

main: () {
    fmt.new(
        "hello %, count %\n",
        @exit(1),
        fmt.str("Alice")
        fmt.int(3)
        fmt.end,
        @write(ok: @exit(0))
    )
}
```

Apply only the format source and invalid continuation to reuse a builder:

```af
fmt: /std/fmt

invalid: () {
    @exit(1)
}

greeting: fmt.new("hello %, count %", invalid)

build_greeting: (name: @str, count: @int, ok: (@str)) {
    greeting(
        fmt.str(name)
        fmt.int(count)
        fmt.end,
        ok
    )
}
```

## Public contract

- `new` validates a format source and recursive argument chain, materializes
  the runtime result, then gives the resulting `@str` to its continuation.
- `str` supplies an `@str` argument.
- `int` supplies an `@int` argument.
- `f64` supplies an `@f64` argument using its shortest round-trippable decimal
  form.
- `end` closes the recursive argument chain.

A single `%` consumes one argument and `%%` produces a literal percent sign.
A missing or extra argument, a trailing `%`, allocation failure, or invalid
UTF-8 enters the invalid continuation.

`fmt.new(...)` consumes the known format source and argument-chain structure
during compilation. `fmt.str`, `fmt.int`, and `fmt.f64` leave their payload
slots unmarked because validation inspects only each node's type and chain
shape. Each node contributes a deferred runtime source, so the emitted program
does not parse placeholders or validate the chain again. Payload conversion
and string construction remain residual runtime work leading into the unmarked
result continuation.

## Boundary

`fmt` produces strings. It does not perform I/O. Printing belongs in APIs such
as `std.print` and `std.println`. Writers, files, terminals, logging, scanning,
and input parsing do not belong in this package.

General string operations and conversions also remain outside `fmt`. An
argument adapter belongs here only when it contributes a generally useful
value kind to the formatting chain. It must not expose parsing, allocation, or
rendering machinery as public API.

Implementation declarations, including planners, deferred value sources,
renderers, internal argument cases, and byte-building helpers, belong in
`_*.af` files. Only the builder entrypoint and its public argument-chain
vocabulary should be accessible through the package namespace.
