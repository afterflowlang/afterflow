# Afterflow Semantics

This document describes what Afterflow programs mean: which programs are valid,
what source constructs do, and what behavior users can rely on.

## Core Model

Afterflow is an identifier-driven, definition-oriented, declaration-before-use,
single-assignment, expression-less, continuation-passing language.

Programs are built from two fundamental actions:

- defining identifiers for values
- transferring control to identifiers that interpret those definitions

There are no expression returns. Computation is a sequence of definitions
followed by a control transfer to another executable value.

At the file root, Afterflow accepts definitions. Root-level execution is not valid
source. The compiler appends an invocation of the requested target function
after parsing.

Source-file flow:

- read definitions in order
  - every referenced name and type must already be declared
- choose a compile target by name
  - append an invocation of that target
  - require the target invocation to be complete
- execute by tail-transferring between executable values

Blocks are non-empty. `;` and newlines separate block items. Newlines between
adjacent executable phrases form one right-associated continuation sentence.
When another kind of block item interrupts that sentence, the preceding
execution captures the remaining block as a unit continuation.

## Lexical Rules

Identifiers start with an ASCII letter or `_`, followed by ASCII letters,
digits, or `_`.

Line comments start with `//` and continue to the end of the line. Block
comments start with `/*` and continue until the next `*/`. They may span
lines and are treated as whitespace. Block comments are not nested.

String literals have two forms:

- double-quoted strings process escapes such as `\n`, `\t`, `\\`, `\"`,
  `\0`, and `\u{...}`
- single-quoted strings keep backslashes as ordinary characters

Integer literals are signed machine-sized integer values. Floating literals
exist and have type `f64`.

## Definitions

A definition introduces a name for a value inside the current scope:

```af
name: "Bob"
foo: (ok:()){
    @write(name, ok)
}
```

Definition forms:

- `name: literal`
  - defines a literal value. String and integer literal aliases have
    compile-time types `str!` and `int!`
- `name: other`
  - aliases an existing identifier
- `name: other(arguments)`
  - defines a curried executable value
- `name: (parameters)`
  - defines a signature alias
- `name: <T>(parameters)`
  - defines a generic signature alias
- `name: (parameters){ body }`
  - defines a function
- `name: <T>(parameters){ body }`
  - defines a generic function

Function and lambda parameters must have explicit types. Signature aliases may
use unnamed type slots such as `(str)` because they describe shape rather than
binding local parameter names.

Generic parameter lists must contain at least one name and cannot repeat a
name.

Redefining the same label in the same scope is invalid:

```af
x: 1
x: 2
```

Nested scopes may shadow outer labels:

```af
x: 1
(){
    x: 2
}()
```

Type aliases obey the same declaration-before-use rule as values. Builtins are
referenced directly with `@name`. Keyword-like types are normally given short
aliases such as `int: @int`, while functions normally retain their direct
names, such as `@write(...)`.

## Invocation and Currying

Application syntax does not imply a C-style call. The same surface form is
interpreted by position.

Application flow:

- parse an application form, such as `foo(x)`
  - if it appears as a definition value or as an argument
    - bind the supplied arguments
    - produce an executable value
    - do not transfer control yet
  - if it is the outermost application of an executable block continuation
    sentence
    - bind the supplied arguments
    - transfer control to the executable value
    - do not return to the current block

When application appears on the right-hand side of a definition or as an
argument, it applies arguments to an executable value without running it. The
result is another executable value that can be run later:

```af
end: exit(0)
foo(end)
```

In `end: exit(0)`, `exit(0)` is a curried executable value. It does not execute
at definition time.

A bare executable identifier in a value position already denotes its full
unapplied executable value. It satisfies a matching function type directly;
an empty or dummy application is not required to turn it into a value.

The outermost application of an executable block continuation sentence
transfers control to that executable value and does not return to the current
location:

```af
foo(end)
```

Outermost identifiers and lambdas are invocations even when they have no
explicit argument list:

```af
mywrite: @write("hello", (){})
mywrite
```

The final `mywrite` invokes the executable value and writes `hello`.

Likewise, a lambda block item executes:

```af
(){
    @write("hello", (){})
}
```

The outermost invocation must supply enough arguments to run. A partial
application can be stored, passed, or used as an inner phrase of a continuation
sentence, but it cannot be the outermost action by itself.

Literal values cannot be standalone invocations.

Chained application supplies more arguments to the same executable value:

```af
foo(a)(b)
```

is equivalent to currying `foo` with `a`, then currying that result with `b`.

Inside a definition value, one argument of an application, or an executable
block continuation sentence, whitespace between adjacent values applies to the
right:

```af
chain: a b c
foo(a b c)
```

