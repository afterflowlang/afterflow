//! Canonical source formatting for Afterflow.
//!
//! Formatting is deliberately part of the frontend: every consumer uses the
//! same lexer, parser, AST, and syntax errors as the compiler.

use std::fmt::Write as _;
use std::io::Cursor;

use crate::ast::{Arg, BlockItem, Ident, Lambda, Lit, SigKind, Signature, Term};
use crate::error::Error;
use crate::lexer::Lexer;
use crate::parser::Parser;

const INDENT: &str = "\t";
const INDENT_WIDTH: usize = 4;
const MAX_WIDTH: usize = 100;

/// Formats a complete Afterflow source file into its canonical representation.
///
/// Invalid source is returned as the frontend's ordinary lexical or parse
/// error. The result always uses LF line endings and ends with one newline.
pub fn format_source(source: &str) -> Result<String, Error> {
    let mut parser = Parser::new(Lexer::new(Cursor::new(source.as_bytes())));
    let mut items = Vec::new();
    while let Some(item) = parser.next_block_item()? {
        items.push(item);
    }

    let mut formatter = Formatter::new(source);
    formatter.block_items(&items, 0);
    formatter.remaining_comments(0);
    while formatter.output.ends_with("\n\n") {
        formatter.output.pop();
    }
    if !formatter.output.is_empty() && !formatter.output.ends_with('\n') {
        formatter.output.push('\n');
    }
    Ok(formatter.output)
}

#[derive(Debug)]
struct Comment {
    offset: usize,
    text: String,
}

struct Formatter {
    output: String,
    comments: Vec<Comment>,
    next_comment: usize,
}

impl Formatter {
    fn new(source: &str) -> Self {
        Self {
            output: String::new(),
            comments: comments(source),
            next_comment: 0,
        }
    }

    fn block_items(&mut self, items: &[BlockItem], depth: usize) {
        for item in items {
            self.comments_before(item.span().offset, depth);
            self.block_item(item, depth);
        }
    }

    fn block_item(&mut self, item: &BlockItem, depth: usize) {
        match item {
            BlockItem::Import { label, path, .. } => {
                self.line(depth, &format!("{label}: {path}"));
            }
            BlockItem::SigDef { name, sig, .. } => {
                self.line(
                    depth,
                    &format!("{name}: {}{}", generics(sig), signature(sig)),
                );
            }
            BlockItem::FunctionDef { name, lambda, .. } => {
                let header = format!(
                    "{name}: {}{} {{",
                    generics(&lambda.params),
                    signature(&lambda.params)
                );
                self.line(depth, &header);
                self.block_items(&lambda.body.items, depth + 1);
                self.line(depth, "}");
                self.application_args(&lambda.args, depth);
            }
            BlockItem::LitDef {
                name,
                literal: value,
                ..
            } => self.line(depth, &format!("{name}: {}", literal(&value.value))),
            BlockItem::IdentDef { name, ident, .. } => {
                let value = self.ident(&ident.name, &ident.args, depth, name.len() + 2);
                self.line_multiline(depth, &format!("{name}: {value}"));
            }
            BlockItem::Lambda(lambda) => {
                let value = self.lambda(lambda, depth);
                self.line_multiline(depth, &value);
            }
            BlockItem::Ident(ident) => {
                let value = self.ident(&ident.name, &ident.args, depth, 0);
                self.line_multiline(depth, &value);
            }
            BlockItem::ScopeCapture {
                params,
                continuation,
                term,
                ..
            } => {
                let prefix = format!("{} = ", signature(params));
                let value = self.term(term, depth, prefix.len());
                self.line_multiline(depth, &format!("{prefix}{value}"));
                self.block_items(&continuation.items, depth);
            }
        }
    }

    fn term(&mut self, term: &Term, depth: usize, prefix_width: usize) -> String {
        match term {
            Term::Lit(value) => literal(&value.value),
            Term::Ident(value) => self.ident(&value.name, &value.args, depth, prefix_width),
            Term::Lambda(value) => self.lambda(value, depth),
        }
    }

