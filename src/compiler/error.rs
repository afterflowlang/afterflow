use std::error::Error as StdError;
use std::fmt::{self, Display, Formatter};
use std::io;
use std::path::PathBuf;

use crate::compiler::span::Span;

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
pub enum Code {
    Io,
    Lex,
    Parse,
    HIR,
    Resolve,
    Codegen,
    Internal,
}

impl Display for Code {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        let code = match self {
            Code::Io => "io",
            Code::Lex => "lex",
            Code::Parse => "parse",
            Code::HIR => "hir",
            Code::Resolve => "resolve",
            Code::Codegen => "codegen",
            Code::Internal => "internal",
        };
        f.write_str(code)
    }
}

#[derive(Debug, Clone)]
pub struct Error {
    pub code: Code,
    pub message: String,
    pub span: Span,
    pub source: Option<Source>,
}

#[derive(Debug, Clone)]
pub struct Source {
    pub path: PathBuf,
    pub text: String,
    pub offset: usize,
}

pub struct Diagnostic<'a> {
    error: &'a Error,
    has_color: bool,
}

impl Error {
    pub fn new(code: Code, message: impl Into<String>, span: Span) -> Self {
        Self {
            code,
            message: message.into(),
            span,
            source: None,
        }
    }

    pub fn with_source(mut self, source: Source) -> Self {
        self.source = Some(source);
        self
    }

    pub fn with_span(mut self, span: Span) -> Self {
        if self.span.line == 0 {
            self.span = span;
        }
        self
    }

    pub fn display(&self, has_color: bool) -> Diagnostic<'_> {
        Diagnostic {
            error: self,
            has_color,
        }
    }

    fn render(&self, f: &mut Formatter<'_>, has_color: bool) -> fmt::Result {
        write!(f, "[{}] {}", self.code, self.message)?;
        let Some(source) = &self.source else {
            return write!(f, " at {}:{}", self.span.line, self.span.column);
        };
        let Some((line, prefix, width)) = source.highlight(self.span) else {
            return write!(f, " at {}:{}", self.span.line, self.span.column);
        };
        let indent = prefix
            .chars()
            .map(|ch| if ch == '\t' { '\t' } else { ' ' })
            .collect::<String>();
        let carets = "^".repeat(width);
        write!(
            f,
            "\n{}:{}\n{}\n{}",
            source.path.display(),
            self.span.line,
            line,
            indent
        )?;
        if has_color {
            write!(f, "\x1b[31m{carets}\x1b[0m")
        } else {
            f.write_str(&carets)
        }
    }
}

impl Display for Diagnostic<'_> {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        self.error.render(f, self.has_color)
    }
}

pub fn new(code: Code, message: impl Into<String>, span: Span) -> Error {
    Error {
        code,
        message: message.into(),
        span,
        source: None,
    }
}

impl Source {
    pub fn new(path: PathBuf, text: String, offset: usize) -> Self {
        Self { path, text, offset }
    }

    pub fn contains(&self, span: Span) -> bool {
        span.offset >= self.offset && span.offset <= self.offset + self.text.len()
    }

    fn highlight(&self, span: Span) -> Option<(&str, &str, usize)> {
        if span.line == 0 || !self.contains(span) {
            return None;
        }
        let line = self.text.lines().nth(span.line - 1)?;
        let column = span.column.saturating_sub(1).min(line.len());
        let prefix = line.get(..column)?;
        let rest = line.get(column..)?;
        Some((line, prefix, highlight_width(rest)))
    }
}

fn highlight_width(source: &str) -> usize {
    let mut chars = source.chars();
    let Some(first) = chars.next() else {
        return 1;
    };
    let width = match first {
        'a'..='z' | 'A'..='Z' | '_' => source
            .chars()
            .take_while(|ch| ch.is_ascii_alphanumeric() || *ch == '_' || *ch == '.')
            .count(),
        '0'..='9' => source
            .chars()
            .take_while(|ch| ch.is_ascii_alphanumeric() || matches!(ch, '.' | '_'))
            .count(),
        '@' => source
            .chars()
            .take_while(|ch| !ch.is_whitespace() && *ch != ';')
            .count(),
        '\'' | '"' => string_width(source, first),
        '.' => source.chars().take_while(|ch| *ch == '.').count(),
        _ => 1,
    };
    width.max(1)
}

fn string_width(source: &str, delimiter: char) -> usize {
    let mut is_escaped = false;
    for (index, ch) in source.chars().enumerate().skip(1) {
        if ch == delimiter && !is_escaped {
            return index + 1;
        }
        is_escaped = ch == '\\' && !is_escaped;
        if ch != '\\' {
            is_escaped = false;
        }
    }
    source.chars().count().max(1)
}

impl Display for Error {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        self.render(f, false)
    }
}

impl StdError for Error {}

impl From<io::Error> for Error {
    fn from(err: io::Error) -> Self {
        Self::new(Code::Io, err.to_string(), Span::unknown())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn displays_source_line_and_token_highlight() {
        let error = Error::new(Code::HIR, "invalid argument", Span::new(2, 9, 14)).with_source(
            Source::new(
                PathBuf::from("src/main.rgo"),
                "main: () {\n    foo(\"bad\")\n}\n".to_string(),
                1,
            ),
        );

        assert_eq!(
            error.to_string(),
            "[hir] invalid argument\nsrc/main.rgo:2\n    foo(\"bad\")\n        ^^^^^"
        );
        assert!(format!("{}", error.display(true)).contains("\x1b[31m^^^^^\x1b[0m"));
    }
}
