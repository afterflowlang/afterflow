//! Synchronous transport and interoperable types for language servers.

#![forbid(unsafe_code)]

pub use lsp_server::{
    Connection, ErrorCode, Message, Notification, Request, RequestId, Response, ResponseError,
};
pub use lsp_types as types;
pub use serde::{de::DeserializeOwned, Serialize};
pub use serde_json::{from_value, to_value, Value};
