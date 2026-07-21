# Afterflow compile-direct compiler

This is a small experimental programming language focused on simplicity,
predictability, and explicit semantics. The compile-direct compiler is written in Rust and
lowers Afterflow programs directly to NASM AMD64 assembly, producing ELF binaries
that run on AMD64 Linux using direct system calls without LLVM or a JIT.

It is statically typed, compiled, single static assignment, explicit
continuation passing, declaration before use, and has no manual memory
management operations in Afterflow source. Memory management is a compiler choice.
The current compile-direct compiler uses compiler-tracked ownership without a tracing
garbage collector, while another compiler may retain allocations or use a
different strategy.

The grammar file lives in: [grammar.peg](./grammar.peg)

Editor-independent language tooling lives in
[the language-server documentation](docs/language-server.md). Run it over standard input and
output with `cargo run -p afterflow-ls`.

The [documentation index](docs/index.md) links every focused project document.

## Formatting

Afterflow has one canonical source style implemented by the shared frontend.
Format standard input, print a file, rewrite files, or check formatting with:

```sh
cargo run -p afterflow-fmt < main.af
cargo run -p afterflow-fmt -- main.af
cargo run -p afterflow-fmt -- --write main.af
cargo run -p afterflow-fmt -- --check main.af
```

The language server exposes the same formatter over LSP. The Afterflow VS Code
extension uses it for **Format Document** and for save-time formatting when
`editor.formatOnSave` is enabled.

## compile-direct purpose

compile-direct is intentionally unoptimized. It is a *what you write is what you get*
compiler: it directly lowers the program's explicit control flow and data flow
instead of rewriting it for speed or size. The generated assembly necessarily
includes CPS, closure, and memory-management machinery, but compile-direct does not apply
peephole optimization, register allocation, inlining, or dead-code
elimination.

## Highlights

- **Continuation-Passing Style (CPS)**: Every label ends with a tail transfer to its continuation, enabling predictable control flow, no stack frames.
- **compile-direct deterministic memory management**: compile-direct closure environments and other
  dynamic allocations use `mmap`/`munmap` with compiler-tracked lifetimes. Allocation
  failure terminates the process with status 1 instead of entering a source-level
  operation continuation.
- **Strictly typed**: All interfaces, closure shapes, and continuation types are explicit and checked at compile time.
- **Punctuation-driven syntax**: A minimal surface language that stays readable while keeping the parser and backend fast.
- **No keywords**: There are no built-ins like `let`, `fn`, `if`, or `struct`, every semantic construct arises from punctuation and continuation form.
- **First-class functions**: Every value is passed explicitly, closures are automatically curried and lowered to environment structures.
- **Signature-owned staged execution**: A signature containing `!` parameters is the sole staging trigger. Those parameters are consumed by the typed HIR interpreter, while each remaining continuation without `!` is the staging boundary where ordinary runtime execution resumes. Applications have no staging marker.
- **Unicode-aware frontend**: UTF-8 literals and identifiers work as expected while the grammar stays ASCII-friendly.
- **Direct compile-to-assembly backend**: Deterministic performance, tiny runtime footprint, full control over calling conventions and memory layout.

# Example
```
fmt: /std/fmt

str: @str

name: "Alice"
hello: (){
   (msg: str) = fmt.new("hello %", fmt.str(name) fmt.end)
   @write(msg)
   @exit(0)
}
```

`@name` addresses the compiler-provided types and operations that every Afterflow
implementation must support. It is separate from user labels. Keyword-like
types are usually given short aliases. Source packages use explicit namespace
bindings such as `math: /std/math`.

## Scientific calculator

The staged `calc` library evaluates a scientific expression while retaining its
numeric inputs and output at runtime. This example combines a named-variable
hypotenuse with trigonometry and prints `result: 6.0`:

```af
fmt: /std/fmt
calc: /std/math/calc

main: () {
    (result: @f64) = calc.new("hypot(width, height) + sin(pi / 2) ^ 2",
        calc.var("width", 3.0)
        calc.var("height", 4.0)
        calc.end
    )
    (message: @str) = fmt.new("result: %\n", fmt.f64(result) fmt.end)
    @write(message)
    @exit(0)
}
```

Run the checked-in example with:

```sh
make example calc
```

## Execution Model & Core Semantics

It is a **identifier-driven, definition-oriented, definition before use, static single assignment, expression-less, continuation-passing language**.  
Programs are built from two fundamental actions:

- **defining identifiers for values**, and  
- **transferring control to identifier** that interpret those definitions.

There are no expressions, operators or return values, all computation is a sequence of definitions followed by a transfer of control to another function.

### Definition

A definition introduces a name for a value inside the current scope:
```
fmt: /std/fmt

str: @str

name: "Bob"
foo: (ok:()){
   (message: str) = fmt.new("hello %", fmt.str(name) fmt.end)
   @write(message)
   ok
}
```

### Execution

