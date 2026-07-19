# calc

`calc` is Afterflow's typed, I/O-free DSL for scientific calculations. It owns the
calculation source, its named placeholder chain, validation of that
combination, and production of the resulting `@f64`.

## Usage

`calc.new(...)` parses and validates known source and placeholder names during
compilation, then evaluates the prepared calculation at runtime and gives its
result to the final unmarked continuation. There is no call-level bang.

```af
calc: /std/math/calc

calculate: (price: @f64, tax: @f64, ok: (@f64)) {
    (result: @f64) = calc.new(
        "(price + 2.5) * tax",
        calc.var("price", price)
        calc.var("tax", tax)
        calc.end
    )
    ok(result)
}
```

`calc.end` is the calculation-chain alias for `std.end`.

The source has type `@str!`, and each `calc.var` placeholder name has type
`@str!`, because parsing and validation inspect them before the runtime
continuation. Numeric values remain ordinary `@f64` payloads. Use ordinary Afterflow
functions instead of the textual DSL when the operation or placeholder names
are selected only at runtime.

```af
calculate: (value: @f64, ok: (@f64)) {
    @add_f64(value, 2.5, ok)
}
```

## Public contract

- `new` validates source and a recursive placeholder-binding chain, evaluates
  the prepared calculation at runtime, then gives its `@f64` result to `ok`.
  It reports invalid source or bindings during compilation without requiring
  an error continuation.
- `var` binds a compile-time lowercase placeholder name to a runtime `@f64`
  payload.
- `end` closes the recursive binding chain.

The grammar contains decimal literals, scientific notation, lowercase
placeholder names, constants, functions, binary `+`, `-`, `*`, `/`, and `^`,
unary `+` and `-`, ASCII whitespace, and grouping with `(` and `)`.
Multiplication is always explicit. `subtotal` is one placeholder, while
`sub*total` is multiplication of two placeholders.

## Scientific language

Decimal literals require a digit on both sides of the decimal point, so `0.5`
is valid while `.5` and `1.` are not. An `e` or `E` suffix accepts an optional
sign and at least one exponent digit, as in `1.25e3` or `5E-2`.

Precedence from lowest to highest is:

1. left-associative `+` and `-`;
2. left-associative `*` and `/`;
3. unary `+` and `-`, and
4. right-associative `^`.

Exponentiation binds through unary signs in the conventional calculator form:
`-2^2` is `-(2^2)`, `2^-2` is valid, and `2^3^2` is `2^(3^2)`. The function
form `pow(a, b)` has the same numeric behavior as `a ^ b`.

| Kind | Names |
| --- | --- |
| Constants | `e`, `pi`, `tau` |
| Roots | `sqrt`, `cbrt` |
| Trigonometric | `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2` |
| Hyperbolic | `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh` |
| Exponential | `exp`, `exp2`, `expm1` |
| Logarithmic | `ln`, `ln1p`, `log`, `log2`, `log10` |
| Rounding | `ceil`, `floor`, `round`, `trunc` |
| Floating utilities | `abs`, `hypot`, `min`, `max`, `mod`, `remainder` |
| Angle conversion | `deg`, `rad` |

All functions take one argument except `atan2`, `hypot`, `min`, `max`, `mod`,
`pow`, and `remainder`, which take two. `log(value)` is base 10, while
`log(value, base)` accepts an explicit base. Trigonometric functions consume
radians; `rad` converts degrees to radians and `deg` converts radians to
degrees.

Placeholder names contain one or more lowercase ASCII letters. Constants and
function names are reserved, as is `i` for possible future complex-number
support. Every placeholder used by the source must have exactly one binding,
and every binding must be used by the source. Missing, duplicate, extra, or
malformed bindings report `invalid calculation` during compilation. Reserved
bindings report whether the name conflicts with a calculation constant or
function, or with future syntax.

Bindings are matched by their complete names rather than their chain position.
They may appear in any order, and one binding supplies every occurrence of its
placeholder in the source.

Validation produces a `calculation` closure whose arithmetic leads into
`calc.new`'s unmarked result continuation. This boundary keeps arithmetic at
runtime even for a constant-only expression and does not depend on whether a
numeric builtin happens to have a compile-time implementation.

## Boundary

`calc` evaluates arithmetic source. It does not format results, perform I/O,
or manipulate symbolic expressions. Division follows binary64 behavior and
continues with infinity or NaN where appropriate rather than treating the
numeric result as a parser error.

Scientific operations use their numerical implementations from `/std/math`.
Symbolic simplification, differentiation, equation solving, units, and complex
numbers are separate domains. They do not belong in this `@f64` calculator.