Both value positions mean `a(b(c))`. Parentheses still supply the immediate
arguments of one phrase, so:

```af
chain: a(x) b(y) c(z)
```

means:

```af
chain: a(x, b(y, c(z)))
```

A definition's continuation sentence may span lines when its following phrases
are indented beyond its label:

```af
chain:
    a(x)
    b(y)
    c(z)
```

### Compile-time execution

Compile-time execution is declared by parameter slots. A `!` after a parameter
type means that the argument is consumed by the compile-time interpreter:

```af
build: (value: @int!, run: (@int)) {
    @add(value, 1, run)
}

main: () {
    build(2, @exit)
}
```

There is no call-level bang. When an executable target is rooted in a function
with at least one marked parameter, the compiler interprets that transfer. A
partial application retains the staging property of its root function:

```af
q: build(2)
q(@exit)
```

Marked callable parameters are also consumed. This makes recursive DSL values
such as `args: arg!` traversable during compilation even when their known
constructor closures retain opaque runtime payloads.

Unmarked data parameters are unavailable to the interpreter, even when a call
happens to supply a literal. A staged function must mark every input that it
inspects before reaching a runtime continuation. This makes the signature the
binding-time contract instead of letting call-site constants silently change
the function's behavior.

Unmarked callable parameters of a function with marked parameters define its
runtime boundaries. The interpreter follows validation and other pure work,
then residualizes the transfer leading into such a continuation:

```af
new: (
    source: @str!,
    invalid: ()!,
    args: arg!,
    ok: (@f64)
) {
    (value: calculation) = calculate(source, args, invalid)
    value(ok)
}
```

Compile-time execution flow:

```text
execute a target rooted in a signature with `!` parameters
    bind inputs according to the signature
        keep marked values available to the interpreter
        keep unmarked data opaque even when supplied as literals
        make unmarked callables runtime boundaries
        interpret user functions and supported pure builtins
            call another marked function
                establish that function's unmarked continuation boundaries
            reach a runtime effect leading into a boundary
                retain symbolic runtime payloads in the residual closure
                    emit ordinary HIR for AIR and assembly
```

A staged execution must be the terminal execution in its HIR block, and one
block may contain only one staged execution. The evaluator has a bounded step
budget. Exhausting it, completing without a terminal transfer, or reaching
runtime-dependent data that staged code must inspect is an error. Effectful
builtins are residualized when their continuation path contains a boundary;
without such a boundary they are not compiler-host effects and are rejected.

Marked arguments propagate through marked helper calls. The helper body is
interpreted from the concrete staged call rather than being evaluated once in
isolation with symbolic marked parameters. Compile-time-derived values remain
known when HIR threads them through generated capture parameters.

`@compile_error(message, runtime_fallback)` is the corresponding dual-mode
failure operation. When reached by staged validation it stops compilation with
`message` at the staged call's source span. It does not initiate staging by
itself. During ordinary runtime execution it invokes `runtime_fallback`.

## Block Continuation Sentences

Newlines and spaces have the same right-associative application meaning between
adjacent executable phrases. Only the outermost phrase transfers control. Every
phrase nested inside it is a curried value.

```text
after an executable phrase
    next item is another executable phrase
        right-fold it directly as a continuation value
    next item is a definition or other block structure
        capture the remaining block as a unit continuation
    no next item
        transfer through the executable as written
```

For example:

```af
foo: (){
    bar(x)
    baz(y)
    exit(0)
}
```

means:

```af
foo: (){
    bar(x, baz(y, exit(0)))
}
```

The unit continuation is not special. A right-hand phrase may instead remain
partially applied with the payload shape expected by the phrase on its left:

```af
int: @int
str: @str

produce: (value: int, ok: (int)){
    ok(value)
}

consume: (prefix: str, value: int){
    @write(prefix, @exit(value))
}

main: (){
    produce(42)
    consume("value")
}
```

The body of `main` means `produce(42, consume("value"))`.
`consume("value")` has the residual signature `(int)`, so it matches
`produce`'s `ok` parameter. When `produce` invokes `ok(42)`, control transfers
to `consume("value", 42)`. The compiler does not introduce a result variable or
a separate feed operation.

A definition cannot itself be passed as a continuation value. When it follows
a bare execution, the entire remaining block is therefore captured as `()`:

```af
main: (){
    foo
    value: something
    bar(value)
}
```

means:

```af
main: (){
    foo((){
        value: something
        bar(value)
    })
}
```

The implicit unit capture extends through the end of the current block. The
definition and final invocation remain inside that continuation's scope.

This is the unnamed, eta-reduced form of explicit scope capture:

```af
main: (){
    (result: int) = produce(42)
    consume("value", result)
}
```

