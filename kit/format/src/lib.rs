#![cfg_attr(not(any(test, debug_assertions)), no_std)]

use core::fmt::{self, Write};

#[cfg(not(any(test, debug_assertions)))]
use freestanding_runtime as _;

const CAPACITY: usize = 64;

#[cfg(not(any(test, debug_assertions)))]
/// Copies `count` bytes from `source` to `destination`.
///
/// # Safety
///
/// `source` must be readable and `destination` writable for `count` bytes. The
/// regions must not overlap, and both pointers must satisfy their allocation's
/// provenance requirements.
#[no_mangle]
pub unsafe extern "C" fn memcpy(destination: *mut u8, source: *const u8, count: usize) -> *mut u8 {
    // SAFETY: The caller provides valid, non-overlapping regions for the full byte count.
    unsafe {
        for idx in 0..count {
            let value = core::ptr::read_volatile(source.add(idx));
            core::ptr::write_volatile(destination.add(idx), value);
        }
    }
    destination
}

#[cfg(not(any(test, debug_assertions)))]
/// Writes `count` copies of `value` to `destination`.
///
/// # Safety
///
/// `destination` must be writable for `count` bytes and satisfy its
/// allocation's provenance requirements.
#[no_mangle]
pub unsafe extern "C" fn memset(destination: *mut u8, value: i32, count: usize) -> *mut u8 {
    // SAFETY: The caller provides a valid destination region for the full byte count.
    unsafe {
        for idx in 0..count {
            core::ptr::write_volatile(destination.add(idx), value as u8);
        }
    }
    destination
}

struct Buffer {
    bytes: [u8; CAPACITY],
    len: usize,
}

impl Buffer {
    fn new() -> Self {
        Self {
            bytes: [0; CAPACITY],
            len: 0,
        }
    }
}

impl Write for Buffer {
    fn write_str(&mut self, value: &str) -> fmt::Result {
        let end = self.len.checked_add(value.len()).ok_or(fmt::Error)?;
        let destination = self.bytes.get_mut(self.len..end).ok_or(fmt::Error)?;
        destination.copy_from_slice(value.as_bytes());
        self.len = end;
        Ok(())
    }
}

fn format_f64(value: f64) -> Buffer {
    let mut output = Buffer::new();
    if write!(&mut output, "{value:?}").is_err() {
        output.len = 0;
    }
    output
}

#[no_mangle]
pub extern "C" fn freestanding_format_f64_len(value: f64) -> usize {
    format_f64(value).len
}

#[no_mangle]
pub extern "C" fn freestanding_format_f64_nth(value: f64, idx: usize) -> u8 {
    format_f64(value)
        .bytes
        .get(idx)
        .copied()
        .unwrap_or_default()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn rendered(value: f64) -> String {
        let len = freestanding_format_f64_len(value);
        (0..len)
            .map(|idx| freestanding_format_f64_nth(value, idx) as char)
            .collect()
    }

    #[test]
    fn formats_finite_values() {
        assert_eq!(rendered(40.0), "40.0");
        assert_eq!(rendered(12.5), "12.5");
        assert_eq!(rendered(-0.0), "-0.0");
        assert_eq!(rendered(f64::MAX), format!("{:?}", f64::MAX));
        assert_eq!(
            rendered(f64::MIN_POSITIVE),
            format!("{:?}", f64::MIN_POSITIVE)
        );
    }

    #[test]
    fn formats_special_values() {
        assert_eq!(rendered(f64::INFINITY), "inf");
        assert_eq!(rendered(f64::NEG_INFINITY), "-inf");
        assert_eq!(rendered(f64::NAN), "NaN");
    }

    #[test]
    fn out_of_bounds_byte_is_zero() {
        assert_eq!(freestanding_format_f64_nth(1.0, usize::MAX), 0);
    }
}
