pub use crate::compiler::hir_context::{Context, ContextEntry};
use std::collections::BTreeSet;
use std::hash::{Hash, Hasher};

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum SigKind {
    Byte,
    Int,
    UInt,
    FixedInt(FixedIntKind),
    Str,
    F64,
    Variadic,
    Ident(SigIdent),
    Sig(Signature),
    GenericInst { name: String, args: Vec<SigKind> },
    Generic(String),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum FixedIntInterpretation {
    Bits,
    Signed,
    Unsigned,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct FixedIntKind {
    pub interpretation: FixedIntInterpretation,
    pub bit_width: u16,
}

impl FixedIntKind {
    pub const fn bits(bit_width: u16) -> Self {
        Self {
            interpretation: FixedIntInterpretation::Bits,
            bit_width,
        }
    }

    pub const fn signed(bit_width: u16) -> Self {
        Self {
            interpretation: FixedIntInterpretation::Signed,
            bit_width,
        }
    }

    pub const fn unsigned(bit_width: u16) -> Self {
        Self {
            interpretation: FixedIntInterpretation::Unsigned,
            bit_width,
        }
    }

    pub fn name(self) -> String {
        let prefix = match self.interpretation {
            FixedIntInterpretation::Bits => "b",
            FixedIntInterpretation::Signed => "i",
            FixedIntInterpretation::Unsigned => "u",
        };
        format!("{prefix}{}", self.bit_width)
    }
}

impl SigKind {
    pub fn tuple<I>(items: I) -> SigKind
    where
        I: IntoIterator<Item = SigKind>,
    {
        SigKind::Sig(Signature::from_tuple(items))
    }

    pub fn supports_comptime(&self) -> bool {
        matches!(self, SigKind::Int | SigKind::UInt | SigKind::Str)
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Signature {
    pub items: Vec<SigItem>,
    pub generics: BTreeSet<String>,
}

impl Signature {
    pub fn from_kinds<I>(kinds: I) -> Signature
    where
        I: IntoIterator<Item = SigKind>,
    {
        let items = kinds
            .into_iter()
            .map(|kind| SigItem {
                name: String::new(),
                kind,
                is_comptime: false,
            })
            .collect();
        Signature {
            items,
            generics: BTreeSet::new(),
        }
    }

    pub fn kinds(&self) -> Vec<SigKind> {
        self.items.iter().map(|item| item.kind.clone()).collect()
    }

    pub fn from_tuple<I>(items: I) -> Signature
    where
        I: IntoIterator<Item = SigKind>,
    {
        let sig_items = items
            .into_iter()
            .map(|kind| SigItem {
                name: String::new(),
                kind,
                is_comptime: false,
            })
            .collect();
        Signature {
            items: sig_items,
            generics: BTreeSet::new(),
        }
    }

    pub fn is_variadic(&self) -> bool {
        self.items
            .iter()
            .any(|item| matches!(item.kind, SigKind::Variadic))
    }

    pub fn names(&self) -> Vec<String> {
        self.items.iter().map(|item| item.name.clone()).collect()
    }
}

#[derive(Debug, Clone)]
pub struct SigItem {
    pub name: String,
    pub kind: SigKind,
    pub is_comptime: bool,
}

impl Eq for SigItem {}

impl PartialEq for SigItem {
    fn eq(&self, other: &Self) -> bool {
        self.kind == other.kind && self.is_comptime == other.is_comptime
    }
}

impl Hash for SigItem {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.kind.hash(state);
        self.is_comptime.hash(state);
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct SigIdent {
    pub name: String,
}

#[derive(Clone, Debug)]
pub enum Lit {
    Str(String),
    Int(isize),
    F64(f64),
}

impl PartialEq for Lit {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Lit::Str(left), Lit::Str(right)) => left == right,
            (Lit::Int(left), Lit::Int(right)) => left == right,
            (Lit::F64(left), Lit::F64(right)) => left.to_bits() == right.to_bits(),
            _ => false,
        }
    }
}

impl Eq for Lit {}

impl Hash for Lit {
    fn hash<H: Hasher>(&self, state: &mut H) {
        match self {
            Lit::Str(value) => {
                state.write_u8(0);
                value.hash(state);
            }
            Lit::Int(value) => {
                state.write_u8(1);
                value.hash(state);
            }
            Lit::F64(value) => {
                state.write_u8(2);
                state.write_u64(value.to_bits());
            }
        }
    }
}

#[derive(Debug, Clone)]
pub struct Function {
    pub name: String,
    pub sig: Signature,
    pub body: Block,
}

#[derive(Debug, Clone)]
pub struct Block {
    pub items: Vec<BlockItem>,
}

#[derive(Debug, Clone)]
pub enum BlockItem {
    Import { label: String, path: String },
    FunctionDef(Function),
    SigDef { name: String, sig: Signature },
    LitDef { name: String, literal: Lit },
    ClosureDef(Closure),
    Exec(Exec),
}

#[derive(Debug, Clone)]
pub struct Exec {
    pub of: String,
    pub args: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct Closure {
    pub name: String,
    pub of: String,
    pub args: Vec<String>,
}