    fn ident(&mut self, name: &str, args: &[Arg], depth: usize, prefix_width: usize) -> String {
        if args.is_empty() {
            return name.to_string();
        }
        let rendered = args
            .iter()
            .map(|arg| self.arg(arg, depth + 1))
            .collect::<Vec<_>>();
        let inline = format!("{name}({})", rendered.join(", "));
        if !inline.contains('\n')
            && depth * INDENT_WIDTH + prefix_width + inline.chars().count() <= MAX_WIDTH
        {
            return inline;
        }

        if let Some(output) = self.comptime_string_dsl(name, args, depth, prefix_width, &rendered) {
            return output;
        }

        let padding = INDENT.repeat(depth + 1);
        let closing = INDENT.repeat(depth);
        let mut output = format!("{name}(\n");
        let arg_count = rendered.len();
        for (arg_index, arg) in rendered.into_iter().enumerate() {
            let line_count = arg.lines().count();
            for (index, line) in arg.lines().enumerate() {
                if index == 0 {
                    output.push_str(&padding);
                }
                output.push_str(line);
                if arg_index + 1 < arg_count && index + 1 == line_count {
                    output.push(',');
                }
                output.push('\n');
            }
        }
        output.push_str(&closing);
        output.push(')');
        output
    }

    fn comptime_string_dsl(
        &mut self,
        name: &str,
        args: &[Arg],
        depth: usize,
        prefix_width: usize,
        rendered_args: &[String],
    ) -> Option<String> {
        let first = args.first()?;
        if first.name.is_some()
            || !matches!(&first.term, Term::Lit(value) if matches!(value.value, Lit::Str(_)))
        {
            return None;
        }

        let chain = dsl_chain(&args.get(1)?.term)?;
        let first_line = format!("{name}({},", rendered_args.first()?);
        if first_line.contains('\n')
            || depth * INDENT_WIDTH + prefix_width + first_line.chars().count() > MAX_WIDTH
        {
            return None;
        }

        let padding = INDENT.repeat(depth + 1);
        let closing = INDENT.repeat(depth);
        let mut output = first_line;
        output.push('\n');

        for (index, ident) in chain.iter().enumerate() {
            let chain_args = if index + 1 == chain.len() {
                ident.args.as_slice()
            } else {
                &ident.args[..ident.args.len() - 1]
            };
            let line = self.ident(&ident.name, chain_args, depth + 1, 0);
            output.push_str(&padding);
            output.push_str(&line);
            if index + 1 == chain.len() && args.len() > 2 {
                output.push(',');
            }
            output.push('\n');
        }

        for (index, arg) in rendered_args.iter().enumerate().skip(2) {
            output.push_str(&padding);
            output.push_str(arg);
            if index + 1 < rendered_args.len() {
                output.push(',');
            }
            output.push('\n');
        }

        output.push_str(&closing);
        output.push(')');
        Some(output)
    }

    fn arg(&mut self, arg: &Arg, depth: usize) -> String {
        let value = self.term(
            &arg.term,
            depth,
            arg.name.as_ref().map_or(0, |name| name.len() + 2),
        );
        match &arg.name {
            Some(name) => format!("{name}: {value}"),
            None => value,
        }
    }

    fn lambda(&mut self, lambda: &Lambda, depth: usize) -> String {
        let mut nested = Formatter {
            output: String::new(),
            comments: Vec::new(),
            next_comment: 0,
        };
        nested.output.push_str(&signature(&lambda.params));
        nested.output.push_str(" {\n");
        nested.block_items(&lambda.body.items, depth + 1);
        nested.output.push_str(&INDENT.repeat(depth));
        nested.output.push('}');
        let mut output = nested.output;
        if !lambda.args.is_empty() {
            output.push_str(&self.render_application_args(&lambda.args, depth));
        }
        output
    }

    fn application_args(&mut self, args: &[Arg], depth: usize) {
        if args.is_empty() {
            return;
        }
        let suffix = self.render_application_args(args, depth);
        self.line_multiline(depth, &suffix);
    }

    fn render_application_args(&mut self, args: &[Arg], depth: usize) -> String {
        let rendered = args
            .iter()
            .map(|arg| self.arg(arg, depth + 1))
            .collect::<Vec<_>>();
        format!("({})", rendered.join(", "))
    }