Explicit scope capture remains necessary when the received values need names,
must be used more than once, or feed a continuation that cannot be represented
by the residual signature of one applied value. An implicit capture always has
the unit signature `()`. Use explicit scope capture when the preceding execution
passes payload values into the remaining block.

Right-associative application does not invent a terminal continuation. The
complete outer invocation must still transfer to a continuation supplied by the
source when the flow does not end in the invoked function.

## Argument Matching

Arguments are matched by position unless named arguments are used.

Argument matching flow:

- inspect the invocation target signature
  - if all arguments are positional
    - bind them from left to right
  - if any argument is named
    - bind positional arguments to the first still-unassigned parameters
    - bind named arguments to parameters with the same names
    - reject duplicate or unknown argument names
  - reject too many arguments
  - type-check every argument against its matched parameter

Parameter names matter for named application. Function signature compatibility
is otherwise structural: two function-typed values match by parameter shape and
types, not by parameter names.

Builtins can be passed where a function-typed value is expected. The compiler
treats the builtin as a function value that forwards its parameters to the
builtin operation.

## Scope Capture

Scope capture rewrites the rest of the block into a continuation and passes it
to the captured operation.

Scope-capture flow:

- encounter `(name: type) = operation(arguments)`
  - require `operation` to be an executable value that accepts the appended continuation
  - turn the rest of the current block into a continuation
    - the continuation receives `name: type`
    - the continuation body is the original remaining block
  - append that continuation to `operation(arguments)`
  - transfer control to `operation`

For example:

```af
int: @int

hello: (){
    (sum: int) = @add(2, 3)
    @exit(sum)
}
```

This behaves like nested continuations, but keeps source code flat. Each
capture introduces the named value into the remaining block.

Nested functions may reference values from enclosing scopes. Those references
are captured into the nested function value. Root-level functions are ordinary
declared functions and are not captured from other root-level functions.

## Types

Builtin type names can be aliased into local type labels:

```af
int: @int
str: @str
byte: @byte
f64: @f64

foo: (x: int, text: str, ratio: f64){
}
```

The primitive type rules are:

- `str` must be a string.
- `str!` must be a compile-time available string. The argument must be a string
  literal or another `str!` value.
- `int` must be an integer.
- `int!` must be a compile-time available integer. The argument must be an
  integer literal or another `int!` value.
- `uint` must be a non-negative integer in the machine-preferred unsigned
  integer layout for the target architecture.
- `uint!` must be a compile-time available non-negative integer. The argument
  must be an integer literal or another compile-time integer value.
- `rune` must be a Unicode scalar value: U+0000 through U+D7FF or U+E000
  through U+10FFFF. UTF-16 surrogate code points and larger values are not
  runes.
- `rune!` must be a compile-time available rune. Integer literals supplied
  where `rune` or `rune!` is required are checked against the Unicode scalar
  ranges during compilation.
- `byte` must be a compile-time available integer from `0` through `255`.
  Integer literals supplied where `byte` is required are checked against this
  range.
- `f64` must be a floating-point value. An integer literal may satisfy an
  `f64` parameter because it is compile-time available.

The availability bang belongs to the parameter slot, not to the value's
runtime meaning. Only a compile-time-available string satisfies a `str!` slot.
This marker does not start staged execution. Only a value-level executable
application such as `foo!(...)` does that.

`str` and `bytes` are distinct value types. `bytes` permits any byte sequence,
while every `str` promises valid UTF-8. String literals and Unicode escapes are
validated by the UTF-8 source lexer. `@str_from_utf8` checks a `bytes` value and
enters `invalid` for malformed, overlong, surrogate, truncated, or out-of-range
encodings.

Executing a string with one receiver exposes this shape:

```af
str_view: (l: uint, nth: (idx: uint, empty: (), one: (rune)))

inspect: (value: str) {
    value((l: uint, nth: (idx: uint, empty: (), one: (rune))) {
        // l and idx count Unicode scalar values, not UTF-8 bytes.
    })
}
```

`l` is the number of runes. `nth` enters `empty` when `idx` is outside that
range and otherwise enters `one` with a validated rune. The compiler currently
lowers this behavior through `@str_rune_len` and `@str_rune_nth`.

`bytes` uses the same executable-value boundary without promising UTF-8. Its
inspection receiver exposes its byte length and a byte-indexed oracle:

```af
bytes_view: (l: uint, nth: (idx: uint, empty: (), one: (u8)))
```

`l` is the byte length. `nth` enters `empty` when `idx >= l` and otherwise
enters `one` with the byte at that index. Direct execution, right-associated
execution, and execution through a label all preserve this behavior.

