# Rgo Semantics

This document describes what Rgo programs mean: which programs are valid,
what source constructs do, and what behavior users can rely on.

## Core Model

Rgo is an identifier-driven, definition-oriented, declaration-before-use,
single-assignment, expression-less, continuation-passing language.

Programs are built from two fundamental actions:

- defining identifiers for values
- transferring control to identifiers that interpret those definitions

There are no expression returns. Computation is a sequence of definitions
followed by a control transfer to another executable value.

At the file root, Rgo accepts definitions. Root-level execution is not valid
source; the compiler appends an invocation of the requested target function
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
comments start with `/*` and continue until the next `*/`; they may span
lines and are treated as whitespace. Block comments are not nested.

String literals have two forms:

- double-quoted strings process escapes such as `\n`, `\t`, `\\`, `\"`,
  `\0`, and `\u{...}`
- single-quoted strings keep backslashes as ordinary characters

Integer literals are signed machine-sized integer values. Floating literals
exist and have type `f64`.

## Definitions

A definition introduces a name for a value inside the current scope:

```rgo
str: @str

printf: (fmt: str!, args: ..., ok:()) {
    (s: str) = @sprintf(fmt, args)
    @write(s, ok)
}

name: "Bob"
foo: (ok:()){
    printf("hello %s", name, ok)
}
```

Definition forms:

- `name: literal`
  - defines a literal value; string and integer literal aliases have
    compile-time types `str!` and `int!`
- `name: other`
  - aliases an existing identifier
- `name: other(args...)`
  - defines a curried executable value
- `name: (params...)`
  - defines a signature alias
- `name: <T>(params...)`
  - defines a generic signature alias
- `name: (params...){ body }`
  - defines a function
- `name: <T>(params...){ body }`
  - defines a generic function

Function and lambda parameters must have explicit types. Signature aliases may
use unnamed type slots such as `(str)` because they describe shape rather than
binding local parameter names.

Generic parameter lists must contain at least one name and cannot repeat a
name.

Redefining the same label in the same scope is invalid:

```rgo
x: 1
x: 2
```

Nested scopes may shadow outer labels:

```rgo
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

```rgo
end: exit(0)
foo(end)
```

In `end: exit(0)`, `exit(0)` is a curried executable value. It does not execute
at definition time.

The outermost application of an executable block continuation sentence
transfers control to that executable value and does not return to the current
location:

```rgo
foo(end)
```

Outermost identifiers and lambdas are invocations even when they have no
explicit argument list:

```rgo
mywrite: @write("hello", (){})
mywrite
```

The final `mywrite` invokes the executable value and writes `hello`.

Likewise, a lambda block item executes:

```rgo
(){
    @write("hello", (){})
}
```

The outermost invocation must supply enough arguments to run. A partial
application can be stored, passed, or used as an inner phrase of a continuation
sentence, but it cannot be the outermost action by itself.

Literal values cannot be standalone invocations.

Chained application supplies more arguments to the same executable value:

```rgo
foo(a)(b)
```

is equivalent to currying `foo` with `a`, then currying that result with `b`.

Inside a definition value, one argument of an application, or an executable
block continuation sentence, whitespace between adjacent values applies to the
right:

```rgo
chain: a b c
foo(a b c)
```

Both value positions mean `a(b(c))`. Parentheses still supply the immediate
arguments of one phrase, so:

```rgo
chain: a(x) b(y) c(z)
```

means:

```rgo
chain: a(x, b(y, c(z)))
```

A definition's continuation sentence may span lines when its following phrases
are indented beyond its label:

```rgo
chain:
    a(x)
    b(y)
    c(z)
```

## Block Continuation Sentences

Newlines and spaces have the same right-associative application meaning between
adjacent executable phrases. Only the outermost phrase transfers control; every
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

```rgo
foo: (){
    bar(x)
    baz(y)
    exit(0)
}
```

means:

```rgo
foo: (){
    bar(x, baz(y, exit(0)))
}
```

The unit continuation is not special. A right-hand phrase may instead remain
partially applied with the payload shape expected by the phrase on its left:

```rgo
int: @int
str: @str

produce: (value: int, ok: (int)){
    ok(value)
}

