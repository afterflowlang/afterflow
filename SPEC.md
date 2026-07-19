# Afterflow compile-direct Spec

This document records implementation and runtime representation choices for the
compile-direct compiler.

For source-language behavior and user-visible rules, see
[SEMANTICS.md](SEMANTICS.md).

## Pipeline Responsibilities

HIR is the normalized source-level representation. It resolves and normalizes
semantic structure before AIR lowering.

Functions without a source name are assigned generated HIR names that start
with `_<digit>_`.

HIR wraps builtins in lambdas so builtins are executed instead of curried. This
keeps variadic lowering simpler because HIR can replace the source AST with a
wrapper shape.

AIR expresses semantic effects and control transfers only. Intermediate values
that exist solely to implement an effect should not appear in AIR.

Compile flow:

- parse source into AST
  - preserve source forms such as scope capture, lambdas, imports, and
    application position
- lower AST to HIR
  - resolve names and declaration-before-use rules
  - normalize anonymous functions into generated names
  - rewrite scope capture into continuation application
  - wrap builtins so they execute instead of being curried
- lower HIR to AIR
  - express control transfers and semantic effects
  - create closure allocation, currying, clone, and release operations
  - keep temporary machine-only values out of AIR
- lower AIR to NASM
  - choose registers, stack slots, labels, and runtime helper calls
  - emit closure environment layout and metadata access

## Closure Representation

compile-direct represents a function passed as an argument as a heap-allocated closure.
The runtime value is one word: a pointer to `env_end`. The closure code pointer
lives in metadata at offset 0 from `env_end` and is loaded when the closure is
executed.

The heap object stores captured values and curried argument slots before
metadata. The metadata lets runtime helpers compute allocation boundaries for
release and cloning.

Runtime closure value shape:

```txt
runtime closure value
+--------------------------+
| env_end pointer          | -> end of payload / start of metadata region
+--------------------------+
```

Closure environment shape:

```txt
[ env payload (captures + arg slots) ] [ metadata ... ]
  ^                                   ^
  env_base                            env_end
```

Payload flow:

- allocate closure object
  - write captured values into payload slots
  - reserve argument slots for parameters not supplied yet
  - write metadata after the payload
- curry closure
  - locate payload from `env_end`
  - write supplied arguments into remaining slots
  - update metadata describing remaining arguments
- execute closure
  - load the closure unwrapper from metadata
  - pass `env_end`
  - jump to the unwrapper

The older layout used only an `env_size` metadata word:

```txt
release heap_end = env_end + metadata_size
release heap_base = env_end - env_size
release heap_size = env_size + metadata_size
```

The newer metadata header is:

```txt
env_base
  |
  v
+----------------------------------------------+
| env payload: captures + curried argument data |
+----------------------------------------------+ <- env_end
| metadata header                              |
|   +  0: unwrapper pointer                    |
|   +  8: release helper                       |
|   + 16: deep copy helper                     |
|   + 24: env size                             |
|   + 32: heap size                            |
|   + 40: remaining unfilled argument words    |
+----------------------------------------------+
  ^
  |
heap_end
```

## Process Memory Model

The compile-direct runtime model assumes code/data, heap, free space, and stack in the
process address space:

```txt
0x0000 (low address)
+----------------------+
|     TEXT / CODE      |
+----------------------+
|      DATA / BSS      |
+----------------------+
|        HEAP          |
|          |           |
|          v           | grows upward
|                      |
|      FREE SPACE      |
|                      |
|          ^           | grows downward
|          |           |
|        STACK         |
+----------------------+
MAX MEM (high address)
```

Closure environments and variadic payloads are allocated with `mmap` and
released with `munmap`.

Because functions tail-jump and do not return, a function can know when a
closure parameter is no longer needed. Before an invocation, if a closure
parameter is not passed onward and is not the invocation target, compile-direct releases
that closure environment.

Release decision flow:

- before lowering an invocation
  - start with closure parameters that are still owned by the current function
  - remove the invocation target if it is one of those closures
  - remove every closure passed as an argument
  - for each closure still left
    - emit `ReleaseHeap`
    - lower codegen to `release_heap_ptr`
    - compute allocation base and size from metadata
    - call `munmap`

## Variadic Lowering

The semantic variadic value is implemented as a closure over a packed payload.

At each exec site, AIR slices supplied arguments into:

- prefix arguments
- variadic arguments
- suffix arguments

The variadic slice becomes a hidden invocation of the builtin
`internal_array_str` closure. The call behaves as if the user had invoked
`foo(items)`, where `items` captures the variadic payload.