`@bytes_from_str(value, ok)` losslessly exposes valid UTF-8 text as bytes and
cannot fail. `@bytes_build(source, invalid, ok)` executes the source once to
obtain its byte length and `nth`, requests every index from zero through
`l - 1`, and enters `invalid` if construction cannot complete or an in-range
request enters `empty`. A zero length produces a valid empty `bytes` value.

Afterflow operations such as `@write` preserve embedded `\0` bytes. The source-level
formatter treats embedded NUL bytes as ordinary string content.

A `rune` has a one-word, `u32`-compatible runtime representation, but it is a
distinct static type. Typed source can construct one only from a validated
literal or `@rune_from_u32`; `@u32_from_rune` is therefore lossless.
Rune literals use integer spelling in a rune-expected position. compile-direct has no
separate character-literal syntax. A `rune!` parameter accepts such a literal
or another compile-time rune, while an ordinary runtime rune does not satisfy
the compile-time requirement.

Function types are written with parameter lists:

```af
receiver: (value: str)
predicate: (ok: (), err: ())
mapper: (value: str, ok: (str))
```

Data and control are encoded with functions and signatures rather than
reserved categories. A value that can be either an integer or a string can be
represented by a function that accepts one continuation for each case:

```af
int: @int
str: @str

int_or_str: (i: (int), s: (str))

as_int: (x: int, ok: (int), (str)){
    ok(x)
}

as_str: (x: str, (int), ok: (str)){
    ok(x)
}
```

A control form can be represented the same way:

```af
bool: (yes: (), no: ())

true: (yes: (), no: ()){
    yes()
}

false: (yes: (), no: ()){
    no()
}

choose: (cond: bool, yes: (), no: ()){
    cond(yes, no)
}
```

Signature aliases name reusable function types:

```af
receiver: (str)
pair: <T>(left: T, right: T)
```

Generic type parameters are placeholders inside a signature or generic
function. Repeated uses of the same generic parameter must resolve to the same
actual type for a given invocation.

Generic matching flow:

- enter a generic function or signature alias
  - register each generic parameter name once
- match actual arguments against expected parameters
  - when a generic parameter is first seen
    - bind it to the actual type
  - when the same generic parameter is seen again
    - require the actual type to match the earlier binding
- substitute the bound types through the remaining signature

Every parameter declares exactly one typed argument slot. Afterflow has no variadic
parameter or argument-pack syntax. Variable-length domain data is represented
with ordinary recursive CPS values.

## Closure Values and Currying

A closure value is an executable value with captured and/or already supplied
arguments.

Currying a closure produces an executable value with more arguments supplied.
Each produced value preserves the arguments applied to it. Later currying of
the same source value cannot change the behavior of an earlier curry.

Memory management is not part of the shared language semantics. A compiler may
release nothing at all and rely on process teardown, use tracing garbage
collection, reference counting, arenas, affine ownership, or any other
strategy. The semantics do not specify allocation, aliasing, cloning, release
timing, or whether unreachable storage is ever released. Compiler-specific
representation and lifetime strategies belong in that compiler's
specification.

## Builtins and Imports

Compiler-provided builtins are addressed directly with `@name`. They are the
types and operations that require backend support and are guaranteed by the
Afterflow language contract. Higher-level facilities belong in ordinary source
packages.

`@name` is a compiler-owned label space, not a namespace value or an import.
It is available wherever a label or type is valid and never occupies the user
label namespace unless code deliberately aliases it. The selected test entry
has the additional override form described under Test Sources below.

```af
int: @int
write: @write
```

Builtin names are flat and must match a builtin known by the compiler.
`@anything` never selects or renames a package. An unknown name is an error.
Builtin references contain exactly one name, so `@io.write` is invalid.

The builtin name must match a builtin known by the compiler. Current builtin
entries are:

```text
@str // owner: backend/runtime; valid UTF-8 string value
@bytes // owner: backend/runtime; arbitrary byte-sequence value
@int // owner: backend/ABI; machine preferred integer layout for the target architecture
@uint // owner: backend/ABI; machine preferred unsigned integer layout for the target architecture
@rune // owner: backend/ABI; validated Unicode scalar with a u32-compatible runtime representation
@byte // owner: backend/ABI; unsigned byte value constrained to the range 0 through 255
@f64 // owner: CPU/backend/ABI; floating-point layout and register passing
@b8 // owner: backend/ABI; uninterpreted 8-bit value
@i8 // owner: backend/ABI; signed 8-bit integer
@u8 // owner: backend/ABI; unsigned 8-bit integer
@b32 // owner: backend/ABI; uninterpreted 32-bit value
@i32 // owner: backend/ABI; signed 32-bit integer
@u32 // owner: backend/ABI; unsigned 32-bit integer
@b64 // owner: backend/ABI; uninterpreted 64-bit value
@i64 // owner: backend/ABI; signed 64-bit integer
@u64 // owner: backend/ABI; unsigned 64-bit integer
@b128 // owner: backend/ABI; uninterpreted 128-bit value
@i128 // owner: backend/ABI; signed 128-bit integer
@u128 // owner: backend/ABI; unsigned 128-bit integer
@rune_from_u32 // owner: backend; validates a u32 as a Unicode scalar and selects invalid or ok
@u32_from_rune // owner: backend/ABI; lossless representation conversion from a validated rune
@str_rune_len // owner: backend/runtime; Unicode scalar count
@str_rune_nth // owner: backend/runtime; bounds-checked Unicode scalar access
@str_from_utf8 // owner: backend/runtime; checked bytes-to-str conversion
@bytes_nth // owner: backend/runtime; bounds-checked byte access
@bytes_from_str // owner: backend/runtime; lossless str-to-bytes conversion
@bytes_build // owner: backend/runtime; construction from an immutable byte oracle
@add // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@sub // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@mul // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@div // owner: CPU/backend; primitive checked integer division with error and success continuations
@add_uint // owner: CPU/backend; native unsigned addition with a uint result
@sub_uint // owner: CPU/backend; native unsigned subtraction with a uint result
@add_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@sub_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@mul_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@div_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@fabs_f64 // owner: freestanding math archive/backend; direct libm fabs binding
@acos_f64 // owner: freestanding math archive/backend; direct libm acos binding
@acosh_f64 // owner: freestanding math archive/backend; direct libm acosh binding
@asin_f64 // owner: freestanding math archive/backend; direct libm asin binding
@asinh_f64 // owner: freestanding math archive/backend; direct libm asinh binding
@atan_f64 // owner: freestanding math archive/backend; direct libm atan binding
@atan2_f64 // owner: freestanding math archive/backend; direct libm atan2 binding
@atanh_f64 // owner: freestanding math archive/backend; direct libm atanh binding
@cbrt_f64 // owner: freestanding math archive/backend; direct libm cbrt binding
@ceil_f64 // owner: freestanding math archive/backend; direct libm ceil binding
@copysign_f64 // owner: freestanding math archive/backend; direct libm copysign binding
@cos_f64 // owner: freestanding math archive/backend; direct libm cos binding
@cosh_f64 // owner: freestanding math archive/backend; direct libm cosh binding
@exp_f64 // owner: freestanding math archive/backend; direct libm exp binding
@exp2_f64 // owner: freestanding math archive/backend; direct libm exp2 binding
@expm1_f64 // owner: freestanding math archive/backend; direct libm expm1 binding
@fdim_f64 // owner: freestanding math archive/backend; direct libm fdim binding
@floor_f64 // owner: freestanding math archive/backend; direct libm floor binding
@fmax_f64 // owner: freestanding math archive/backend; direct libm fmax binding
@fmin_f64 // owner: freestanding math archive/backend; direct libm fmin binding
@fmod_f64 // owner: freestanding math archive/backend; direct libm fmod binding
@hypot_f64 // owner: freestanding math archive/backend; direct libm hypot binding
@ldexp_f64_i32 // owner: freestanding math archive/backend; direct libm ldexp binding
@log_f64 // owner: freestanding math archive/backend; direct unary libm log binding
@log10_f64 // owner: freestanding math archive/backend; direct libm log10 binding
@log1p_f64 // owner: freestanding math archive/backend; direct libm log1p binding
@log2_f64 // owner: freestanding math archive/backend; direct libm log2 binding
@nextafter_f64 // owner: freestanding math archive/backend; direct libm nextafter binding
@pow_f64 // owner: freestanding math archive/backend; direct libm pow binding
@remainder_f64 // owner: freestanding math archive/backend; direct libm remainder binding
@round_f64 // owner: freestanding math archive/backend; direct libm round binding
@sin_f64 // owner: freestanding math archive/backend; direct libm sin binding
@sinh_f64 // owner: freestanding math archive/backend; direct libm sinh binding
@sqrt_f64 // owner: freestanding math archive/backend; direct libm sqrt binding
@tan_f64 // owner: freestanding math archive/backend; direct libm tan binding
@tanh_f64 // owner: freestanding math archive/backend; direct libm tanh binding
@trunc_f64 // owner: freestanding math archive/backend; direct libm trunc binding
@add_b8 // owner: CPU/backend; primitive wrapping addition of 8-bit values
@add_b32 // owner: CPU/backend; primitive wrapping addition of 32-bit values
@add_b64 // owner: CPU/backend; primitive wrapping addition of 64-bit values
@add_b128 // owner: CPU/backend; primitive wrapping addition of 128-bit values
@sub_b8 // owner: CPU/backend; primitive wrapping subtraction of 8-bit values
@sub_b32 // owner: CPU/backend; primitive wrapping subtraction of 32-bit values
@sub_b64 // owner: CPU/backend; primitive wrapping subtraction of 64-bit values
@sub_b128 // owner: CPU/backend; primitive wrapping subtraction of 128-bit values
@mul_b8 // owner: CPU/backend; primitive wrapping multiplication of 8-bit values
@mul_b32 // owner: CPU/backend; primitive wrapping multiplication of 32-bit values
@mul_b64 // owner: CPU/backend; primitive wrapping multiplication of 64-bit values
@mul_b128 // owner: CPU/backend; primitive wrapping multiplication of 128-bit values
@div_signed_b8 // owner: CPU/backend; primitive signed division of 8-bit representations
@div_unsigned_b8 // owner: CPU/backend; primitive unsigned division of 8-bit representations
@div_signed_b32 // owner: CPU/backend; primitive signed division of 32-bit representations
@div_unsigned_b32 // owner: CPU/backend; primitive unsigned division of 32-bit representations
@div_signed_b64 // owner: CPU/backend; primitive signed division of 64-bit representations
@div_unsigned_b64 // owner: CPU/backend; primitive unsigned division of 64-bit representations
@div_signed_b128 // owner: CPU/backend; primitive signed division of 128-bit representations
@div_unsigned_b128 // owner: CPU/backend; primitive unsigned division of 128-bit representations
@b8_from_i8 // owner: backend/ABI; same-width representation conversion
@b8_from_u8 // owner: backend/ABI; same-width representation conversion
@i8_from_b8 // owner: backend/ABI; same-width representation conversion
@u8_from_b8 // owner: backend/ABI; same-width representation conversion
@b32_from_i32 // owner: backend/ABI; same-width representation conversion
@b32_from_u32 // owner: backend/ABI; same-width representation conversion
@i32_from_b32 // owner: backend/ABI; same-width representation conversion
@u32_from_b32 // owner: backend/ABI; same-width representation conversion
@b64_from_i64 // owner: backend/ABI; same-width representation conversion
@b64_from_u64 // owner: backend/ABI; same-width representation conversion
@i64_from_b64 // owner: backend/ABI; same-width representation conversion
@u64_from_b64 // owner: backend/ABI; same-width representation conversion
@b128_from_i128 // owner: backend/ABI; same-width representation conversion
@b128_from_u128 // owner: backend/ABI; same-width representation conversion
@i128_from_b128 // owner: backend/ABI; same-width representation conversion
@u128_from_b128 // owner: backend/ABI; same-width representation conversion
@eq_int // owner: CPU/backend; primitive integer equality branch emitted as direct control transfer
@eq_str // owner: backend/runtime; string equality over the runtime string representation
@eq_uint // owner: CPU/backend; native unsigned equality branch
@lt_uint // owner: CPU/backend; native unsigned ordering branch
@eq_b8 // owner: CPU/backend; sign-neutral equality over an 8-bit representation
@u8_from_int // owner: backend/ABI; checked narrowing from a native signed integer to u8
@lt // owner: CPU/backend; primitive integer comparison branch emitted as direct control transfer
@gt // owner: CPU/backend; primitive integer comparison branch emitted as direct control transfer
@write // owner: OS/filesystem descriptor API; byte-stream output operation
@file_read // owner: OS/filesystem API; whole-file read into raw runtime bytes with error and success continuations
@exit // owner: OS process ABI; process-completion operation
@compile_error // owner: compiler/backend; staged diagnostic with a runtime fallback
```

