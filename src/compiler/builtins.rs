use crate::compiler::hir::{self, FixedIntKind, SigItem, SigKind, Signature};
use std::collections::BTreeSet;

// TODO: Needed?
#[derive(Debug)]
pub enum BuiltinSpec {
    Function(hir::Signature),
    Type(hir::SigKind),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Builtin {
    Add,
    Sub,
    Mul,
    Div,
    AddF64,
    MulF64,
    DivF64,
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
    EqInt,
    EqStr,
    Lt,
    Gt,
    Write,
    ReadFile,
    Exit,
    Sprintf,
}

impl Builtin {
    pub fn from_name(name: &str) -> Option<Self> {
        match name {
            "add" => Some(Builtin::Add),
            "sub" => Some(Builtin::Sub),
            "mul" => Some(Builtin::Mul),
            "div" => Some(Builtin::Div),
            "add_f64" => Some(Builtin::AddF64),
            "mul_f64" => Some(Builtin::MulF64),
            "div_f64" => Some(Builtin::DivF64),
            "add_b8" => Some(Builtin::AddBits(8)),
            "add_b32" => Some(Builtin::AddBits(32)),
            "add_b64" => Some(Builtin::AddBits(64)),
            "add_b128" => Some(Builtin::AddBits(128)),
            "sub_b8" => Some(Builtin::SubBits(8)),
            "sub_b32" => Some(Builtin::SubBits(32)),
            "sub_b64" => Some(Builtin::SubBits(64)),
            "sub_b128" => Some(Builtin::SubBits(128)),
            "mul_b8" => Some(Builtin::MulBits(8)),
            "mul_b32" => Some(Builtin::MulBits(32)),
            "mul_b64" => Some(Builtin::MulBits(64)),
            "mul_b128" => Some(Builtin::MulBits(128)),
            "div_signed_b8" => Some(div_bits(8, true)),
            "div_unsigned_b8" => Some(div_bits(8, false)),
            "div_signed_b32" => Some(div_bits(32, true)),
            "div_unsigned_b32" => Some(div_bits(32, false)),
            "div_signed_b64" => Some(div_bits(64, true)),
            "div_unsigned_b64" => Some(div_bits(64, false)),
            "div_signed_b128" => Some(div_bits(128, true)),
            "div_unsigned_b128" => Some(div_bits(128, false)),
            "eq_int" => Some(Builtin::EqInt),
            "eq_str" => Some(Builtin::EqStr),
            "lt" => Some(Builtin::Lt),
            "gt" => Some(Builtin::Gt),
            "write" => Some(Builtin::Write),
            "readfile" => Some(Builtin::ReadFile),
            "exit" => Some(Builtin::Exit),
            "sprintf" => Some(Builtin::Sprintf),
            _ => fixed_conversion_from_name(name),
        }
    }

    pub fn name(self) -> &'static str {
        match self {
            Builtin::Add => "add",
            Builtin::Sub => "sub",
            Builtin::Mul => "mul",
            Builtin::Div => "div",
            Builtin::AddF64 => "add_f64",
            Builtin::MulF64 => "mul_f64",
            Builtin::DivF64 => "div_f64",
            Builtin::AddBits(bit_width) => fixed_bit_op_name("add", bit_width),
            Builtin::SubBits(bit_width) => fixed_bit_op_name("sub", bit_width),
            Builtin::MulBits(bit_width) => fixed_bit_op_name("mul", bit_width),
            Builtin::DivBits {
                bit_width,
                is_signed,
            } => fixed_div_name(bit_width, is_signed),
            Builtin::ConvertFixed { from, to } => conversion_name(from, to),
            Builtin::EqInt => "eq_int",
            Builtin::EqStr => "eq_str",
            Builtin::Lt => "lt",
            Builtin::Gt => "gt",
            Builtin::Write => "write",
            Builtin::ReadFile => "readfile",
            Builtin::Exit => "exit",
            Builtin::Sprintf => "sprintf",
        }
    }

    pub fn signature(self) -> Signature {
        match self {
            Builtin::Add | Builtin::Sub | Builtin::Mul => math_binary_sig(SigKind::Int),
            Builtin::Div => div_sig(),
            Builtin::AddF64 | Builtin::MulF64 | Builtin::DivF64 => math_binary_sig(SigKind::F64),
            Builtin::AddBits(bit_width)
            | Builtin::SubBits(bit_width)
            | Builtin::MulBits(bit_width) => {
                math_binary_sig(SigKind::FixedInt(FixedIntKind::bits(bit_width)))
            }
            Builtin::DivBits { bit_width, .. } => div_fixed_sig(bit_width),
            Builtin::ConvertFixed { from, to } => convert_sig(from, to),
            Builtin::EqInt | Builtin::Lt | Builtin::Gt => comparison_sig(SigKind::Int),
            Builtin::EqStr => comparison_sig(SigKind::Str),
            Builtin::Write => sig_from_items(vec![
                sig_item("value", SigKind::Str),
                sig_item("ok", SigKind::tuple([])),
            ]),
            Builtin::ReadFile => sig_from_items(vec![
                sig_item("path", SigKind::Str),
                sig_item("err", SigKind::tuple([])),
                sig_item("ok", SigKind::tuple([SigKind::Str])),
            ]),
            Builtin::Exit => sig_from_items(vec![sig_item("code", SigKind::Int)]),
            Builtin::Sprintf => sig_from_items(vec![
                compile_time_sig_item("format", SigKind::Str),
                sig_item("args", SigKind::Variadic),
                sig_item("ok", SigKind::tuple([SigKind::Str])),
            ]),
        }
    }

