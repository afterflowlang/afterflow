use crate::hir::{self, FixedIntKind, SigItem, SigKind, Signature};
use std::collections::BTreeSet;

// TODO: Needed?
#[derive(Debug)]
pub enum BuiltinSpec {
    Function(hir::Signature),
    Type(hir::SigKind),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum NativeScalar {
    F64,
    I32,
    UInt,
    U8,
}

impl NativeScalar {
    fn sig_kind(self) -> SigKind {
        match self {
            NativeScalar::F64 => SigKind::F64,
            NativeScalar::I32 => SigKind::FixedInt(FixedIntKind::signed(32)),
            NativeScalar::UInt => SigKind::UInt,
            NativeScalar::U8 => SigKind::FixedInt(FixedIntKind::unsigned(8)),
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct NativeParam {
    pub name: &'static str,
    pub kind: NativeScalar,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct NativeFunction {
    pub name: &'static str,
    pub symbol: &'static str,
    pub params: &'static [NativeParam],
    pub result: NativeScalar,
}

macro_rules! unary_f64 {
    ($name:literal, $symbol:literal) => {
        NativeFunction {
            name: $name,
            symbol: $symbol,
            params: &[NativeParam {
                name: "value",
                kind: NativeScalar::F64,
            }],
            result: NativeScalar::F64,
        }
    };
}

macro_rules! binary_f64 {
    ($name:literal, $symbol:literal, $a:literal, $b:literal) => {
        NativeFunction {
            name: $name,
            symbol: $symbol,
            params: &[
                NativeParam {
                    name: $a,
                    kind: NativeScalar::F64,
                },
                NativeParam {
                    name: $b,
                    kind: NativeScalar::F64,
                },
            ],
            result: NativeScalar::F64,
        }
    };
}

pub const NATIVE_MATH_FUNCTIONS: &[NativeFunction] = &[
    unary_f64!("fabs_f64", "freestanding_math_fabs"),
    unary_f64!("acos_f64", "freestanding_math_acos"),
    unary_f64!("acosh_f64", "freestanding_math_acosh"),
    unary_f64!("asin_f64", "freestanding_math_asin"),
    unary_f64!("asinh_f64", "freestanding_math_asinh"),
    unary_f64!("atan_f64", "freestanding_math_atan"),
    unary_f64!("atanh_f64", "freestanding_math_atanh"),
    unary_f64!("cbrt_f64", "freestanding_math_cbrt"),
    unary_f64!("ceil_f64", "freestanding_math_ceil"),
    unary_f64!("cos_f64", "freestanding_math_cos"),
    unary_f64!("cosh_f64", "freestanding_math_cosh"),
    unary_f64!("exp_f64", "freestanding_math_exp"),
    unary_f64!("exp2_f64", "freestanding_math_exp2"),
    unary_f64!("expm1_f64", "freestanding_math_expm1"),
    unary_f64!("floor_f64", "freestanding_math_floor"),
    unary_f64!("log_f64", "freestanding_math_log"),
    unary_f64!("log10_f64", "freestanding_math_log10"),
    unary_f64!("log1p_f64", "freestanding_math_log1p"),
    unary_f64!("log2_f64", "freestanding_math_log2"),
    unary_f64!("round_f64", "freestanding_math_round"),
    unary_f64!("sin_f64", "freestanding_math_sin"),
    unary_f64!("sinh_f64", "freestanding_math_sinh"),
    unary_f64!("sqrt_f64", "freestanding_math_sqrt"),
    unary_f64!("tan_f64", "freestanding_math_tan"),
    unary_f64!("tanh_f64", "freestanding_math_tanh"),
    unary_f64!("trunc_f64", "freestanding_math_trunc"),
    binary_f64!("atan2_f64", "freestanding_math_atan2", "y", "x"),
    binary_f64!(
        "copysign_f64",
        "freestanding_math_copysign",
        "magnitude",
        "sign"
    ),
    binary_f64!("fdim_f64", "freestanding_math_fdim", "a", "b"),
    binary_f64!("fmax_f64", "freestanding_math_fmax", "a", "b"),
    binary_f64!("fmin_f64", "freestanding_math_fmin", "a", "b"),
    binary_f64!("fmod_f64", "freestanding_math_fmod", "dividend", "divisor"),
    binary_f64!("hypot_f64", "freestanding_math_hypot", "x", "y"),
    binary_f64!(
        "nextafter_f64",
        "freestanding_math_nextafter",
        "value",
        "toward"
    ),
    binary_f64!("pow_f64", "freestanding_math_pow", "base", "exponent"),
    binary_f64!(
        "remainder_f64",
        "freestanding_math_remainder",
        "dividend",
        "divisor"
    ),
    NativeFunction {
        name: "ldexp_f64_i32",
        symbol: "freestanding_math_ldexp",
        params: &[
            NativeParam {
                name: "value",
                kind: NativeScalar::F64,
            },
            NativeParam {
                name: "exponent",
                kind: NativeScalar::I32,
            },
        ],
        result: NativeScalar::F64,
    },
];

pub const NATIVE_FORMAT_FUNCTIONS: &[NativeFunction] = &[
    NativeFunction {
        name: "format_f64_len",
        symbol: "freestanding_format_f64_len",
        params: &[NativeParam {
            name: "value",
            kind: NativeScalar::F64,
        }],
        result: NativeScalar::UInt,
    },
    NativeFunction {
        name: "format_f64_nth",
        symbol: "freestanding_format_f64_nth",
        params: &[
            NativeParam {
                name: "value",
                kind: NativeScalar::F64,
            },
            NativeParam {
                name: "idx",
                kind: NativeScalar::UInt,
            },
        ],
        result: NativeScalar::U8,
    },
];

fn native_function(name: &str) -> Option<&'static NativeFunction> {
    NATIVE_MATH_FUNCTIONS
        .iter()
        .chain(NATIVE_FORMAT_FUNCTIONS)
        .find(|function| function.name == name)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Builtin {
    Add,
    Sub,
    Mul,
    Div,
    AddF64,
    SubF64,
    MulF64,
    DivF64,
    Native(&'static NativeFunction),
    AddBits(u16),
    SubBits(u16),
    MulBits(u16),
    DivBits {
        bit_width: u16,
        is_signed: bool,
    },
    ConvertFixed {
        from: FixedIntKind,
        to: FixedIntKind,
    },
    RuneFromU32,
    U32FromRune,
    StrRuneLen,
    StrRuneNth,
    StrFromUtf8,
    BytesLen,
    BytesNth,
    BytesFromStr,
    BytesBuild,
    AddUInt,
    SubUInt,
    EqUInt,
    LtUInt,
    EqBits(u16),
    U8FromInt,
    EqInt,
    EqStr,
    Lt,
    Gt,
    Write,
    FileRead,
    Exit,
    CompileError,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AirRoute {
    Instruction,
    Conditional,
    Call,
    RuntimeFallback,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ComptimeRoute {
    Evaluate,
    Residual,
}

struct BuiltinType {
    name: &'static str,
    kind: SigKind,
}

#[derive(Clone, Copy)]
struct BuiltinFunction {
    name: &'static str,
    builtin: Builtin,
    air_route: AirRoute,
    comptime_route: ComptimeRoute,
}

macro_rules! builtin_function {
    ($name:literal, $builtin:expr, $air_route:ident, $comptime_route:ident) => {
        BuiltinFunction {
            name: $name,
            builtin: $builtin,
            air_route: AirRoute::$air_route,
            comptime_route: ComptimeRoute::$comptime_route,
        }
    };
}

macro_rules! builtin_type {
    ($name:literal, $kind:expr) => {
        BuiltinType {
            name: $name,
            kind: $kind,
        }
    };
}

macro_rules! fixed_division_builtin {
    ($name:literal, $bit_width:literal, $is_signed:literal) => {
        builtin_function!(
            $name,
            Builtin::DivBits {
                bit_width: $bit_width,
                is_signed: $is_signed,
            },
            Instruction,
            Residual
        )
    };
}

const BUILTIN_TYPES: &[BuiltinType] = &[
    builtin_type!("byte", SigKind::Byte),
    builtin_type!("int", SigKind::Int),
    builtin_type!("uint", SigKind::UInt),
    builtin_type!("rune", SigKind::Rune),
    builtin_type!("bytes", SigKind::Bytes),
    builtin_type!("str", SigKind::Str),
    builtin_type!("f64", SigKind::F64),
    builtin_type!("b8", SigKind::FixedInt(FixedIntKind::bits(8))),
    builtin_type!("i8", SigKind::FixedInt(FixedIntKind::signed(8))),
    builtin_type!("u8", SigKind::FixedInt(FixedIntKind::unsigned(8))),
    builtin_type!("b32", SigKind::FixedInt(FixedIntKind::bits(32))),
    builtin_type!("i32", SigKind::FixedInt(FixedIntKind::signed(32))),
    builtin_type!("u32", SigKind::FixedInt(FixedIntKind::unsigned(32))),
    builtin_type!("b64", SigKind::FixedInt(FixedIntKind::bits(64))),
    builtin_type!("i64", SigKind::FixedInt(FixedIntKind::signed(64))),
    builtin_type!("u64", SigKind::FixedInt(FixedIntKind::unsigned(64))),
    builtin_type!("b128", SigKind::FixedInt(FixedIntKind::bits(128))),
    builtin_type!("i128", SigKind::FixedInt(FixedIntKind::signed(128))),
    builtin_type!("u128", SigKind::FixedInt(FixedIntKind::unsigned(128))),
];

const BUILTIN_FUNCTIONS: &[BuiltinFunction] = &[
    builtin_function!("add", Builtin::Add, Instruction, Evaluate),
    builtin_function!("sub", Builtin::Sub, Instruction, Evaluate),
    builtin_function!("mul", Builtin::Mul, Instruction, Evaluate),
    builtin_function!("div", Builtin::Div, Instruction, Residual),
    builtin_function!("add_f64", Builtin::AddF64, Instruction, Residual),
    builtin_function!("sub_f64", Builtin::SubF64, Instruction, Residual),
    builtin_function!("mul_f64", Builtin::MulF64, Instruction, Residual),
    builtin_function!("div_f64", Builtin::DivF64, Instruction, Residual),
    builtin_function!("add_b8", Builtin::AddBits(8), Instruction, Evaluate),
    builtin_function!("add_b32", Builtin::AddBits(32), Instruction, Evaluate),
    builtin_function!("add_b64", Builtin::AddBits(64), Instruction, Evaluate),
    builtin_function!("add_b128", Builtin::AddBits(128), Instruction, Evaluate),
    builtin_function!("sub_b8", Builtin::SubBits(8), Instruction, Evaluate),
    builtin_function!("sub_b32", Builtin::SubBits(32), Instruction, Evaluate),
    builtin_function!("sub_b64", Builtin::SubBits(64), Instruction, Evaluate),
    builtin_function!("sub_b128", Builtin::SubBits(128), Instruction, Evaluate),
    builtin_function!("mul_b8", Builtin::MulBits(8), Instruction, Evaluate),
    builtin_function!("mul_b32", Builtin::MulBits(32), Instruction, Evaluate),
    builtin_function!("mul_b64", Builtin::MulBits(64), Instruction, Evaluate),
    builtin_function!("mul_b128", Builtin::MulBits(128), Instruction, Evaluate),
    fixed_division_builtin!("div_signed_b8", 8, true),
    fixed_division_builtin!("div_unsigned_b8", 8, false),
    fixed_division_builtin!("div_signed_b32", 32, true),
    fixed_division_builtin!("div_unsigned_b32", 32, false),
    fixed_division_builtin!("div_signed_b64", 64, true),
    fixed_division_builtin!("div_unsigned_b64", 64, false),
    fixed_division_builtin!("div_signed_b128", 128, true),
    fixed_division_builtin!("div_unsigned_b128", 128, false),
    builtin_function!("rune_from_u32", Builtin::RuneFromU32, Instruction, Evaluate),
    builtin_function!("u32_from_rune", Builtin::U32FromRune, Instruction, Evaluate),
    builtin_function!("str_rune_len", Builtin::StrRuneLen, Instruction, Evaluate),
    builtin_function!("str_rune_nth", Builtin::StrRuneNth, Instruction, Evaluate),
    builtin_function!("str_from_utf8", Builtin::StrFromUtf8, Instruction, Evaluate),
    builtin_function!(
        "bytes_descriptor_len",
        Builtin::BytesLen,
        Instruction,
        Evaluate
    ),
    builtin_function!("__bytes_len", Builtin::BytesLen, Instruction, Evaluate),
    builtin_function!(
        "__bytes_len_comptime",
        Builtin::BytesLen,
        Instruction,
        Evaluate
    ),
    builtin_function!("bytes_nth", Builtin::BytesNth, Instruction, Evaluate),
    builtin_function!(
        "bytes_from_str",
        Builtin::BytesFromStr,
        Instruction,
        Evaluate
    ),
    builtin_function!("bytes_build", Builtin::BytesBuild, Call, Residual),
    builtin_function!("add_uint", Builtin::AddUInt, Instruction, Evaluate),
    builtin_function!("sub_uint", Builtin::SubUInt, Instruction, Evaluate),
    builtin_function!("eq_uint", Builtin::EqUInt, Conditional, Evaluate),
    builtin_function!("lt_uint", Builtin::LtUInt, Conditional, Evaluate),
    builtin_function!("eq_b8", Builtin::EqBits(8), Conditional, Evaluate),
    builtin_function!("u8_from_int", Builtin::U8FromInt, Instruction, Evaluate),
    builtin_function!("eq_int", Builtin::EqInt, Conditional, Evaluate),
    builtin_function!("eq_str", Builtin::EqStr, Conditional, Evaluate),
    builtin_function!("lt", Builtin::Lt, Conditional, Evaluate),
    builtin_function!("gt", Builtin::Gt, Conditional, Evaluate),
    builtin_function!("write", Builtin::Write, Call, Residual),
    builtin_function!("file_read", Builtin::FileRead, Call, Residual),
    builtin_function!("exit", Builtin::Exit, Call, Residual),
    builtin_function!(
        "compile_error",
        Builtin::CompileError,
        RuntimeFallback,
        Evaluate
    ),
];

impl Builtin {
    pub fn from_name(name: &str) -> Option<Self> {
        BUILTIN_FUNCTIONS
            .iter()
            .find(|function| function.name == name)
            .map(|function| function.builtin)
            .or_else(|| native_function(name).map(Builtin::Native))
            .or_else(|| fixed_conversion_from_name(name))
    }

    pub fn name(self) -> &'static str {
        match self {
            Builtin::Add => "add",
            Builtin::Sub => "sub",
            Builtin::Mul => "mul",
            Builtin::Div => "div",
            Builtin::AddF64 => "add_f64",
            Builtin::SubF64 => "sub_f64",
            Builtin::MulF64 => "mul_f64",
            Builtin::DivF64 => "div_f64",
            Builtin::Native(function) => function.name,
            Builtin::AddBits(bit_width) => fixed_bit_op_name("add", bit_width),
            Builtin::SubBits(bit_width) => fixed_bit_op_name("sub", bit_width),
            Builtin::MulBits(bit_width) => fixed_bit_op_name("mul", bit_width),
            Builtin::DivBits {
                bit_width,
                is_signed,
            } => fixed_div_name(bit_width, is_signed),
            Builtin::ConvertFixed { from, to } => conversion_name(from, to),
            Builtin::RuneFromU32 => "rune_from_u32",
            Builtin::U32FromRune => "u32_from_rune",
            Builtin::StrRuneLen => "str_rune_len",
            Builtin::StrRuneNth => "str_rune_nth",
            Builtin::StrFromUtf8 => "str_from_utf8",
            Builtin::BytesLen => "bytes_len",
            Builtin::BytesNth => "bytes_nth",
            Builtin::BytesFromStr => "bytes_from_str",
            Builtin::BytesBuild => "bytes_build",
            Builtin::AddUInt => "add_uint",
            Builtin::SubUInt => "sub_uint",
            Builtin::EqUInt => "eq_uint",
            Builtin::LtUInt => "lt_uint",
            Builtin::EqBits(8) => "eq_b8",
            Builtin::EqBits(bit_width) => panic!("unsupported equality width {bit_width}"),
            Builtin::U8FromInt => "u8_from_int",
            Builtin::EqInt => "eq_int",
            Builtin::EqStr => "eq_str",
            Builtin::Lt => "lt",
            Builtin::Gt => "gt",
            Builtin::Write => "write",
            Builtin::FileRead => "file_read",
            Builtin::Exit => "exit",
            Builtin::CompileError => "compile_error",
        }
    }

    pub fn signature(self) -> Signature {
        match self {
            Builtin::Add | Builtin::Sub | Builtin::Mul => math_binary_sig(SigKind::Int),
            Builtin::Div => div_sig(),
            Builtin::AddF64 | Builtin::SubF64 | Builtin::MulF64 | Builtin::DivF64 => {
                math_binary_sig(SigKind::F64)
            }
            Builtin::Native(function) => native_function_sig(function),
            Builtin::AddBits(bit_width)
            | Builtin::SubBits(bit_width)
            | Builtin::MulBits(bit_width) => {
                math_binary_sig(SigKind::FixedInt(FixedIntKind::bits(bit_width)))
            }
            Builtin::DivBits { bit_width, .. } => div_fixed_sig(bit_width),
            Builtin::ConvertFixed { from, to } => convert_sig(from, to),
            Builtin::RuneFromU32 => sig_from_items(vec![
                sig_item("value", SigKind::FixedInt(FixedIntKind::unsigned(32))),
                sig_item("invalid", SigKind::tuple([])),
                sig_item("ok", SigKind::tuple([SigKind::Rune])),
            ]),
            Builtin::U32FromRune => sig_from_items(vec![
                sig_item("value", SigKind::Rune),
                sig_item(
                    "ok",
                    SigKind::tuple([SigKind::FixedInt(FixedIntKind::unsigned(32))]),
                ),
            ]),
            Builtin::StrRuneLen => sig_from_items(vec![
                sig_item("value", SigKind::Str),
                sig_item("ok", SigKind::tuple([SigKind::UInt])),
            ]),
            Builtin::StrRuneNth => sig_from_items(vec![
                sig_item("value", SigKind::Str),
                sig_item("idx", SigKind::UInt),
                sig_item("empty", SigKind::tuple([])),
                sig_item("one", SigKind::tuple([SigKind::Rune])),
            ]),
            Builtin::StrFromUtf8 => sig_from_items(vec![
                sig_item("value", SigKind::Bytes),
                sig_item("invalid", SigKind::tuple([])),
                sig_item("ok", SigKind::tuple([SigKind::Str])),
            ]),
            Builtin::BytesLen => sig_from_items(vec![
                sig_item("value", SigKind::Bytes),
                sig_item("ok", SigKind::tuple([SigKind::UInt])),
            ]),
            Builtin::BytesNth => sig_from_items(vec![
                sig_item("value", SigKind::Bytes),
                sig_item("idx", SigKind::UInt),
                sig_item("empty", SigKind::tuple([])),
                sig_item(
                    "one",
                    SigKind::tuple([SigKind::FixedInt(FixedIntKind::unsigned(8))]),
                ),
            ]),
            Builtin::BytesFromStr => sig_from_items(vec![
                sig_item("value", SigKind::Str),
                sig_item("ok", SigKind::tuple([SigKind::Bytes])),
            ]),
            Builtin::BytesBuild => {
                let nth = tuple_sig(vec![
                    sig_item("idx", SigKind::UInt),
                    sig_item("empty", SigKind::tuple([])),
                    sig_item(
                        "one",
                        SigKind::tuple([SigKind::FixedInt(FixedIntKind::unsigned(8))]),
                    ),
                ]);
                let inspect = tuple_sig(vec![sig_item("l", SigKind::UInt), sig_item("nth", nth)]);
                let source = tuple_sig(vec![sig_item("inspect", inspect)]);
                sig_from_items(vec![
                    sig_item("source", source),
                    sig_item("invalid", SigKind::tuple([])),
                    sig_item("ok", SigKind::tuple([SigKind::Bytes])),
                ])
            }
            Builtin::AddUInt | Builtin::SubUInt => math_binary_sig(SigKind::UInt),
            Builtin::EqUInt | Builtin::LtUInt => comparison_sig(SigKind::UInt),
            Builtin::EqBits(bit_width) => {
                comparison_sig(SigKind::FixedInt(FixedIntKind::bits(bit_width)))
            }
            Builtin::U8FromInt => sig_from_items(vec![
                sig_item("value", SigKind::Int),
                sig_item("invalid", SigKind::tuple([])),
                sig_item(
                    "ok",
                    SigKind::tuple([SigKind::FixedInt(FixedIntKind::unsigned(8))]),
                ),
            ]),
            Builtin::EqInt | Builtin::Lt | Builtin::Gt => comparison_sig(SigKind::Int),
            Builtin::EqStr => comparison_sig(SigKind::Str),
            Builtin::Write => sig_from_items(vec![
                sig_item("value", SigKind::Str),
                sig_item("ok", SigKind::tuple([])),
            ]),
            Builtin::FileRead => sig_from_items(vec![
                sig_item("path", SigKind::Str),
                sig_item("err", SigKind::tuple([])),
                sig_item("ok", SigKind::tuple([SigKind::Bytes])),
            ]),
            Builtin::Exit => sig_from_items(vec![sig_item("code", SigKind::Int)]),
            Builtin::CompileError => sig_from_items(vec![
                sig_item("message", SigKind::Str),
                sig_item("runtime_fallback", SigKind::tuple([])),
            ]),
        }
    }

    pub fn air_route(self) -> AirRoute {
        self.function()
            .map(|function| function.air_route)
            .unwrap_or_else(|| match self {
                Builtin::Native(_) | Builtin::ConvertFixed { .. } => AirRoute::Instruction,
                _ => unreachable!("builtin '{}' is missing from the registry", self.name()),
            })
    }

    pub fn comptime_route(self) -> ComptimeRoute {
        self.function()
            .map(|function| function.comptime_route)
            .unwrap_or_else(|| match self {
                Builtin::Native(_) => ComptimeRoute::Residual,
                Builtin::ConvertFixed { .. } => ComptimeRoute::Evaluate,
                _ => unreachable!("builtin '{}' is missing from the registry", self.name()),
            })
    }

    fn function(self) -> Option<&'static BuiltinFunction> {
        BUILTIN_FUNCTIONS
            .iter()
            .find(|function| function.builtin == self)
    }
}

pub fn get_spec(name: &str) -> Option<BuiltinSpec> {
    if let Some(builtin) = Builtin::from_name(name) {
        return Some(BuiltinSpec::Function(builtin.signature()));
    }
    BUILTIN_TYPES
        .iter()
        .find(|builtin| builtin.name == name)
        .map(|builtin| BuiltinSpec::Type(builtin.kind.clone()))
}

pub fn function_from_name(name: &str) -> Option<Builtin> {
    Builtin::from_name(name)
}

#[cfg(test)]
pub(crate) fn registered_names() -> impl Iterator<Item = &'static str> {
    BUILTIN_TYPES
        .iter()
        .map(|builtin| builtin.name)
        .chain(BUILTIN_FUNCTIONS.iter().map(|builtin| builtin.name))
        .chain(NATIVE_MATH_FUNCTIONS.iter().map(|builtin| builtin.name))
        .chain(NATIVE_FORMAT_FUNCTIONS.iter().map(|builtin| builtin.name))
        .chain(FIXED_CONVERSIONS.iter().map(|(name, _, _)| *name))
}

fn sig_item(name: &str, ty: SigKind) -> SigItem {
    SigItem {
        name: name.to_string(),
        kind: ty,
        is_comptime: false,
    }
}

fn tuple_sig(items: Vec<SigItem>) -> SigKind {
    SigKind::Sig(Signature {
        items,
        generics: BTreeSet::new(),
    })
}

fn sig_from_items(items: Vec<SigItem>) -> Signature {
    Signature {
        items,
        generics: BTreeSet::new(),
    }
}

fn comparison_sig(arg_kind: SigKind) -> Signature {
    sig_from_items(vec![
        sig_item("left", arg_kind.clone()),
        sig_item("right", arg_kind),
        sig_item("ok", SigKind::tuple([])),
        sig_item("err", SigKind::tuple([])),
    ])
}

fn div_sig() -> Signature {
    let ok_sig = tuple_sig(vec![sig_item("res", SigKind::Int)]);
    sig_from_items(vec![
        sig_item("x", SigKind::Int),
        sig_item("y", SigKind::Int),
        sig_item("err", SigKind::tuple([])),
        sig_item("ok", ok_sig),
    ])
}

fn div_fixed_sig(bit_width: u16) -> Signature {
    let kind = SigKind::FixedInt(FixedIntKind::bits(bit_width));
    sig_from_items(vec![
        sig_item("dividend", kind.clone()),
        sig_item("divisor", kind.clone()),
        sig_item("err", SigKind::tuple([])),
        sig_item("ok", SigKind::tuple([kind])),
    ])
}

fn fixed_bit_op_name(op: &str, bit_width: u16) -> &'static str {
    match (op, bit_width) {
        ("add", 8) => "add_b8",
        ("add", 32) => "add_b32",
        ("add", 64) => "add_b64",
        ("add", 128) => "add_b128",
        ("sub", 8) => "sub_b8",
        ("sub", 32) => "sub_b32",
        ("sub", 64) => "sub_b64",
        ("sub", 128) => "sub_b128",
        ("mul", 8) => "mul_b8",
        ("mul", 32) => "mul_b32",
        ("mul", 64) => "mul_b64",
        ("mul", 128) => "mul_b128",
        _ => panic!("unsupported fixed bit operation {op}_b{bit_width}"),
    }
}

fn fixed_div_name(bit_width: u16, is_signed: bool) -> &'static str {
    match (is_signed, bit_width) {
        (true, 8) => "div_signed_b8",
        (false, 8) => "div_unsigned_b8",
        (true, 32) => "div_signed_b32",
        (false, 32) => "div_unsigned_b32",
        (true, 64) => "div_signed_b64",
        (false, 64) => "div_unsigned_b64",
        (true, 128) => "div_signed_b128",
        (false, 128) => "div_unsigned_b128",
        _ => panic!("unsupported fixed division width {bit_width}"),
    }
}

fn conversion_name(from: FixedIntKind, to: FixedIntKind) -> &'static str {
    FIXED_CONVERSIONS
        .iter()
        .find(|(_, candidate_from, candidate_to)| *candidate_from == from && *candidate_to == to)
        .map(|(name, _, _)| *name)
        .unwrap_or_else(|| {
            panic!(
                "unsupported fixed integer conversion from {} to {}",
                from.name(),
                to.name()
            )
        })
}

fn fixed_conversion_from_name(name: &str) -> Option<Builtin> {
    FIXED_CONVERSIONS
        .iter()
        .find(|(candidate, _, _)| *candidate == name)
        .map(|(_, from, to)| Builtin::ConvertFixed {
            from: *from,
            to: *to,
        })
}

const FIXED_CONVERSIONS: [(&str, FixedIntKind, FixedIntKind); 16] = [
    ("b8_from_i8", FixedIntKind::signed(8), FixedIntKind::bits(8)),
    (
        "b8_from_u8",
        FixedIntKind::unsigned(8),
        FixedIntKind::bits(8),
    ),
    ("i8_from_b8", FixedIntKind::bits(8), FixedIntKind::signed(8)),
    (
        "u8_from_b8",
        FixedIntKind::bits(8),
        FixedIntKind::unsigned(8),
    ),
    (
        "b32_from_i32",
        FixedIntKind::signed(32),
        FixedIntKind::bits(32),
    ),
    (
        "b32_from_u32",
        FixedIntKind::unsigned(32),
        FixedIntKind::bits(32),
    ),
    (
        "i32_from_b32",
        FixedIntKind::bits(32),
        FixedIntKind::signed(32),
    ),
    (
        "u32_from_b32",
        FixedIntKind::bits(32),
        FixedIntKind::unsigned(32),
    ),
    (
        "b64_from_i64",
        FixedIntKind::signed(64),
        FixedIntKind::bits(64),
    ),
    (
        "b64_from_u64",
        FixedIntKind::unsigned(64),
        FixedIntKind::bits(64),
    ),
    (
        "i64_from_b64",
        FixedIntKind::bits(64),
        FixedIntKind::signed(64),
    ),
    (
        "u64_from_b64",
        FixedIntKind::bits(64),
        FixedIntKind::unsigned(64),
    ),
    (
        "b128_from_i128",
        FixedIntKind::signed(128),
        FixedIntKind::bits(128),
    ),
    (
        "b128_from_u128",
        FixedIntKind::unsigned(128),
        FixedIntKind::bits(128),
    ),
    (
        "i128_from_b128",
        FixedIntKind::bits(128),
        FixedIntKind::signed(128),
    ),
    (
        "u128_from_b128",
        FixedIntKind::bits(128),
        FixedIntKind::unsigned(128),
    ),
];

fn convert_sig(from: FixedIntKind, to: FixedIntKind) -> Signature {
    sig_from_items(vec![
        sig_item("value", SigKind::FixedInt(from)),
        sig_item("ok", SigKind::tuple([SigKind::FixedInt(to)])),
    ])
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn f64_type_registration() {
        match get_spec("f64") {
            Some(BuiltinSpec::Type(kind)) => assert_eq!(kind, hir::SigKind::F64),
            other => panic!("expected builtin f64 type, got {:?}", other),
        }
    }

    #[test]
    fn byte_type_registration() {
        match get_spec("byte") {
            Some(BuiltinSpec::Type(kind)) => assert_eq!(kind, hir::SigKind::Byte),
            other => panic!("expected builtin byte type, got {:?}", other),
        }
    }

    #[test]
    fn bytes_type_is_distinct_from_str() {
        let bytes = match get_spec("bytes") {
            Some(BuiltinSpec::Type(kind)) => kind,
            other => panic!("expected builtin bytes type, got {:?}", other),
        };
        assert_eq!(bytes, hir::SigKind::Bytes);
        assert_ne!(bytes, hir::SigKind::Str);
    }

    #[test]
    fn uint_type_registration() {
        match get_spec("uint") {
            Some(BuiltinSpec::Type(kind)) => {
                assert_eq!(kind, hir::SigKind::UInt);
                assert_ne!(kind, hir::SigKind::Int);
            }
            other => panic!("expected builtin uint type, got {:?}", other),
        }
    }

    #[test]
    fn rune_type_and_conversion_signatures_are_distinct_from_u32() {
        let rune = match get_spec("rune") {
            Some(BuiltinSpec::Type(kind)) => kind,
            other => panic!("expected builtin rune type, got {:?}", other),
        };
        let u32_kind = SigKind::FixedInt(FixedIntKind::unsigned(32));
        assert_eq!(rune, SigKind::Rune);
        assert_ne!(rune, u32_kind);
        let from_u32 = Builtin::RuneFromU32.signature();
        assert_eq!(from_u32.items[0].kind, u32_kind);
        assert_eq!(from_u32.items[1].kind, SigKind::tuple([]));
        assert_eq!(from_u32.items[2].kind, SigKind::tuple([SigKind::Rune]));

        let to_u32 = Builtin::U32FromRune.signature();
        assert_eq!(to_u32.items[0].kind, SigKind::Rune);
        assert_eq!(to_u32.items[1].kind, SigKind::tuple([u32_kind]));
    }

    #[test]
    fn f64_math_signature_contains_f64() {
        let builtin = Builtin::from_name("add_f64").expect("add_f64 builtin should exist");
        let sig = builtin.signature();
        assert_eq!(sig.items.len(), 3);
        assert_eq!(sig.items[0].kind, SigKind::F64);
        assert_eq!(sig.items[1].kind, SigKind::F64);

        let tuple = match &sig.items[2].kind {
            SigKind::Sig(inner) => inner,
            other => panic!("expected tuple for ok, got {:?}", other),
        };
        assert_eq!(tuple.items.len(), 1);
        assert_eq!(tuple.items[0].kind, SigKind::F64);
    }

    #[test]
    fn builtin_variants_exist_for_float_ops() {
        assert!(Builtin::from_name("sub_f64").is_some());
        assert!(Builtin::from_name("mul_f64").is_some());
        assert!(Builtin::from_name("div_f64").is_some());
        assert!(Builtin::from_name("sin_f64").is_some());
        assert!(Builtin::from_name("pow_f64").is_some());
        assert!(Builtin::from_name("log_f64").is_some());
        assert!(Builtin::from_name("ln_f64").is_none());
        assert!(Builtin::from_name("addf64").is_none());
    }

    #[test]
    fn staging_has_no_runtime_boundary_builtin() {
        assert!(Builtin::from_name("runtime").is_none());
        assert!(!Builtin::CompileError.signature().items[0].is_comptime);
    }

    #[test]
    fn native_math_signatures_match_the_linked_functions() {
        let names = NATIVE_MATH_FUNCTIONS
            .iter()
            .map(|function| function.name)
            .collect::<BTreeSet<_>>();
        let symbols = NATIVE_MATH_FUNCTIONS
            .iter()
            .map(|function| function.symbol)
            .collect::<BTreeSet<_>>();
        assert_eq!(names.len(), NATIVE_MATH_FUNCTIONS.len());
        assert_eq!(symbols.len(), NATIVE_MATH_FUNCTIONS.len());
        for function in NATIVE_MATH_FUNCTIONS {
            let builtin =
                Builtin::from_name(function.name).expect("registered native math builtin");
            assert_eq!(builtin.name(), function.name);
        }

        let log = Builtin::from_name("log_f64")
            .expect("log_f64 builtin")
            .signature();
        assert_eq!(log.items.len(), 2);
        assert_eq!(log.items[0].kind, SigKind::F64);
        assert_eq!(log.items[1].kind, SigKind::tuple([SigKind::F64]));

        let ldexp = Builtin::from_name("ldexp_f64_i32")
            .expect("ldexp_f64_i32 builtin")
            .signature();
        assert_eq!(ldexp.items[0].kind, SigKind::F64);
        assert_eq!(
            ldexp.items[1].kind,
            SigKind::FixedInt(FixedIntKind::signed(32))
        );
        assert_eq!(ldexp.items[2].kind, SigKind::tuple([SigKind::F64]));
    }

    #[test]
    fn native_format_signatures_match_the_linked_functions() {
        let len = Builtin::from_name("format_f64_len")
            .expect("format_f64_len builtin")
            .signature();
        assert_eq!(len.items[0].kind, SigKind::F64);
        assert_eq!(len.items[1].kind, SigKind::tuple([SigKind::UInt]));

        let nth = Builtin::from_name("format_f64_nth")
            .expect("format_f64_nth builtin")
            .signature();
        assert_eq!(nth.items[0].kind, SigKind::F64);
        assert_eq!(nth.items[1].kind, SigKind::UInt);
        assert_eq!(
            nth.items[2].kind,
            SigKind::tuple([SigKind::FixedInt(FixedIntKind::unsigned(8))])
        );
    }

    #[test]
    fn fixed_arithmetic_builtins_use_bit_types() {
        for bit_width in [8, 32, 64, 128] {
            let kind = SigKind::FixedInt(FixedIntKind::bits(bit_width));
            for op in ["add", "sub", "mul"] {
                let name = format!("{op}_b{bit_width}");
                let builtin = Builtin::from_name(&name).expect("fixed arithmetic builtin");
                let sig = builtin.signature();
                assert_eq!(sig.items[0].kind, kind);
                assert_eq!(sig.items[1].kind, kind);
                assert_eq!(sig.items[2].kind, SigKind::tuple([kind.clone()]));
            }
        }
    }

    #[test]
    fn fixed_division_builtins_use_bit_types() {
        for bit_width in [8, 32, 64, 128] {
            let kind = SigKind::FixedInt(FixedIntKind::bits(bit_width));
            for interpretation in ["signed", "unsigned"] {
                let name = format!("div_{interpretation}_b{bit_width}");
                let builtin = Builtin::from_name(&name).expect("fixed division builtin");
                let sig = builtin.signature();
                assert_eq!(sig.items[0].kind, kind);
                assert_eq!(sig.items[1].kind, kind);
                assert_eq!(sig.items[2].kind, SigKind::tuple([]));
                assert_eq!(sig.items[3].kind, SigKind::tuple([kind.clone()]));
            }
        }
        assert!(Builtin::from_name("div_i32").is_none());
        assert!(Builtin::from_name("div_u32").is_none());
    }

    #[test]
    fn native_division_has_one_name_and_an_empty_error_continuation() {
        let sig = Builtin::from_name("div")
            .expect("native division builtin")
            .signature();
        assert_eq!(sig.items[0].kind, SigKind::Int);
        assert_eq!(sig.items[1].kind, SigKind::Int);
        assert_eq!(sig.items[2].kind, SigKind::tuple([]));
        assert_eq!(sig.items[3].kind, SigKind::tuple([SigKind::Int]));
        assert!(Builtin::from_name("divint").is_none());
    }

    #[test]
    fn equality_builtins_have_type_specific_names() {
        assert_eq!(Builtin::from_name("eq_int"), Some(Builtin::EqInt));
        assert_eq!(Builtin::from_name("eq_str"), Some(Builtin::EqStr));
        assert!(Builtin::from_name("int_eq").is_none());
        assert!(Builtin::from_name("str_eq").is_none());
        assert!(Builtin::from_name("eq").is_none());
        assert!(Builtin::from_name("eqi").is_none());
        assert!(Builtin::from_name("eqs").is_none());
    }

    #[test]
    fn printf_is_not_a_builtin() {
        assert!(Builtin::from_name("printf").is_none());
    }

    #[test]
    fn file_read_returns_raw_bytes() {
        let builtin = Builtin::from_name("file_read").expect("file_read builtin should exist");
        let sig = builtin.signature();
        assert_eq!(sig.items.len(), 3);
        assert_eq!(sig.items[0].kind, SigKind::Str);

        let err = match &sig.items[1].kind {
            SigKind::Sig(inner) => inner,
            other => panic!("expected tuple for err, got {:?}", other),
        };
        assert!(err.items.is_empty());

        let ok = match &sig.items[2].kind {
            SigKind::Sig(inner) => inner,
            other => panic!("expected tuple for ok, got {:?}", other),
        };
        assert_eq!(ok.items.len(), 1);
        assert_eq!(ok.items[0].kind, SigKind::Bytes);
        assert!(Builtin::from_name("readfile").is_none());
    }

    #[test]
    fn string_inspection_and_utf8_validation_have_safe_boundaries() {
        let len = Builtin::StrRuneLen.signature();
        assert_eq!(len.items[0].kind, SigKind::Str);
        assert_eq!(len.items[1].kind, SigKind::tuple([SigKind::UInt]));

        let nth = Builtin::StrRuneNth.signature();
        assert_eq!(nth.items[0].kind, SigKind::Str);
        assert_eq!(nth.items[1].kind, SigKind::UInt);
        assert_eq!(nth.items[2].kind, SigKind::tuple([]));
        assert_eq!(nth.items[3].kind, SigKind::tuple([SigKind::Rune]));

        let from_utf8 = Builtin::StrFromUtf8.signature();
        assert_eq!(from_utf8.items[0].kind, SigKind::Bytes);
        assert_eq!(from_utf8.items[1].kind, SigKind::tuple([]));
        assert_eq!(from_utf8.items[2].kind, SigKind::tuple([SigKind::Str]));
    }

    #[test]
    fn byte_inspection_conversion_and_build_have_safe_boundaries() {
        let u8_kind = SigKind::FixedInt(FixedIntKind::unsigned(8));

        assert!(Builtin::from_name("bytes_len").is_none());

        let nth = Builtin::BytesNth.signature();
        assert_eq!(nth.items[0].kind, SigKind::Bytes);
        assert_eq!(nth.items[1].kind, SigKind::UInt);
        assert_eq!(nth.items[2].kind, SigKind::tuple([]));
        assert_eq!(nth.items[3].kind, SigKind::tuple([u8_kind.clone()]));

        let from_str = Builtin::BytesFromStr.signature();
        assert_eq!(from_str.items[0].kind, SigKind::Str);
        assert_eq!(from_str.items[1].kind, SigKind::tuple([SigKind::Bytes]));

        let build = Builtin::BytesBuild.signature();
        assert!(matches!(build.items[0].kind, SigKind::Sig(_)));
        assert_eq!(build.items[1].kind, SigKind::tuple([]));
        assert_eq!(build.items[2].kind, SigKind::tuple([SigKind::Bytes]));

        let to_u8 = Builtin::U8FromInt.signature();
        assert_eq!(to_u8.items[0].kind, SigKind::Int);
        assert_eq!(to_u8.items[1].kind, SigKind::tuple([]));
        assert_eq!(to_u8.items[2].kind, SigKind::tuple([u8_kind]));
    }

    #[test]
    fn formatter_scalar_builtins_keep_their_static_types() {
        for builtin in [Builtin::AddUInt, Builtin::SubUInt] {
            let sig = builtin.signature();
            assert_eq!(sig.items[0].kind, SigKind::UInt);
            assert_eq!(sig.items[1].kind, SigKind::UInt);
            assert_eq!(sig.items[2].kind, SigKind::tuple([SigKind::UInt]));
        }
        for builtin in [Builtin::EqUInt, Builtin::LtUInt] {
            let sig = builtin.signature();
            assert_eq!(sig.items[0].kind, SigKind::UInt);
            assert_eq!(sig.items[1].kind, SigKind::UInt);
        }
        let eq_b8 = Builtin::EqBits(8).signature();
        let b8_kind = SigKind::FixedInt(FixedIntKind::bits(8));
        assert_eq!(eq_b8.items[0].kind, b8_kind);
        assert_eq!(eq_b8.items[1].kind, b8_kind);
    }

    #[test]
    fn builtin_entries_use_direct_names() {
        assert!(get_spec("add").is_some());
        assert!(get_spec("sprintf").is_none());
        assert!(get_spec("exit").is_some());
        assert!(get_spec("write").is_some());
        assert!(get_spec("os.add").is_none());
        assert!(get_spec("io.write").is_none());
        assert!(get_spec("std.add").is_none());
    }

    #[test]
    fn registry_names_are_unique_resolvable_and_routed() {
        let names = registered_names().collect::<Vec<_>>();
        let unique = names.iter().copied().collect::<BTreeSet<_>>();
        assert_eq!(names.len(), unique.len());

        for name in names {
            assert!(
                get_spec(name).is_some(),
                "builtin '@{name}' does not resolve"
            );
            if let Some(builtin) = function_from_name(name) {
                let _ = builtin.air_route();
                let _ = builtin.comptime_route();
            }
        }
    }
}

fn math_binary_sig(arg_kind: SigKind) -> Signature {
    let result_sig = tuple_sig(vec![sig_item("res", arg_kind.clone())]);
    sig_from_items(vec![
        sig_item("x", arg_kind.clone()),
        sig_item("y", arg_kind.clone()),
        sig_item("ok", result_sig),
    ])
}

fn native_function_sig(function: &NativeFunction) -> Signature {
    let mut items = function
        .params
        .iter()
        .map(|param| sig_item(param.name, param.kind.sig_kind()))
        .collect::<Vec<_>>();
    items.push(sig_item("ok", SigKind::tuple([function.result.sig_kind()])));
    sig_from_items(items)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum AirRuntimeHelper {
    ReleaseHeapPtr,
    DeepCopyHeapPtr,
    ReleaseDescriptorPtr,
    CloneDescriptorPtr,
    MemcpyHelper,
    Utf8Validate,
    BytesBuild,
}

impl AirRuntimeHelper {
    pub fn name(&self) -> &'static str {
        match self {
            AirRuntimeHelper::ReleaseHeapPtr => "release_heap_ptr",
            AirRuntimeHelper::DeepCopyHeapPtr => "deepcopy_heap_ptr",
            AirRuntimeHelper::ReleaseDescriptorPtr => "release_descriptor_ptr",
            AirRuntimeHelper::CloneDescriptorPtr => "clone_descriptor_ptr",
            AirRuntimeHelper::MemcpyHelper => "memcpy_helper",
            AirRuntimeHelper::Utf8Validate => "utf8_validate",
            AirRuntimeHelper::BytesBuild => "bytes_build_step",
        }
    }
}
