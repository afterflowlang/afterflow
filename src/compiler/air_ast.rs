use crate::compiler::builtins;
pub use crate::compiler::hir::{FixedIntKind, Lit, SigItem, SigKind};
use std::collections::BTreeSet;

#[derive(Debug, Clone)]
pub struct FunctionSig {
    pub name: String, // TODO: Maybe make it &str?
    pub params: Vec<SigItem>,
    pub generics: BTreeSet<String>,
    pub builtin: Option<builtins::Builtin>,
}

impl FunctionSig {
    pub fn param_kinds(&self) -> Vec<SigKind> {
        self.params.iter().map(|item| item.kind.clone()).collect()
    }
}

#[derive(Clone, Debug)]
pub enum AirExecTarget {
    Function(FunctionSig),
    Closure { name: String },
}

#[derive(Clone)]
pub struct AirFunction {
    pub sig: FunctionSig,
    pub items: Vec<AirStmt>,
}

impl AirFunction {
    pub fn builtin_internal_array_str_nth() -> Self {
        Self {
            sig: FunctionSig {
                name: "internal_array_str_nth".to_string(),
                params: Vec::new(),
                generics: BTreeSet::new(),
                builtin: None,
            },
            items: Vec::new(),
        }
    }

    pub fn builtin_internal_array_str() -> Self {
        Self {
            sig: FunctionSig {
                name: "internal_array_str".to_string(),
                params: Vec::new(),
                generics: BTreeSet::new(),
                builtin: None,
            },
            items: Vec::new(),
        }
    }
}

#[derive(Clone, Debug)]
pub struct AirReleaseHeap {
    pub name: String,
}

#[derive(Clone, Debug)]
pub struct AirLabel {
    pub name: String,
}

#[derive(Clone, Debug)]
pub struct AirJump {
    pub target: String,
}

#[derive(Clone, Debug)]
pub enum AirValue {
    Binding(String),
    Literal(i64),
}

#[derive(Clone, Debug)]
pub struct AirReturn {
    pub value: Option<String>,
}

#[derive(Clone, Debug)]
pub struct AirPin {
    pub result: String,
    pub value: AirValue,
}

