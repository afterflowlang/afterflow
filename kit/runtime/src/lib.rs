#![cfg_attr(not(any(test, debug_assertions)), no_std)]

#[cfg(not(any(test, debug_assertions)))]
use core::panic::PanicInfo;

#[cfg(not(any(test, debug_assertions)))]
#[panic_handler]
fn panic(_info: &PanicInfo<'_>) -> ! {
    loop {
        core::hint::spin_loop();
    }
}