Builtin aliases occupy the user label namespace. A builtin can be aliased
under any available label:

```af
int: @int
sum: @add

foo: (x: int){
}
```

Unknown builtin forms such as `@puts` are invalid. `@int` is the direct builtin
type reference.

Builtin operation signatures:

- integer arithmetic: `add`, `sub`, `mul` take `x: int`, `y: int`, and
  `ok: (int)`
- native integer division: `div` takes `x: int`, `y: int`, `err: ()`, and
  `ok: (int)`
- floating arithmetic: `add_f64`, `sub_f64`, `mul_f64`, and `div_f64` take
  `x: f64`, `y: f64`, and `ok: (f64)`
- unary native math: `fabs_f64`, `acos_f64`, `acosh_f64`, `asin_f64`,
  `asinh_f64`, `atan_f64`, `atanh_f64`, `cbrt_f64`, `ceil_f64`, `cos_f64`,
  `cosh_f64`, `exp_f64`, `exp2_f64`, `expm1_f64`, `floor_f64`, `log_f64`,
  `log10_f64`, `log1p_f64`, `log2_f64`, `round_f64`, `sin_f64`, `sinh_f64`,
  `sqrt_f64`, `tan_f64`, `tanh_f64`, and `trunc_f64` exactly mirror backing
  `(f64) -> f64` functions before adding the CPS `ok: (f64)` parameter