    fn comments_before(&mut self, offset: usize, depth: usize) {
        while self
            .comments
            .get(self.next_comment)
            .is_some_and(|comment| comment.offset < offset)
        {
            self.write_comment(depth);
        }
    }

    fn remaining_comments(&mut self, depth: usize) {
        while self.next_comment < self.comments.len() {
            self.write_comment(depth);
        }
    }

    fn write_comment(&mut self, depth: usize) {
        let text = self.comments[self.next_comment].text.clone();
        for line in text.lines() {
            self.line(depth, line.trim());
        }
        self.next_comment += 1;
    }

    fn line(&mut self, depth: usize, value: &str) {
        self.output.push_str(&INDENT.repeat(depth));
        self.output.push_str(value);
        self.output.push('\n');
    }

    fn line_multiline(&mut self, depth: usize, value: &str) {
        for (index, line) in value.lines().enumerate() {
            if index == 0 {
                self.output.push_str(&INDENT.repeat(depth));
            }
            self.output.push_str(line);
            self.output.push('\n');
        }
    }
}

fn dsl_chain(term: &Term) -> Option<Vec<&Ident>> {
    let mut ident = match term {
        Term::Ident(ident) => ident,
        _ => return None,
    };
    let mut chain = Vec::new();

    loop {
        chain.push(ident);
        if ident.args.is_empty() {
            return (chain.len() > 1).then_some(chain);
        }
        let tail = ident.args.last()?;
        if tail.name.is_some() {
            return None;
        }
        let Term::Ident(next) = &tail.term else {
            return None;
        };
        ident = next;
    }
}

fn signature(value: &Signature) -> String {
    let items = value
        .items
        .iter()
        .map(|item| {
            let mut kind = sig_kind(&item.kind);
            if item.is_comptime {
                kind.push('!');
            }
            if item.name.is_empty() {
                kind
            } else {
                format!("{}: {kind}", item.name)
            }
        })
        .collect::<Vec<_>>()
        .join(", ");
    format!("({items})")
}

fn generics(value: &Signature) -> String {
    if value.generics.is_empty() {
        String::new()
    } else {
        format!(
            "<{}>",
            value
                .generics
                .iter()
                .cloned()
                .collect::<Vec<_>>()
                .join(", ")
        )
    }
}

fn sig_kind(value: &SigKind) -> String {
    match value {
        SigKind::Byte => "@byte".to_string(),
        SigKind::Int => "@int".to_string(),
        SigKind::Str => "@str".to_string(),
        SigKind::F64 => "@f64".to_string(),
        SigKind::Ident(value) => value.name.clone(),
        SigKind::Sig(value) => signature(value),
        SigKind::GenericInst { name, args } => format!(
            "{name}<{}>",
            args.iter().map(sig_kind).collect::<Vec<_>>().join(", ")
        ),
        SigKind::Generic(name) => name.clone(),
    }
}

fn literal(value: &Lit) -> String {
    match value {
        Lit::Str(value) => quoted(value),
        Lit::Int(value) => value.to_string(),
        Lit::F64(value) => format!("{value:?}"),
    }
}

fn quoted(value: &str) -> String {
    let mut output = String::from("\"");
    for ch in value.chars() {
        match ch {
            '\"' => output.push_str("\\\""),
            '\\' => output.push_str("\\\\"),
            '\0' => output.push_str("\\0"),
            '\n' => output.push_str("\\n"),
            '\r' => output.push_str("\\r"),
            '\t' => output.push_str("\\t"),
            ch if ch.is_control() => write!(output, "\\u{{{:x}}}", ch as u32).unwrap(),
            ch => output.push(ch),
        }
    }
    output.push('\"');
    output
}

