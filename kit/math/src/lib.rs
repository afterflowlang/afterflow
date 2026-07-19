#![cfg_attr(not(any(test, debug_assertions)), no_std)]

#[cfg(not(any(test, debug_assertions)))]
use freestanding_runtime as _;

macro_rules! export_unary_f64 {
    ($($export:ident => $function:path),+ $(,)?) => {
        $(
            #[no_mangle]
            pub extern "C" fn $export(value: f64) -> f64 {
                $function(value)
            }
        )+
    };
}

macro_rules! export_binary_f64 {
    ($($export:ident => $function:path),+ $(,)?) => {
        $(
            #[no_mangle]
            pub extern "C" fn $export(a: f64, b: f64) -> f64 {
                $function(a, b)
            }
        )+
    };
}

export_unary_f64! {
    freestanding_math_fabs => libm::fabs,
    freestanding_math_acos => libm::acos,
    freestanding_math_acosh => libm::acosh,
    freestanding_math_asin => libm::asin,
    freestanding_math_asinh => libm::asinh,
    freestanding_math_atan => libm::atan,
    freestanding_math_atanh => libm::atanh,
    freestanding_math_cbrt => libm::cbrt,
    freestanding_math_ceil => libm::ceil,
    freestanding_math_cos => libm::cos,
    freestanding_math_cosh => libm::cosh,
    freestanding_math_exp => libm::exp,
    freestanding_math_exp2 => libm::exp2,
    freestanding_math_expm1 => libm::expm1,
    freestanding_math_floor => libm::floor,
    freestanding_math_log => libm::log,
    freestanding_math_log10 => libm::log10,
    freestanding_math_log1p => libm::log1p,
    freestanding_math_log2 => libm::log2,
    freestanding_math_round => libm::round,
    freestanding_math_sin => libm::sin,
    freestanding_math_sinh => libm::sinh,
    freestanding_math_sqrt => libm::sqrt,
    freestanding_math_tan => libm::tan,
    freestanding_math_tanh => libm::tanh,
    freestanding_math_trunc => libm::trunc,
}

export_binary_f64! {
    freestanding_math_atan2 => libm::atan2,
    freestanding_math_copysign => libm::copysign,
    freestanding_math_fdim => libm::fdim,
    freestanding_math_fmax => libm::fmax,
    freestanding_math_fmin => libm::fmin,
    freestanding_math_fmod => libm::fmod,
    freestanding_math_hypot => libm::hypot,
    freestanding_math_nextafter => libm::nextafter,
    freestanding_math_pow => libm::pow,
    freestanding_math_remainder => libm::remainder,
}

#[no_mangle]
pub extern "C" fn freestanding_math_ldexp(value: f64, exponent: i32) -> f64 {
    libm::ldexp(value, exponent)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sine_uses_full_range_reduction() {
        let actual = freestanding_math_sin(1.0e20);
        let expected = -0.6452512852657808;
        assert!((actual - expected).abs() < 1.0e-15);
    }

    #[test]
    fn sine_preserves_ieee_special_values() {
        assert_eq!(freestanding_math_sin(-0.0).to_bits(), (-0.0_f64).to_bits());
        assert!(freestanding_math_sin(f64::INFINITY).is_nan());
        assert!(freestanding_math_sin(f64::NAN).is_nan());
    }

    #[test]
    fn power_matches_binary64_edge_cases() {
        assert_eq!(freestanding_math_pow(2.0, 8.0), 256.0);
        assert_eq!(freestanding_math_pow(0.0, 0.0), 1.0);
        assert_eq!(freestanding_math_pow(f64::NAN, 0.0), 1.0);
        assert!(freestanding_math_pow(-1.0, 0.5).is_nan());
    }

    #[test]
    fn logarithms_match_rust_style_domains() {
        let arbitrary_base = freestanding_math_log(25.0) / freestanding_math_log(5.0);
        assert!((arbitrary_base - 2.0).abs() < 1.0e-15);
        assert!((freestanding_math_log(core::f64::consts::E) - 1.0).abs() < 1.0e-15);
        assert_eq!(freestanding_math_log(0.0), f64::NEG_INFINITY);
        assert!(freestanding_math_log(-1.0).is_nan());
    }

    #[test]
    fn common_surface_uses_the_backing_signatures() {
        assert_eq!(freestanding_math_cos(0.0), 1.0);
        assert_eq!(freestanding_math_sqrt(9.0), 3.0);
        assert_eq!(freestanding_math_hypot(3.0, 4.0), 5.0);
        assert_eq!(freestanding_math_ldexp(0.5, 4), 8.0);
    }
}