- binary native math: `atan2_f64`, `copysign_f64`, `fdim_f64`, `fmax_f64`,
  `fmin_f64`, `fmod_f64`, `hypot_f64`, `nextafter_f64`, `pow_f64`, and
  `remainder_f64` exactly mirror backing `(f64, f64) -> f64` functions
- mixed-width native math: `ldexp_f64_i32` mirrors backing
  `(value: f64, exponent: i32) -> f64`. The name and Afterflow signature retain both
  input widths
- freestanding floating math follows binary64/libm domain behavior and passes
  NaN or infinity to `ok` rather than selecting an error continuation
- sign-neutral fixed-width arithmetic: `add_bW`, `sub_bW`, and `mul_bW` take
  two `bW` values and continue with their wrapping result
- sign-sensitive fixed-width division: `div_signed_bW` and
  `div_unsigned_bW` take two `bW` values, `err: ()`, and `ok: (bW)`. Their
  names specify how the backend interprets the operand representations
- fixed-width conversions reinterpret the same-width bit representation between
  `bW` and `iW` or `uW`. Ergonomic signed and unsigned arithmetic is ordinary
  Afterflow library code built from these conversions and the corresponding primitive
- rune conversion: `rune_from_u32` takes `value: u32`, `invalid: ()`, and
  `ok: (rune)`. It enters `invalid` for UTF-16 surrogates or values above
  U+10FFFF, otherwise it enters `ok` with the validated rune
- rune representation: `u32_from_rune` takes `value: rune` and `ok: (u32)`;
  every rune is representable as `u32`, so this conversion cannot fail
- string inspection: `str_rune_len` and `str_rune_nth` expose the rune view
  used when a `str` is executed. Indexes never expose partial UTF-8 code units
- UTF-8 validation: `str_from_utf8` takes `value: bytes`, `invalid: ()`, and
  `ok: (str)`. Successful conversion continues with the equivalent valid
  string
- byte inspection: `bytes_len` and `bytes_nth` expose the byte view used when
  `bytes` is executed. `bytes_from_str` losslessly continues with the string's
  UTF-8 bytes
- byte construction: `bytes_build` takes a provider with shape
  `((uint, (uint, (), (u8))))`, an `invalid: ()`, and an `ok: (bytes)`. Its
  representation is inaccessible to ordinary source, while append,
  concatenation, ropes, and parsing remain library code
- unsigned native arithmetic: `add_uint` and `sub_uint` use the target's native
  unsigned representation and continue with `uint`; `eq_uint` and `lt_uint`
  branch using unsigned equality and ordering
- byte scalar operations: `eq_b8` compares sign-neutral 8-bit
  representations, while `u8_from_int` enters `invalid` outside `0` through
  `255` and otherwise continues with the checked `u8`
- equality: `eq_int` and `eq_str` choose true and false continuations rather
  than returning booleans
- integer comparisons: `lt` and `gt` take true then false continuations. They
  jump to the true continuation (the third argument) when the comparison
  succeeds and the false continuation (the final argument) otherwise
- process completion: `@exit` terminates the process
- output: `@write` continues after writing
- file input: `file_read` takes `path: str`, `err: ()`, and `ok: (bytes)`. It
  reads the whole file named by `path` at runtime, enters `err` when the file
  cannot be opened or read, and enters `ok` with the complete unvalidated byte
  contents
- staged residualization: `runtime` takes `plan: ()`. The compile-time
  interpreter returns that plan as residual HIR, while ordinary runtime
  execution invokes it
- staged diagnostics: `compile_error` takes `message: str!` and
  `runtime_fallback: ()`. Staging reports the message as a compile-time error,
  while ordinary runtime execution invokes the fallback

`puts` is not a builtin. It is ordinary source code built from `@write`, and a
`puts`-style wrapper always appends a newline before
continuing:

```af
str: @str
puts: (s: str, ok:()) {
    @write(s, () {
        @write("\n", ok)
    })
}
```

`file_read` follows the same error-continuation convention as `div`. A text
wrapper is ordinary source code: it validates the bytes and can choose whether
invalid UTF-8 shares the I/O error continuation or has a separate domain error.
The compact shared-error form is:

```af
str: @str
bytes: @bytes

file_read_str: (path: str, err: (), ok: (str)) {
    @file_read(path, err, (contents: bytes) {
        @str_from_utf8(contents, err, ok)
    })
}

show: (path: str) {
    file_read_str(path, @exit(1), (contents: str) {
        @write(contents, @exit(0))
    })
}
```