fn comments(source: &str) -> Vec<Comment> {
    let bytes = source.as_bytes();
    let mut comments = Vec::new();
    let mut index = 0;
    let mut string = None;
    while index < bytes.len() {
        match (string, bytes[index]) {
            (Some(b'\"'), b'\\') => index += 2,
            (Some(delimiter), byte) if byte == delimiter => {
                string = None;
                index += 1;
            }
            (Some(_), _) => index += 1,
            (None, byte @ (b'\"' | b'\'')) => {
                string = Some(byte);
                index += 1;
            }
            (None, b'/') if bytes.get(index + 1) == Some(&b'/') => {
                let start = index;
                index += 2;
                while index < bytes.len() && !matches!(bytes[index], b'\n' | b'\r') {
                    index += 1;
                }
                comments.push(Comment {
                    offset: start,
                    text: source
                        .get(start..index)
                        .expect("comment boundaries must be valid UTF-8")
                        .to_string(),
                });
            }
            (None, b'/') if bytes.get(index + 1) == Some(&b'*') => {
                let start = index;
                index += 2;
                while index + 1 < bytes.len() && !(bytes[index] == b'*' && bytes[index + 1] == b'/')
                {
                    index += 1;
                }
                index = (index + 2).min(bytes.len());
                comments.push(Comment {
                    offset: start,
                    text: source
                        .get(start..index)
                        .expect("comment boundaries must be valid UTF-8")
                        .to_string(),
                });
            }
            // The frontend treats a non-comment slash as a source path and
            // consumes through the line (or a semicolon). Do the same here so
            // a path containing `//` is never mistaken for a comment.
            (None, b'/') => {
                index += 1;
                while index < bytes.len() && !matches!(bytes[index], b'\n' | b'\r' | b';') {
                    index += 1;
                }
            }
            _ => index += 1,
        }
    }
    comments
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn applies_canonical_spacing_and_indentation() {
        let source = "main:(){\r\nvalue:'hello'\r\n@write( value )\r\n}\r\n";
        assert_eq!(
            format_source(source).unwrap(),
            "main: () {\n\tvalue: \"hello\"\n\t@write(value)\n}\n"
        );
    }

    #[test]
    fn formatting_is_idempotent() {
        let source = "main: (ok:()) {\n\tmessage: @write(\"hello\", ok)\n\t@write(message)\n}\n";
        let once = format_source(source).unwrap();
        assert_eq!(format_source(&once).unwrap(), once);
    }

    #[test]
    fn preserves_comments() {
        let source = "// entry\nmain: () { // body\n    @exit(0)\n}\n";
        let formatted = format_source(source).unwrap();
        assert!(formatted.contains("// entry"));
        assert!(formatted.contains("// body"));
        assert_eq!(formatted.matches("//").count(), 2);
    }

    #[test]
    fn rejects_invalid_source() {
        assert!(format_source("main: () {").is_err());
    }

    #[test]
    fn source_paths_that_contain_slashes_are_not_comments() {
        assert_eq!(
            format_source("pkg:/vendor//generated\n").unwrap(),
            "pkg: /vendor//generated\n"
        );
    }

    #[test]
    fn replaces_inconsistent_space_indentation_with_tabs() {
        let source = r#"fmt: /std/fmt
calc: /std/math/calc

main: () {
    (result: @f64) = calc.new("hypot(width, height) + sin(pi / 2) ^ 2",
        calc.var("width", 3.0)
        calc.var("height", 4.0)
         calc.end
    )
    (message: @str) = fmt.new("result: %\n", fmt.f64(result) fmt.end)
    @write(message)
    @exit(0)
}
"#;
        let formatted = format_source(source).unwrap();
        for line in formatted
            .lines()
            .filter(|line| line.starts_with(char::is_whitespace))
        {
            assert!(line.starts_with('\t'), "line is not tab-indented: {line:?}");
            assert!(!line.starts_with(' '), "line starts with spaces: {line:?}");
        }
        assert!(!formatted.contains("         calc.end"));
        assert_eq!(format_source(&formatted).unwrap(), formatted);
    }

    #[test]
    fn keeps_comptime_string_dsl_chains_vertical() {
        let source = r#"main: () {
	(result: @f64) = calc.new(
		"hypot(width, height) + sin(pi / 2) ^ 2",
		calc.var("width", 3.0, calc.var("height", 4.0, calc.end))
	)
	@exit(0)
}
"#;
        let expected = r#"main: () {
	(result: @f64) = calc.new("hypot(width, height) + sin(pi / 2) ^ 2",
		calc.var("width", 3.0)
		calc.var("height", 4.0)
		calc.end
	)
	@exit(0)
}
"#;

        let formatted = format_source(source).unwrap();
        assert_eq!(formatted, expected);
        assert_eq!(format_source(&formatted).unwrap(), formatted);
    }
}
