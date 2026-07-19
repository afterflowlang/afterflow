use crate::compiler::span::Span;

#[derive(Debug, Clone, PartialEq)]
pub struct Token {
    pub kind: TokenKind,
    pub has_leading_whitespace: bool,
    pub span: Span,
}

impl Token {
    pub fn new(kind: TokenKind, span: Span) -> Self {
        Self {
            kind,
            has_leading_whitespace: false,
            span,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum TokenKind {
    Eof,
    Ident(String),
    Builtin(String),
    SourcePath(String),
    IntLiteral(i64),
    FloatLiteral(f64),
    StringLiteral(String),
    Arrow,
    FatArrow,
    Comma,
    Colon,
    Semicolon,
    Dot,
    LParen,
    RParen,
    LBrace,
    RBrace,
    LBracket,
    RBracket,
    Equals,
    Plus,
    Minus,
    Star,
    Bang,
    Newline,
    Question,
    AngleOpen,
    AngleClose,
}
