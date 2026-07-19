# freestanding-runtime

`freestanding-runtime` provides shared process-level support for Rust static
archives linked into freestanding programs. It currently owns the panic
handler used by the formatting and math archives.

Keeping the handler in a separate crate lets a final static link select one
copy even when several archives depend on it. A panic spins because an Afterflow
binary has no operating-system runtime, unwinder, standard error stream, or
recovery boundary.