#[derive(Clone, Debug)]
pub struct AirJumpEq {
    pub args: Vec<AirArg>,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirJumpLt {
    pub left: AirValue,
    pub right: AirValue,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirSetField {
    pub env_end: String,
    pub offset: isize,
    pub value: AirArg,
}

#[derive(Clone, Debug)]
pub struct AirJumpClosure {
    pub env_end: String,
    pub args: Vec<AirArg>,
}

#[derive(Clone)]
pub enum AirStmt {
    Op(Box<AirOp>),
    Label(AirLabel),
}

impl AirStmt {
    pub fn op(op: AirOp) -> Self {
        Self::Op(Box::new(op))
    }

    pub fn as_op(&self) -> Option<&AirOp> {
        match self {
            Self::Op(op) => Some(op.as_ref()),
            Self::Label(_) => None,
        }
    }
}

#[derive(Clone, Debug)]
pub enum AirOp {
    Return(AirReturn),

    Jump(AirJump),
    JumpArgs(AirJumpArgs),
    JumpClosure(AirJumpClosure),
    JumpEqInt(AirJumpEq),
    JumpEqStr(AirJumpEq),
    JumpEqUInt(AirJumpEq),
    JumpEqBits(AirJumpEq),
    JumpLt(AirJumpLt),
    JumpLtUInt(AirJumpLt),
    JumpGt(AirJumpGt),

    Add(AirAdd),
    AddUInt(AirAdd),
    AddBits(AirBinaryBits),
    Sub(AirSub),
    SubUInt(AirSub),
    SubBits(AirBinaryBits),
    Mul(AirMul),
    MulBits(AirBinaryBits),
    DivInt(AirDivInt),
    DivBits(AirDivBits),
    AddF64(AirAddF64),
    SubF64(AirSubF64),
    MulF64(AirMulF64),
    DivF64(AirDivF64),
    NativeCall(AirNativeCall),
    ConvertFixed(AirConvertFixed),
    RuneFromU32(AirRuneFromU32),
    U32FromRune(AirU32FromRune),
    StrRuneLen(AirStrRuneLen),
    StrRuneNth(AirStrRuneNth),
    StrFromUtf8(AirStrFromUtf8),
    BytesLen(AirBytesLen),
    BytesNth(AirBytesNth),
    BytesFromStr(AirBytesFromStr),
    BytesBuild(AirBytesBuild),
    IntToU8(AirIntToU8),

    SysExit(AirSysExit),

    Write(AirWrite),
    FileRead(AirFileRead),

    DropClosure(AirDropClosure),
    NewClosure(AirNewClosure),
    CloneClosure(AirCloneClosure),
    CloneDescriptor(AirCloneDescriptor),
    MoveClosure(AirMoveClosure),
    DropDescriptor(AirDropDescriptor),
    ReleaseHeap(AirReleaseHeap),
    Pin(AirPin),
    Field(AirField),
    CopyField(AirField),
    SetField(AirSetField),
}

#[derive(Clone, Debug)]
pub struct AirCloneClosure {
    pub src: String,
    pub dst: String,
    pub remaining: Vec<SigKind>, // TODO: Why does it need this?
}

#[derive(Clone, Debug)]
pub struct AirMoveClosure {
    pub src: String,
    pub dst: String,
}

#[derive(Clone, Debug)]
pub struct AirCloneDescriptor {
    pub src: String,
    pub dst: String,
}

#[derive(Clone, Debug)]
pub struct AirDropDescriptor {
    pub name: String,
}

#[derive(Clone, Debug)]
pub struct AirField {
    pub result: String,
    pub ptr: String,
    pub offset: isize,
    pub kind: SigKind,
}

#[derive(Clone, Debug)]
pub struct AirAdd {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirSub {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirMul {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirBinaryBits {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
    pub bit_width: u16,
}

#[derive(Clone, Debug)]
pub struct AirDivInt {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub err_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirDivBits {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub err_target: String,
    pub ok_target: String,
    pub bit_width: u16,
    pub is_signed: bool,
}

#[derive(Clone, Debug)]
pub struct AirAddF64 {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirSubF64 {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirMulF64 {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirDivF64 {
    pub input_a: AirArg,
    pub input_b: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirNativeCall {
    pub function: &'static builtins::NativeFunction,
    pub inputs: Vec<AirArg>,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirConvertFixed {
    pub input: AirArg,
    pub target: String,
    pub from: FixedIntKind,
    pub to: FixedIntKind,
}

#[derive(Clone, Debug)]
pub struct AirRuneFromU32 {
    pub input: AirArg,
    pub invalid_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirU32FromRune {
    pub input: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirStrRuneLen {
    pub value: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirStrRuneNth {
    pub value: AirArg,
    pub idx: AirArg,
    pub empty_target: String,
    pub one_target: String,
}

#[derive(Clone, Debug)]
pub struct AirStrFromUtf8 {
    pub value: AirArg,
    pub invalid_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirBytesLen {
    pub value: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirBytesNth {
    pub value: AirArg,
    pub idx: AirArg,
    pub empty_target: String,
    pub one_target: String,
}

#[derive(Clone, Debug)]
pub struct AirBytesFromStr {
    pub value: AirArg,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirBytesBuild {
    pub source: AirArg,
    pub invalid_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirIntToU8 {
    pub value: AirArg,
    pub invalid_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirJumpGt {
    pub left: AirValue,
    pub right: AirValue,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirWrite {
    pub args: Vec<AirArg>,
    pub arg_kinds: Vec<SigKind>,
    pub target: String,
}

#[derive(Clone, Debug)]
pub struct AirFileRead {
    pub path: AirArg,
    pub err_target: String,
    pub ok_target: String,
}

#[derive(Clone, Debug)]
pub struct AirSysExit {
    pub args: Vec<AirArg>,
}

#[derive(Clone, Debug)]
pub struct AirDropClosure {
    pub name: String,
}

#[derive(Clone, Debug)]
pub struct AirJumpArgs {
    pub target: FunctionSig,
    pub args: Vec<AirArg>,
}

// TODO: ABC: This needs adapting and fixing.
#[derive(Clone, Debug)]
pub struct AirNewClosure {
    pub name: String,
    pub target: FunctionSig,
    pub args: Vec<AirArg>,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct AirArg {
    pub name: String,
    pub kind: SigKind,
    pub literal: Option<Lit>,
}
