# math

`math` is Afterflow's standard package for numerical operations. Operations whose
numeric type is otherwise ambiguous use `@int`, the language's default numeric
type. Functions with an established real-number domain use `@f64`.

## Usage

```af
math: /std/math

main: () {
    (smaller: @int) = math.min(3, 7)
    (power: @f64) = math.pow(2.0, 8.0)
    (logarithm: @f64) = math.log(25.0, 5.0)
    (hypotenuse: @f64) = math.hypot(3.0, 4.0)
    (wave: @f64) = math.sin(1.0)
    @exit(0)
}
```

## Public contract

| Family | Functions |
| --- | --- |
| Integer bounds | `min`, `max` |
| Trigonometric | `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2` |
| Hyperbolic | `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh` |
| Powers and roots | `pow`, `sqrt`, `cbrt`, `hypot`, `ldexp` |
| Exponential | `exp`, `exp2`, `exp_m1` |
| Logarithmic | `ln`, arbitrary-base `log`, `log2`, `log10`, `ln_1p` |
| Rounding | `ceil`, `floor`, `round`, `trunc` |
| Floating utilities | `abs`, `copy_sign`, `dim`, `min_f64`, `max_f64`, `mod`, `remainder`, `next_after` |
| Angle conversion | `to_degrees`, `to_radians` |

Floating functions follow binary64/libm domain behavior. They continue with
NaN or infinity for values outside the finite real domain rather than entering
a separate error continuation. `round` uses libm's halfway-away-from-zero rule,
`mod` uses a truncated quotient, and `remainder` uses the IEEE nearest-integer
quotient rule.

`ln(value)` directly wraps the backing natural logarithm. `log(value, base)` is
the ergonomic Afterflow composition `ln(value) / ln(base)`. `ldexp` retains an
`@i32` exponent because that is the backing function's actual type.

The scientific calculator DSL is a separate subpackage at
[`/std/math/calc`](calc/README.md). Import it directly when mathematical source
text and named placeholder bindings should produce an `@f64`.

## Boundary

`math` contains general-purpose numerical operations. Formatting, parsing,
units, statistics, random-number generation, and domain-specific numerical
algorithms belong in focused packages. The calculator parser therefore lives
in the focused `/std/math/calc` subpackage rather than this package.

Unsuffixed arithmetic names use `@int`. Conventional real-number functions use
`@f64` without a type suffix. `min_f64` and `max_f64` remain explicit because
the unsuffixed names already have an `@int` contract. Private implementation
details belong in `_*.af` files.