consume: (prefix: str, value: int){
    (message: str) = @sprintf("%s %d\n", prefix, value)
    @write(message, @exit(0))
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

```rgo
main: (){
    foo
    value: something
    bar(value)
}
```

means:

```rgo
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

```rgo
main: (){
    (result: int) = produce(42)
    consume("value", result)
}
```

Explicit scope capture remains necessary when the received values need names,
must be used more than once, or feed a continuation that cannot be represented
by the residual signature of one applied value. An implicit capture always has
the unit signature `()`; use explicit scope capture when the preceding execution
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
  - reject too many arguments unless a variadic parameter accepts them
  - type-check every non-variadic argument against its matched parameter

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

- encounter `(name: type) = operation(args...)`
  - require `operation` to be an executable value that accepts the appended continuation
  - turn the rest of the current block into a continuation
    - the continuation receives `name: type`
    - the continuation body is the original remaining block
  - append that continuation to `operation(args...)`
  - transfer control to `operation`

For example:

```rgo
int: @int
str: @str

printf: (fmt: str!, args: ..., ok:()) {
    (s: str) = @sprintf(fmt, args)
    @write(s, ok)
}

hello: (){
    (sum: int) = @add(2, 3)
    printf("sum: %d\n", sum, @exit(0))
}
```

This behaves like nested continuations, but keeps source code flat. Each
capture introduces the named value into the remaining block.

Nested functions may reference values from enclosing scopes. Those references
are captured into the nested function value. Root-level functions are ordinary
declared functions and are not captured from other root-level functions.

## Types

Builtin type names can be aliased into local type labels:

```rgo
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
- `byte` must be a compile-time available integer from `0` through `255`.
  Integer literals supplied where `byte` is required are checked against this
  range.
- `f64` must be a floating-point value. An integer literal may satisfy an
  `f64` parameter because it is compile-time available.

At runtime, a `str` carries a data pointer and a byte length. The data storage
also has a trailing NUL byte for C interoperability, but that terminator is not
part of the Rgo string length. Rgo operations such as `@write` preserve
embedded `\0` bytes. A libc API that accepts only a C `char*`, including `%s`
formatting, stops at the first embedded NUL.

Function types are written with parameter lists:

```rgo
receiver: (value: str)
predicate: (ok: (), err: ())
mapper: (value: str, ok: (str))
```

Data and control are encoded with functions and signatures rather than
reserved categories. A value that can be either an integer or a string can be
represented by a function that accepts one continuation for each case:

```rgo
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

```rgo
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

```rgo
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

The `...` marker is part of a parameter, not part of the type itself. It marks
how the function accepts input, in the same way that `!` marks a compile-time
requirement on the parameter. A user-declared `...` parameter is opaque: source
can forward it to another variadic call, but cannot inspect it as a collection.

## Variadic Parameters

Source programs may declare their own `...` parameters. The parameter has no
source-visible element type or collection API.

The implemented variadic builtin is:

```rgo
sprintf(format: str!, args: ..., ok: (str))
```

Variadic argument flow:

- match fixed prefix parameters
  - `format` must be `str!`
- match fixed suffix parameters
  - `ok` is the final continuation
- route every argument between the prefix and suffix through `args`
  - `args` is not exposed as a source-level array value
  - middle arguments do not have a declared element type

Formatted printing is ordinary source code:

```rgo
str: @str

printf: (fmt: str!, args: ..., ok:()) {
    (s: str) = @sprintf(fmt, args)
    @write(s, ok)
}
```

## Closure Values and Affinity

A closure value is an executable value with captured and/or already supplied
arguments.

Currying a closure produces an executable value with more arguments supplied.
The language must preserve affine behavior: no two live values may observe
incompatible mutations of the same logical closure state.

Rules:

1. Currying a closure must produce independent logical closure state. The v1
   implementation does this by deep-cloning the source closure even when the
   curry is its sole use.
2. If a closure value has more than one remaining use, storing it as a curried
   argument must preserve the other uses as if they had independent closure
   state.
3. If the same closure value is used in multiple places, such as `k(x, x)`,
   all uses must behave as independent values where later currying could
   otherwise interfere.
4. Pure renaming without duplication does not create a new semantic use.

These are semantic rules. The single-pointer runtime representation and cloning
details are documented in [SPEC.md](SPEC.md).

## Builtins and Imports

Compiler-provided builtins are addressed directly with `@name`. They are the
types and operations that require backend support and are guaranteed by the
Rgo language contract. Higher-level facilities belong in ordinary source
packages.

`@name` is a compiler-owned label space, not a namespace value or an import.
It is available wherever a label or type is valid and never occupies the user
label namespace unless code deliberately aliases it:

```rgo
int: @int
write: @write
```

Builtin names are flat and must match a builtin known by the compiler.
`@anything` never selects or renames a package; an unknown name is an error.
Builtin references contain exactly one name, so `@std.write` is invalid.

The builtin name must match a builtin known by the compiler. Current builtin
entries are:

```text
@str // owner: backend/runtime ABI; strings carry a data pointer and byte length; C calls receive a NUL-terminated data pointer
@int // owner: backend/ABI; machine preferred integer layout for the target architecture
@uint // owner: backend/ABI; machine preferred unsigned integer layout for the target architecture
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
@add // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@sub // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@mul // owner: CPU/backend; primitive integer instruction exposed with a CPS signature
@div // owner: CPU/backend; primitive checked integer division with error and success continuations
@add_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@mul_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
@div_f64 // owner: CPU/backend; primitive floating-point instruction exposed with a CPS signature
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
@lt // owner: CPU/backend; primitive integer comparison branch emitted as direct control transfer
@gt // owner: CPU/backend; primitive integer comparison branch emitted as direct control transfer
@sprintf // owner: libc variadic ABI and runtime buffer; deterministic string formatting
@write // owner: OS/filesystem descriptor API; byte-stream output operation
@readfile // owner: OS/filesystem API; whole-file read into a runtime string with error and success continuations
@exit // owner: OS process ABI; process-completion operation
```

Builtin aliases occupy the user label namespace. A builtin can be aliased
under any available label:

```rgo
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
- floating arithmetic: `add_f64`, `mul_f64`, `div_f64` take `x: f64`, `y: f64`,
  and `ok: (f64)`
- sign-neutral fixed-width arithmetic: `add_bW`, `sub_bW`, and `mul_bW` take
  two `bW` values and continue with their wrapping result
- sign-sensitive fixed-width division: `div_signed_bW` and
  `div_unsigned_bW` take two `bW` values, `err: ()`, and `ok: (bW)`; their
  names specify how the backend interprets the operand representations
- fixed-width conversions reinterpret the same-width bit representation between
  `bW` and `iW` or `uW`; ergonomic signed and unsigned arithmetic is ordinary
  Rgo library code built from these conversions and the corresponding primitive
- equality: `eq_int` and `eq_str` choose true and false continuations rather
  than returning booleans
- integer comparisons: `lt` and `gt` take true then false continuations; they
  jump to the true continuation (the third argument) when the comparison
  succeeds and the false continuation (the final argument) otherwise
- formatting: `@sprintf` deterministically produces a string
- process completion: `@exit` terminates the process
- output: `@write` continues after writing
- file input: `readfile` takes `path: str`, `err: ()`, and `ok: (str)`; it
  reads the whole file named by `path` at runtime, enters `err` when the file
  cannot be opened or read, and enters `ok` with the complete contents as a
  runtime string

`sprintf` requires backend support because source code cannot inspect its
heterogeneous variadic arguments or construct a runtime string. It can move to
an ordinary source or platform-backed library only when Rgo has a smaller
source-expressible formatting substrate.

`puts` is not a builtin. It is ordinary source code built from `@write`, and a
libc-style wrapper always appends a newline before
continuing:

```rgo
str: @str
puts: (s: str, ok:()) {
    @write(s, () {
        @write("\n", ok)
    })
}
```

`readfile` follows the same error-continuation convention as `div`: the error
continuation is entered without a payload when the file cannot be opened or
read, and the success continuation receives the whole contents as a runtime
string:

```rgo
str: @str

show: (path: str) {
    @readfile(path, @exit(1), (contents: str) {
        @write(contents, @exit(0))
    })
}
```

Higher-level facilities are ordinary Rgo code or platform-backed library
code rather than core builtins. For example, integer maximum is a library
function built from comparison and continuations:

```rgo
int: @int

max_int: (x: int, y: int, ok: (int)){
    @lt(x, y, (){
        ok(y)
    }, (){
        ok(x)
    })
}
```

Language features that do not depend on external functionality are expressed
with grammar and punctuation rather than English keywords.

## Source Imports

A source package binding introduces a namespace for a folder of Rgo source
files by project-absolute path:

```rgo
strings: /lib/strings
```

Import rules:

- source package bindings are file-root definitions; builtin references are
  not imports and may appear wherever a label or type is valid
- source paths start with `/` and resolve against the project root;
  `@path` and filesystem-relative paths are invalid
- the path extends until a newline or `;`; earlier path components may contain
  spaces and hyphens
- the label before `:` is the namespace and must be a valid identifier; it may
  be `std` because builtins use `@name`
- `/` is invalid because the root package is already the compilation entry,
  cannot be imported
- an import names a folder, never a single file
- every `.rgo` file directly inside the folder belongs to that folder's
  module; subfolders are separate modules and need their own imports
- all root-level declaration names in a folder share one flat namespace;
  declaring the same name twice anywhere in one folder is invalid
- files in the same folder see each other's root declarations regardless of
  file order; declaration-before-use ordering applies within each file, and
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

```rgo
strings: /lib/strings
upper: strings.upper
```

Aliasing an imported declaration (`upper: strings.upper`) puts it into the
ordinary scoped namespace, after which it behaves like any local label. Dot
access is not a runtime operation and does not generalize to values.

Imports are source templates, never precompiled binary artifacts. How a
compiler caches or reuses work derived from imported sources is an
implementation concern and belongs in that compiler's own documentation.

## Punctuation Pattern

Rgo uses a repeated punctuation pattern:

- `()` provides or fills value slots.
- `<>` provides or fills type slots.
- `{}` separates or contains choice/body structure.
- `name:` labels code or values.
- `@name` addresses compiler-provided builtins; `name: /path/to/name` binds a
  compile-time source namespace.
- `name.member` accesses an imported source member.

Types are not allowed as arguments in `()` because type arguments can often be
inferred and would clash with value argument counts. Type arguments use `<>`
instead.

## HIR must remain parseable source

A compiler's high-level intermediate representation (HIR) must be parseable, simplified source code.
It must be possible to generate valid source code from the HIR AST.
The HIR AST must be a subset of the source AST.