    pub fn is_call(self) -> bool {
        matches!(
            self,
            Builtin::Sprintf | Builtin::Write | Builtin::ReadFile | Builtin::Exit
        )
    }

    pub fn is_conditional(self) -> bool {
        matches!(
            self,
            Builtin::EqInt | Builtin::EqStr | Builtin::Lt | Builtin::Gt
        )
    }

    pub fn is_instruction(self) -> bool {
        matches!(
            self,
            Builtin::Add
                | Builtin::Sub
                | Builtin::Mul
                | Builtin::Div
                | Builtin::AddF64
                | Builtin::MulF64
                | Builtin::DivF64
                | Builtin::AddBits(_)
                | Builtin::SubBits(_)
                | Builtin::MulBits(_)
                | Builtin::DivBits { .. }
                | Builtin::ConvertFixed { .. }
        )
    }

    pub fn is_libc_call(self) -> bool {
        matches!(
            self,
            Builtin::Sprintf | Builtin::Write | Builtin::ReadFile | Builtin::Exit
        )
    }
}

pub fn get_spec(name: &str) -> Option<BuiltinSpec> {
    if let Some(builtin) = Builtin::from_name(name) {
        return Some(BuiltinSpec::Function(builtin.signature()));
    }
    match name {
        "byte" => Some(BuiltinSpec::Type(hir::SigKind::Byte)),
        "int" => Some(BuiltinSpec::Type(hir::SigKind::Int)),
        "uint" => Some(BuiltinSpec::Type(hir::SigKind::UInt)),
        "str" => Some(BuiltinSpec::Type(hir::SigKind::Str)),
        "f64" => Some(BuiltinSpec::Type(hir::SigKind::F64)),
        _ => fixed_int_from_name(name).map(|kind| BuiltinSpec::Type(hir::SigKind::FixedInt(kind))),
    }
}

pub fn function_from_name(name: &str) -> Option<Builtin> {
    Builtin::from_name(name)
}

fn sig_item(name: &str, ty: SigKind) -> SigItem {
    SigItem {
        name: name.to_string(),
        kind: ty,
        is_comptime: false,
    }
}

fn compile_time_sig_item(name: &str, kind: SigKind) -> SigItem {
    SigItem {
        name: name.to_string(),
        kind,
        is_comptime: true,
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

fn div_bits(bit_width: u16, is_signed: bool) -> Builtin {
    Builtin::DivBits {
        bit_width,
        is_signed,
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

fn fixed_int_from_name(name: &str) -> Option<FixedIntKind> {
    match name {
        "b8" => Some(FixedIntKind::bits(8)),
        "i8" => Some(FixedIntKind::signed(8)),
        "u8" => Some(FixedIntKind::unsigned(8)),
        "b32" => Some(FixedIntKind::bits(32)),
        "i32" => Some(FixedIntKind::signed(32)),
        "u32" => Some(FixedIntKind::unsigned(32)),
        "b64" => Some(FixedIntKind::bits(64)),
        "i64" => Some(FixedIntKind::signed(64)),
        "u64" => Some(FixedIntKind::unsigned(64)),
        "b128" => Some(FixedIntKind::bits(128)),
        "i128" => Some(FixedIntKind::signed(128)),
        "u128" => Some(FixedIntKind::unsigned(128)),
        _ => None,
    }
}

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
        assert!(Builtin::from_name("mul_f64").is_some());
        assert!(Builtin::from_name("div_f64").is_some());
        assert!(Builtin::from_name("addf64").is_none());
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
    fn sprintf_format_is_comptime_str() {
        let sig = Builtin::Sprintf.signature();
        assert_eq!(sig.items[0].kind, SigKind::Str);
        assert!(sig.items[0].is_comptime);
    }

    #[test]
    fn readfile_signature_has_err_and_ok_continuations() {
        let builtin = Builtin::from_name("readfile").expect("readfile builtin should exist");
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
        assert_eq!(ok.items[0].kind, SigKind::Str);
    }

    #[test]
    fn builtin_entries_use_direct_names() {
        assert!(get_spec("add").is_some());
        assert!(get_spec("sprintf").is_some());
        assert!(get_spec("exit").is_some());
        assert!(get_spec("write").is_some());
        assert!(get_spec("os.add").is_none());
        assert!(get_spec("io.write").is_none());
        assert!(get_spec("std.add").is_none());
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

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum AirRuntimeHelper {
    ReleaseHeapPtr,
    DeepCopyHeapPtr,
    MemcpyHelper,
}

impl AirRuntimeHelper {
    pub fn name(&self) -> &'static str {
        match self {
            AirRuntimeHelper::ReleaseHeapPtr => "release_heap_ptr",
            AirRuntimeHelper::DeepCopyHeapPtr => "deepcopy_heap_ptr",
            AirRuntimeHelper::MemcpyHelper => "memcpy_helper",
        }
    }
}
