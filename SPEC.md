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

HIR wraps builtins in lambdas so builtins passed as values execute with the
expected structural signature instead of remaining curried aliases.

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
  - move the allocation when the source has no later use, otherwise deep-clone it
  - write supplied arguments into the selected allocation's remaining slots
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

## String and Byte Descriptor Representation

Runtime `str` and `bytes` values are one-word pointers to immutable
descriptors. Dynamic descriptors own the mapping containing their data,
terminating NUL, and descriptor. Literal descriptors use zero ownership
metadata, so cloning and release are no-ops for static data.

```txt
+  0: data pointer
+  8: byte length
+ 16: owned mapping base, or zero for static data
+ 24: owned mapping size, or zero for static data
```

An affine descriptor move reuses the pointer. A repeated use clones the data
and descriptor into an independent mapping. Descriptor release reads the exact
mapping base and size from the final two words and calls `munmap`.

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

Closure environments and dynamic descriptors are allocated with `mmap` and
released with `munmap`.

Because functions tail-jump and do not return, a function can know when a
heap-owned parameter is no longer needed. Before an invocation, compile-direct moves the
selected target and arguments to the next function and releases every owned
value that is not transferred.

Release decision flow:

- before lowering an invocation
  - start with closure, dynamic `str`, and dynamic `bytes` values still owned by
    the current function
  - move the invocation target and arguments out of that set
  - recursively release every value still left
    - closure release recursively releases filled owned fields, then its
      environment
    - descriptor release unmaps its owned mapping
  - conditional builtins release the unchosen continuation before entering the
    selected continuation

This rule is independent of the shape of the control-flow graph. A tail cycle
such as `a -> b -> c -> a` transfers the current ownership set around the cycle
and does not retain ownership sets from previous iterations.

## Closure Affinity Lowering

compile-direct implements closure affinity with mutable heap closure objects, ownership
moves, and deep cloning only at divergent uses.

Each closure-typed runtime value is the `env_end` pointer of a mutable heap
object. The full payload, including every argument slot, is allocated when the
closure is created. Currying fills those reserved slots. If the curry is the
source's last use, the source allocation moves to the result. If the source has
another live use, it is deep-cloned before any slot is written, so an earlier
curry cannot be corrupted by a later, different curry.

A closure value is counted as used when its pointer is read by a CPS step:

- currying it
- passing it to a continuation
- storing it
- forwarding it

Pure renaming without duplication does not count as a new use.

Lowering responsibilities:

- track remaining uses of each closure value
- move a local closure on its last curry and deep-clone it before an earlier
  divergent curry
- when storing a closure argument into that clone, use its remaining-use count
  to decide whether the argument also needs a deep clone
- decrement remaining-use counts as uses are consumed

Deep cloning is implemented through a runtime helper reachable from the closure
metadata. It allocates a new closure object, copies the environment, recursively
clones curried inner closures, and preserves the `num_remaining` state.

Closure currying flow:

- lower a curried definition such as `dst: src(a, b)`
  - count this use of `src`
  - count each argument use
  - if `src` is a known function
    - allocate a new closure for `dst`
    - store supplied arguments
    - record the remaining signature
  - if `src` is a local closure with remaining parameters
    - if `src` has another live use
      - deep-clone `src` into `dst`
    - otherwise
      - move `src` to `dst`
    - write supplied arguments into `dst`'s payload
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

Ownership of `p1` moves to `bar`, so no allocation or clone is needed.

Example 2:

```af
foo: (p0: int, p1: closure) {
     bar: p1(1, 2)
     baz: p1(3, 4)
     k(bar, baz)
}
```

The first curry deep-clones `p1` for `bar` because the source remains live. The
last curry moves the source to `baz`. The two results cannot overwrite the same
closure state.

Example 3:

```af
qux: (p0: int){}
foo: (p0: int, p1: closure) {
     bar: p1(1, 2)
     baz: qux(3, 4)
     k(bar, baz)
}
```

`bar` takes ownership of `p1`, and `baz` allocates a new closure for `qux`.

Example 4:

```af
qux: (p0: int){}
foo: (p0: int, p1: closure) {
     baz: qux(1, 2)
     k(baz, baz)
}
```

One argument must receive a deep clone so both argument positions respect
affine closure behavior.
