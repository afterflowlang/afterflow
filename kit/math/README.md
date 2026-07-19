# freestanding-math

`freestanding-math` provides numerical routines for Afterflow binaries without a C
runtime or dynamic library dependency. It is a `no_std` static archive backed
by Rust's `libm` crate.

The archive contains callable functions only. It does not provide an entry
point, initialization arrays, or code that runs before Afterflow's `_start`.

Each exported symbol is a direct typed adapter to one backing function. Unary
and binary `f64` functions retain the backing name after the
`freestanding_math_` prefix, such as `freestanding_math_log(double)` and
`freestanding_math_atan2(double, double)`. The mixed-width
`freestanding_math_ldexp(double, int32_t)` keeps its `i32` exponent.

The archive does not contain ergonomic operations absent from the backing
surface. Arbitrary-base logarithm and angle conversion are composed in Afterflow's
`/std/math` package.

Build it from the workspace root with:

```sh
cargo build -p freestanding-math --release
```