```
fmt: /std/fmt

str: @str

name: "Bob"
foo: (ok:()){
   (message: str) = fmt.new("hello %", fmt.str(name) fmt.end)
   @write(message)
   ok
}
end: @exit(0)
foo(end)
```

This syntax `foo(end)` does **not** imply a C-style function call.  
Instead, the parser interprets the form in one of two ways:

1. **Argument application ([currying](https://en.wikipedia.org/wiki/Currying))**  
When application appears on the right-hand side of a definition `end: exit(0)` or as a direct argument `foo(exit(0))`
it is treated as applying arguments to a closure. No execution happens at this point, it creates an applied closure that can be executed later.

i.e. `foo(x)` with a name or as an argument produces a closure (an executable value) by binding x (and any captured scope) without executing.

2. **Tail jump (control transfer)**
When application appears as a standalone action in a block .e.g `foo(end)`
it is compiled as a tail jump to `foo`. Control transfers directly to `foo`
and never returns to the current location.

Compile-time execution is owned exclusively by the callable's signature.
Executing a function with at least one `!` parameter enters the HIR
interpreter. There is no call-level bang or any other staging mechanism.
Marked arguments remain available to that interpreter,
including known recursive closure structure such as a formatter argument
chain. Unmarked data is opaque to the interpreter even when the caller supplied
a literal, while each remaining continuation parameter without `!` is the
staging boundary: the compiler emits the transfer leading into that
continuation for normal runtime execution. Any input that staged code must
inspect before that boundary must therefore be marked `!`.

Partial application preserves this property. A labelled closure rooted in a
function with marked parameters is staged when it is eventually executed:

```af
q: build(2)
q(@exit)
```

Runtime payloads may remain captured inside compile-time-known closures. They
cannot be inspected before the continuation boundary. This lets `fmt.new` and
`calc.new` validate static DSL input during compilation while leaving string
construction, arithmetic, I/O, and the rest of the program to runtime.

## Avoiding Deeply Nested Control Flow
Languages that rely on embedding functions inside functions often produce deeply
nested control structures, sometimes referred to as "callback hell." A typical
nested style (shown here in pseudocode) looks like:

```
read("a.txt", (a:str) {
    read("b.txt", (b:str) {
        process(a, b, (result:str) {
            write("out.txt", result, (code:int) {
                exit(code)
            })
        })
    })
})
```
Each operation encloses the next, causing the structure to collapse inward.

Afterflow avoids such nesting through **scope capture** using `=`.
The operator does not assign or mutate, it transforms the remainder of the block into a continuation that receives the named value.

The same logical flow becomes:
```
(a:str) = read("a.txt")
(b:str) = read("b.txt")
(result:str) = process(a, b)
(code:int) = write("out.txt", result)
exit(code)
```

Each line shapes the continuation: `read("a.txt")` continues into the remainder
of the block with `a:str` in scope, then `read("b.txt")` continues with `b:str`,
and so on. The remaining scope is repeatedly captured and threaded forward,
so control flow stays flat and easy to follow instead of nesting deeper with
each dependent step.

This is done purely through syntax sugar.

### Lambda Calculus as an Operational Machine Model

What if we adopt a fully operational view of [lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus), where every term is an executable computation rather than a value-denoting expression?

Under this interpretation, the lambda calculus effectively becomes:
- a **minimal machine** model much closer to assembly than to high-level mathematics
- a **control-flow graph** where substitution acts as a jump with an extended environment
- a **small-step abstract machine** (CEK, Krivine, etc.) whose resource
  management strategy is chosen by the compiler.
- a **rewriting interpreter** whose only instruction is β-reduction (providing arguments to functions).

The idea was to make this operational structure explicit and statically checked, while presenting it using a familiar C-family surface syntax (inspired by JavaScript, TypeScript, Go, Rust).

Programs are then lowered directly into tail-jump CPS and compiled straight to assembly.

## Local install

The project toolchain is pinned in [.tool-versions](./.tool-versions):

- Rust: `1.96.0`
- NASM: `3.01`

Install the host packages needed to download and build the pinned tools. On Debian:

```sh
sudo apt-get update
sudo apt-get install -y build-essential binutils curl git tar zlib1g-dev
```

Install [asdf](https://asdf-vm.com/guide/getting-started.html), then from the repo root run:

```sh
make install
```

`make install` is idempotent. It installs the required asdf plugins if missing, installs the pinned Rust toolchain, builds NASM `3.01` into the asdf install directory if it is not already present, writes the local tool versions, and refreshes shims.

Verify the setup with:

```sh
cargo test
```

Run the sample program with:

```sh
make run hello
```

Run an example program with:

```sh
make example comptime_format
```

## Quick start (Using Docker)

```sh
git clone https://github.com/afterflowlang/afterflow.git
cd afterflow
docker build -t afterflow-compiler .
docker run --rm -i afterflow-compiler compile-direct/code/main.af hello
```

This compiles and runs the `hello` target in `compile-direct/code/main.af`.

This is what happens inside the container (or on your linux machine)
```sh
apt-get install -y nasm gcc make
cargo run -p compiler -- compile-direct/code/main.af hello hello.asm
nasm -felf64 hello.asm -o bin/hello.o
cargo build -p freestanding-format --release
cargo build -p freestanding-math --release
ld --gc-sections --strip-debug bin/hello.o target/release/libfreestanding_format.a target/release/libfreestanding_math.a -o bin/hello
./bin/hello
```

## Development Workflow

1. **Code Changes**: Make changes to the compiler's source code.
2. **Testing**: Run Rust tests using `cargo test`.
3. **Snapshot Updates**: If changes require new snapshots, manually copy `.actual` files to `.expected`.

## Building and testing

- Rebuild the compiler or run the golden snapshot suite with `cargo test -p compiler`. This also executes `compile-direct/tests/golden_test.rs`, which reads each fixture from its own numbered complexity folder under `compile-direct/tests/golden/` or `compile-direct/tests/failing/` and regenerates matching snapshots under `compile-direct/tests/generated/`:
  - `*.asm` contains the final NASM output.
  - `*.air` records the pseudo-assembly that feeds the final backend.
  - `*.hir.af` is the normalized high-level IR after parsing.
  - `*.hir.debug.txt` shows the HIR structure.
  - `*.txt` captures the parser AST dump.
- Whenever you change the compiler or templates that affect these snapshots, re-run `cargo test` and check the updated files into source control if they reflect expected behavior.

## Project structure

- `frontend/src/`: shared Rust implementation of source loading, lexing, parsing, AST, and HIR construction.
- `compile-direct/src/`: direct compiler implementation from HIR through compile-time execution, AIR, and NASM code generation.
- `compile-direct/code/`: sample Afterflow workspace files (`main.af` contains target functions such as `hello` for Makefile shortcuts).
- `compile-direct/tests/`: integration and golden snapshot tests; `golden_test.rs` is the automated snapshot generator.
- [SEMANTICS.md](SEMANTICS.md) describes source-language rules and
  user-visible behavior.
- [SPEC.md](SPEC.md) describes compile-direct runtime representation, lowering, and
  heap details.

## Compilation

For compile-direct, the input file locates the project root: its containing folder is the
root package, and every `.af` file directly in that folder is compiled into
the same package. A source binding such as `lib: /lib` loads every direct
`.af` file from the `lib` folder beneath that project root.
The root package itself cannot be imported. Declarations shared with imported
packages belong in a named package that each consumer imports.

The compilation process flows as follows. The first three phases live in the shared `afterflow-frontend` crate:
1. `Lexer`: Transforms source text into a stream of `Token`s.
2. `Parser`: Consumes tokens to produce an Abstract Syntax Tree (AST).
3. `HIR`: AST is desugared and type checked.
4. `Comptime`: Calls rooted in signatures with `!` parameters are interpreted
   and residualized at their unmarked continuation parameters.
5. `AIR`: Control flow analysis and memory management.
6. `Codegen`: Assembly output.
7. `Assembler`: Converts assembly text into machine object files.
8. TODO: `Linker`: Combines object files and libraries into the final executable.

## Current Limitations & Roadmap Notes

This language is still in an early experimental phase, and several subsystems are intentionally minimal or entirely missing. The following areas are not yet implemented:

- No optimizations  
The backend currently emits straightforward CPS-lowered NASM without peephole passes, register allocation strategies, inlining, or dead-code elimination. Output is correct but not optimized.
- Floating-point support is binary64-only
The type system, backend, and bundled `/std/math` package expose the common
binary64 trigonometric, hyperbolic, exponential, logarithmic, power, root,
rounding, remainder, and floating utility functions. A distinct `@f32` type and
surface do not yet exist.
- No arrays or slices  
Aggregate data structures are not yet supported. There is no syntax or type-level encoding for contiguous memory layouts, indexing, or bounds semantics.
- Minimal runtime surface  
At present, the backend surface includes `@write`, byte-oriented `@file_read`,
executable string and byte inspection, checked UTF-8 conversion, safe immutable
byte materialization, and arbitrary native NASM instructions. The bundled
`/std/fmt` package implements append, concatenation, integer rendering, and
placeholder parsing in ordinary Afterflow source.

Despite that, functionality is slowly expanding, and the compiler architecture is structured so these features can be added piece by piece while keeping the language’s core goals (simplicity, explicitness, and predictability) intact.

## Planned structure
```
afterflowlang/
  ├── afterflow/                # core monorepo: compilers, languag server, formatter...
  ├── afterflow-vscode/         # VS Code extension
  ├── afterflow-zed/            # Zed extension
  ├── afterflow.nvim/           # Neovim integration
  ├── registry/                 # hosted package-registry service
  ├── website/                  # optional deployed website
  └── .github/                  # organization profile and shared workflows
```

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