The packer allocates a heap block for captured values. Each element is written
sequentially, followed by an 8-byte length field. Word-sized elements, such as
`str`, use one slot. Closure elements are stored as their single `env_end`
pointer.

The allocation reserves extra space for a scratch invocation frame and appends:

- array env size
- total heap size
- scratch size needed when calling the consumer

The closure metadata unwrapper slot points at `internal_array_str`.

`internal_array_str` calls the user continuation with:

1. `len: int`
2. `nth: (idx:int, one:(str), none:())`

`internal_array_str_nth` reads metadata to bounds-check the requested index,
then jumps to `one` with the element or to `none`.

The generated source-level shape is effectively:

```af
items: internal_array_str
```

where the environment points at the packed variadic payload.

Variadic payload shape:

```txt
env_base
  |
  v
+------------------------------+
| element 0                    |
+------------------------------+
| element 1                    |
+------------------------------+
| ...                          |
+------------------------------+
| len                          |
+------------------------------+
| scratch invocation frame     |
+------------------------------+ <- env_end
| metadata: array env size     |
| metadata: total heap size    |
| metadata: scratch size       |
+------------------------------+
```

Variadic lowering flow:

- inspect callee signature
  - find the single `...` parameter
  - split arguments into prefix, variadic slice, and suffix
- build packed payload
  - write each variadic element
    - if it is word-sized, write one slot
    - if it is a closure, write its `env_end` pointer
  - write the element count
  - reserve scratch space for later callback invocation
  - write metadata needed by array helpers and release helpers
- rewrite call
  - replace the variadic slice with `items`
  - set the packed payload's unwrapper metadata to `internal_array_str`
  - represent `items` by the payload's `env_end` pointer
- when `items` executes
  - call the user continuation with `len` and `nth`
  - when `nth` executes
    - read index
    - if index is in bounds
      - load element
      - jump to `one(element)`
    - otherwise
      - jump to `none()`

## Closure Affinity Lowering

compile-direct implements closure affinity with mutable heap closure objects plus
conservative deep cloning.

Each closure-typed runtime value is the `env_end` pointer of a mutable heap
object. Currying a local closure always deep-clones that closure, writes the
arguments into the clone, and yields the clone's `env_end` pointer. It does not
reuse the source closure when that curry is its sole use.

A closure value is counted as used when its pointer is read by a CPS step:

- currying it
- passing it to a continuation
- storing it
- forwarding it

Pure renaming without duplication does not count as a new use.

Lowering responsibilities:

- track remaining uses of each closure value
- deep-clone a local closure before every curry
- when storing a closure argument into that clone, use its remaining-use count
  to decide whether the argument also needs a deep clone
- decrement remaining-use counts as uses are consumed

Deep cloning is implemented through a runtime helper reachable from the closure
metadata. It allocates a new closure object, copies the environment, recursively
clones curried inner closures, and preserves the `num_remaining` state.

Closure currying flow:

- lower `dst: src(args...)`
  - count this use of `src`
  - count each argument use
  - if `src` is a known function
    - allocate a new closure for `dst`
    - store supplied arguments
    - record the remaining signature
  - if `src` is a local closure with remaining parameters
    - deep-clone `src` into `dst`
    - write supplied arguments into the cloned payload
    - for each closure argument
      - if that argument has another live use
        - deep-clone the argument before storing it
      - otherwise
        - store the argument directly
    - update `num_remaining`

Deep-clone flow:

- call clone helper from closure metadata
  - allocate a new closure object
  - copy payload and metadata
  - walk curried inner closure fields
    - recursively deep-clone each live inner closure
  - preserve `num_remaining`
  - return the new `env_end` pointer

Example 1:

```af
foo: (p0: int, p1: closure) {
     bar: p1(1, 2)
     k(bar)
}
```

`bar` receives a deep clone of `p1` even though `p1` has no later independent
use.

Example 2:

```af
foo: (p0: int, p1: closure) {
     bar: p1(1, 2)
     baz: p1(3, 4)
     k(bar, baz)
}
```

Both currying paths deep-clone `p1`, so `bar` and `baz` do not overwrite the
same closure state.

Example 3:

```af
qux: (p0: int){...}
foo: (p0: int, p1: closure) {
     bar: p1(1, 2)
     baz: qux(3, 4)
     k(bar, baz)
}
```

`bar` deep-clones `p1`; `baz` allocates a new closure for `qux`.

Example 4:

```af
qux: (p0: int){...}
foo: (p0: int, p1: closure) {
     baz: qux(1, 2)
     k(baz, baz)
}
```

One argument must receive a deep clone so both argument positions respect
affine closure behavior.
