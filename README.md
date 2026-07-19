# Afterflow compile-direct compiler

This is a small experimental programming language focused on simplicity, predictability, and explicit semantics. The compile-direct compiler is written in Rust and lowers Afterflow programs directly to NASM AMD64 assembly, producing ELF binaries that run on any AMD64 Linux system with hooks to standard libc (no LLVM, no JIT, and no garbage collector but with automatic garbage collection).

It is statically typed, compiled, single static assignment, explicit continuation passing, declaration before use, automatically memory managed using linear types (No garbage collector) and with no runtime errors.

The grammar file lives in: [grammar.peg](./grammar.peg)

## Highlights

- **Continuation-Passing Style (CPS)**: Every label ends with a tail transfer to its continuation, enabling predictable control flow, no stack frames.
- **Deterministic memory model**: Closure environments and other allocations use mmap/munmap. The compiler manages lifetimes, so no tracing GC or manual free is required.
- **Strictly typed**: All interfaces, closure shapes, and continuation types are explicit and checked at compile time.
- **Punctuation-driven syntax**: A minimal surface language that stays readable while keeping the parser and backend fast.
- **No keywords**: There are no built-ins like `let`, `fn`, `if`, or `struct`, every semantic construct arises from punctuation and continuation form.
- **First-class functions**: Every value is passed explicitly, closures are automatically curried and lowered to environment structures.
- **Unicode-aware strings**: UTF-8 string literals work as expected; identifiers use an intentionally ASCII-only grammar.
- **Direct compile-to-assembly backend**: Deterministic performance, tiny runtime footprint, full control over calling conventions and memory layout.

# Example
```
str: @str

name: "Alice"
printf: (fmt: str!, args: ..., ok:()) {
   (s: str) = @sprintf(fmt, args)
   @write(s, ok)
}
hello: (){
   printf("hello %s", name, @exit(0))
}
```

`@name` addresses the compiler-provided types and operations that every Afterflow
implementation must support. It is separate from user labels; keyword-like
types are usually given short aliases. Source packages use explicit namespace
bindings such as `math: /math`.

## Execution Model & Core Semantics

It is a **identifier-driven, definition-oriented, definition before use, static single assignment, expression-less, continuation-passing language**.  
Programs are built from two fundamental actions:

- **defining identifiers for values**, and  
- **transferring control to identifier** that interpret those definitions.

There are no expressions, operators or return values, all computation is a sequence of definitions followed by a transfer of control to another function.

### Definition

A definition introduces a name for a value inside the current scope:
```
str: @str

name: "Bob"
printf: (fmt: str!, args: ..., ok:()) {
   (s: str) = @sprintf(fmt, args)
   @write(s, ok)
}
foo: (ok:()){
   printf("hello %s", name, ok)
}
```

### Execution

```
str: @str

name: "Bob"
printf: (fmt: str!, args: ..., ok:()) {
   (s: str) = @sprintf(fmt, args)
   @write(s, ok)
}
foo: (ok:()){
   printf("hello %s", name, ok)
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
- a **small-step abstract machine** (CEK, Krivine, etc.) but with memory management without a garbage collector.
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

## Quick start (Using Docker)

```sh
git clone https://github.com/afterflowlang/afterflow.git
cd afterflow
docker build -t afterflow-compiler .
docker run --rm -i afterflow-compiler code/main.af hello
```

This compiles and runs the `hello` target in `code/main.af`.

This is what happens inside the container (or on your linux machine)
```sh
apt-get install -y nasm gcc make
cargo run -- code/main.af hello hello.asm
nasm -felf64 hello.asm -o bin/hello.o
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc bin/hello.o -o bin/hello
./bin/hello
```

## Development Workflow

1. **Code Changes**: Make changes to the compiler's source code.
2. **Testing**: Run Rust tests using `cargo test`.
3. **Snapshot Updates**: If changes require new snapshots, manually copy `.actual` files to `.expected`.

## Building and testing

- Rebuild the compiler or run the golden snapshot suite with `cargo test`. This also executes `tests/golden_test.rs`, which reads each fixture from its own numbered complexity folder under `tests/golden/` or `tests/failing/` and regenerates matching snapshots under `tests/generated/`:
  - `*.asm` contains the final NASM output.
  - `*.air` records the pseudo-assembly that feeds the final backend.
  - `*.hir.af` is the normalized high-level IR after parsing.
  - `*.hir.debug.txt` shows the HIR structure.
  - `*.txt` captures the parser AST dump.
- Whenever you change the compiler or templates that affect these snapshots, re-run `cargo test` and check the updated files into source control if they reflect expected behavior.

## Project structure

- `src/`: Rust implementation of the lexer, parser, HIR, and back-end code generator.
- `code/`: sample Afterflow workspace files (`main.af` contains target functions such as `hello` for Makefile shortcuts).
- `tests/`: integration and golden snapshot tests; `golden_test.rs` is the automated snapshot generator.
- [SEMANTICS.md](SEMANTICS.md) describes source-language rules and
  user-visible behavior.
- [SPEC.md](SPEC.md) describes compile-direct runtime representation, lowering, and
  heap details.

## Compilation

For compile-direct, the input file locates the project root: its containing folder is the
root package, and every `.af` file directly in that folder is compiled into
the same package. A source binding such as `lib: /lib` loads every direct
`.af` file from the `lib` folder beneath that project root.
The root package itself cannot be imported; declarations shared with imported
packages belong in a named package that each consumer imports.

The compilation process flows as follows:
1. `Lexer`: Transforms source text into a stream of `Token`s.
2. `Parser`: Consumes tokens to produce an Abstract Syntax Tree (AST).
3. `HIR`: AST is desugared and type checked.
4. `AIR`: Control flow analysis and memory management.
5. `Codegen`: Optimization and assembly output.
6. `Assembler`: Converts assembly text into machine object files.
7. TODO: `Linker`: Combines object files and libraries into the final executable.

## Current Limitations & Roadmap Notes

This language is still in an early experimental phase, and several subsystems are intentionally minimal or entirely missing. The following areas are not yet implemented:

- No optimizations  
The backend currently emits straightforward CPS-lowered NASM without peephole passes, register allocation strategies, inlining, or dead-code elimination. Output is correct but not optimized.
- Limited floating-point support
`f64` literals and the `@add_f64`, `@mul_f64`, and `@div_f64` builtins are available. Broader numeric facilities and platform math-library bindings are not yet implemented.
- No math library  
Functions such as sin, cos, sqrt, and friends are not yet exposed. Interfacing to libm and defining a typed surface for it are planned but currently absent.
- No arrays or slices  
Aggregate data structures are not yet supported. There is no syntax or type-level encoding for contiguous memory layouts, indexing, or bounds semantics.
- Minimal runtime surface  
The compiler-provided runtime surface consists of the builtins documented in [SEMANTICS.md](SEMANTICS.md), including `@write`, `@readfile`, and `@sprintf`.

Despite that, functionality is slowly expanding, and the compiler architecture is structured so these features can be added piece by piece while keeping the language’s core goals (simplicity, explicitness, and predictability) intact.

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
