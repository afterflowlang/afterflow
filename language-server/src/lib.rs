//! Language-server support for Afterflow editors.

#![forbid(unsafe_code)]

mod analysis;
mod document;
mod server;

pub use server::{run, Error};