Higher-level facilities are ordinary Afterflow code or platform-backed library code
rather than public core builtins. For example, integer maximum is a `/std/math`
library function built from comparison and continuations:

```af
int: @int

max: (a: int, b: int, ok: (int)) {
    @lt(a, b, () {
        ok(b)
    }, () {
        ok(a)
    })
}
```

The public `/std/math` functions are ordinary Afterflow library surface. Direct
wrappers map ergonomic names such as `abs` and `copy_sign` onto backing names
such as `fabs_f64` and `copysign_f64`. `ln` wraps unary `log_f64`, while
arbitrary-base `log(value, base)` divides two natural logarithms in Afterflow. These
private compiler boundaries link a `no_std` static archive that adds no entry
point, dynamic interpreter, or pre-`_start` initialization.

Language features that do not depend on external functionality are expressed
with grammar and punctuation rather than English keywords.

## Source Imports

A source package binding introduces a namespace for a folder of Afterflow source
files by project-absolute path:

```af
strings: /lib/strings
```

Import rules:

- source package bindings are file-root definitions. Builtin references are
  not imports and may appear wherever a label or type is valid
- source paths start with `/` and resolve against the project root;
  `@path` and filesystem-relative paths are invalid
- the path extends until a newline or `;`; earlier path components may contain
  spaces and hyphens
- the label before `:` is the namespace and must be a valid identifier. Builtin
  names do not reserve matching source-package labels because they use `@name`
- `/` is invalid because the root package is already the compilation entry,
  cannot be imported
- an import names a folder, never a single file
- every regular `.af` file directly inside the folder belongs to that
  folder's module. Subfolders are separate modules and need their own imports
- declarations in a `.af` file whose filename starts with `_` are private to
  that folder: sibling files can use them, but they cannot be selected as
  compilation targets or accessed through an imported namespace. The folder
  itself remains importable
- all root-level declaration names in a folder share one flat namespace;
  declaring the same name twice anywhere in one folder is invalid
- files in the same folder see each other's root declarations regardless of
  file order. Declaration-before-use ordering applies within each file, and
  mutual reference between files in the same folder is allowed
- sibling-file visibility is folder-namespace lookup, not same-scope
  ordering: each file's root scope keeps its own declaration-before-use
  rule, so this does not weaken the ordering rule within any scope
- folders reference other folders only through imports, and import
  dependencies between folders must not form a cycle
- an import namespace is compile-time only: it is not a value, cannot be passed
  or stored, and has no runtime representation

Imported declarations are reached through the bound namespace with a dot,
which is compile-time label lookup into the imported folder's root scope:

```af
strings: /lib/strings
upper: strings.upper
```

Aliasing an imported declaration (`upper: strings.upper`) puts it into the
ordinary scoped namespace, after which it behaves like any local label. Dot
access is not a runtime operation and does not generalize to values.

Imports are source templates, never precompiled binary artifacts. How a
compiler caches or reuses work derived from imported sources is an
implementation concern and belongs in that compiler's own documentation.

## Test Sources

A filename ending in `_test.af` is a test source. Selecting a regular `.af`
entry excludes every test source before parsing or resolving the root package
and its imports. Selecting a `_test.af` entry instead compiles the root
package's regular and test sources together. Imported packages still contain
only their regular sources.

Visibility is one-way: test sources see declarations from regular sibling
sources, while regular sources never see declarations owned by test sources.
Test sources may also use ordinary source imports to access public regular
declarations in other packages.

Only the selected `_test.af` entry may replace a callable builtin. An override
aliases the builtin name to a function with the builtin's contract:

```af
discard: (message: @str, ok: ()) {
    ok()
}

@write: discard
```

The replacement applies to every reference to that builtin in the test
compilation, including aliases declared by regular sources. Builtin types
cannot be replaced, and builtin override declarations are invalid in regular
sources and non-entry test sources.

## Punctuation Pattern

Afterflow uses a repeated punctuation pattern:

- `()` provides or fills value slots.
- `<>` provides or fills type slots.
- `{}` separates or contains choice/body structure.
- `name:` labels code or values.
- `@name` addresses compiler-provided builtins; `name: /path/to/name` binds a
  compile-time source namespace.
- `name.member` accesses an imported source member.
- `foo!(...)` marks a value-level executable application for compile-time HIR
  execution; `type!` marks compile-time availability on a parameter slot.

Types are not allowed as arguments in `()` because type arguments can often be
inferred and would clash with value argument counts. Type arguments use `<>`
instead.

## HIR must remain parseable source

A compiler's high-level intermediate representation (HIR) must be parseable, simplified source code.
It must be possible to generate valid source code from the HIR AST.
The HIR AST must be a subset of the source AST.
