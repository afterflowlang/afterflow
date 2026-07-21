use std::io::Cursor;

use super::error::Code;
use super::lexer::Lexer;
use super::token::TokenKind;

#[test]
fn lexer_test() {
    let source = include_bytes!("lexer_test.af");
    let cursor = Cursor::new(&source[..]);
    let mut lexer = Lexer::new(cursor);
    let ident = |name: &str| TokenKind::Ident(name.to_string());
    let builtin = |name: &str| TokenKind::Builtin(name.to_string());
    let str_lit = |value: &str| TokenKind::StringLiteral(value.to_string());

    let expected_tokens = vec![
        ident("str"),
        TokenKind::Colon,
        builtin("str"),
        TokenKind::Newline,
        ident("printf"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("fmt"),
        TokenKind::Colon,
        ident("str"),
        TokenKind::Comma,
        ident("ok"),
        TokenKind::Colon,
        TokenKind::LParen,
        TokenKind::RParen,
        TokenKind::RParen,
        TokenKind::LBrace,
        TokenKind::Newline,
        builtin("write"),
        TokenKind::LParen,
        ident("fmt"),
        TokenKind::Comma,
        ident("ok"),
        TokenKind::RParen,
        TokenKind::Newline,
        TokenKind::RBrace,
        TokenKind::Newline,
        ident("foo"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("ok"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("str"),
        TokenKind::RParen,
        TokenKind::RParen,
        TokenKind::LBrace,
        TokenKind::Newline,
        ident("ok"),
        TokenKind::LParen,
        str_lit("charlie"),
        TokenKind::RParen,
        TokenKind::Newline,
        TokenKind::RBrace,
        TokenKind::Newline,
        ident("baz"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("ok"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("str"),
        TokenKind::Comma,
        ident("str"),
        TokenKind::RParen,
        TokenKind::RParen,
        TokenKind::LBrace,
        TokenKind::Newline,
        ident("foo"),
        TokenKind::LParen,
        ident("ok"),
        TokenKind::LParen,
        str_lit("bob"),
        TokenKind::RParen,
        TokenKind::RParen,
        TokenKind::Newline,
        TokenKind::RBrace,
        TokenKind::Newline,
        ident("bar"),
        TokenKind::Colon,
        TokenKind::LParen,
        ident("name0"),
        TokenKind::Colon,
        ident("str"),
        TokenKind::Comma,
        ident("name1"),
        TokenKind::Colon,
        ident("str"),
        TokenKind::Comma,
        ident("name2"),
        TokenKind::Colon,
        ident("str"),
        TokenKind::RParen,
        TokenKind::LBrace,
        TokenKind::Newline,
        ident("printf"),
        TokenKind::LParen,
        str_lit("hello %s, %s and %s\n"),
        TokenKind::Comma,
        ident("name0"),
        TokenKind::Comma,
        ident("name1"),
        TokenKind::Comma,
        ident("name2"),
        TokenKind::RParen,
        TokenKind::Newline,
        TokenKind::RBrace,
        TokenKind::Newline,
        ident("baz"),
        TokenKind::LParen,
        ident("bar"),
        TokenKind::LParen,
        str_lit("alice"),
        TokenKind::RParen,
        TokenKind::RParen,
        TokenKind::Newline,
        TokenKind::Eof,
    ];

    let mut actual_tokens = Vec::new();

    loop {
        let token = lexer.next_token().expect("lexer should succeed");
        let is_eof = matches!(token.kind, TokenKind::Eof);
        actual_tokens.push(token.kind);
        if is_eof {
            break;
        }
    }

    assert_eq!(
        actual_tokens, expected_tokens,
        "lexer should produce the exact token stream for lexer_test.af"
    );
}

fn lex_single_string(source: &[u8]) -> String {
    let cursor = Cursor::new(source);
    let mut lexer = Lexer::new(cursor);
    let token = lexer.next_token().expect("lexer should produce a token");
    match token.kind {
        TokenKind::StringLiteral(value) => value,
        other => panic!("expected string literal, got {:?}", other),
    }
}

#[test]
fn single_quote_strings_preserve_backslashes() {
    let literal = lex_single_string(b"'raw\\n'");
    assert_eq!(literal, "raw\\n");
}

#[test]
fn double_quote_strings_support_unicode_and_escapes() {
    let literal = lex_single_string("\"é😀\\u{1F600}\\n\"".as_bytes());
    assert_eq!(literal, "é😀\u{1F600}\n");
}

#[test]
fn invalid_double_quote_escape_is_rejected() {
    let cursor = Cursor::new(b"\"bad\\x\"");
    let mut lexer = Lexer::new(cursor);
    assert!(lexer.next_token().is_err());
}

#[test]
fn repeated_dots_are_rejected() {
    let cursor = Cursor::new(b"...");
    let mut lexer = Lexer::new(cursor);
    assert!(lexer.next_token().is_err());
}

#[test]
fn integer_literals_must_fit_the_target_integer_type() {
    let source = format!("{}0", isize::MAX);
    let mut lexer = Lexer::new(Cursor::new(source));

    let error = lexer
        .next_token()
        .expect_err("out-of-range integer literals should fail");
    assert_eq!(error.code, Code::Lex);
    assert_eq!(error.message, "invalid integer literal");
}

#[test]
fn source_paths_start_with_slash() {
    let cursor = Cursor::new(b"math: /math\n");
    let mut lexer = Lexer::new(cursor);

    let actual_tokens = [
        lexer.next_token().expect("should lex namespace"),
        lexer.next_token().expect("should lex colon"),
        lexer.next_token().expect("should lex source path"),
        lexer.next_token().expect("should lex newline"),
    ];

    assert_eq!(actual_tokens[0].kind, TokenKind::Ident("math".to_string()));
    assert_eq!(actual_tokens[1].kind, TokenKind::Colon);
    assert_eq!(
        actual_tokens[2].kind,
        TokenKind::SourcePath("/math".to_string())
    );
    assert_eq!(actual_tokens[3].kind, TokenKind::Newline);
}

#[test]
fn source_paths_cannot_use_the_builtin_marker() {
    let cursor = Cursor::new(b"@/math");
    let mut lexer = Lexer::new(cursor);

    let error = lexer
        .next_token()
        .expect_err("source paths should start with slash");
    assert_eq!(error.code, Code::Lex);
    assert_eq!(error.message, "builtin references use @name");
}

#[test]
fn block_comments_are_skipped_and_preserve_newline_tokens() {
    let cursor = Cursor::new(b"foo/* inline */bar\nbaz/* across\n lines */qux");
    let mut lexer = Lexer::new(cursor);

    let mut actual_tokens = Vec::new();
    loop {
        let token = lexer.next_token().expect("lexer should succeed");
        let is_eof = matches!(token.kind, TokenKind::Eof);
        actual_tokens.push(token.kind);
        if is_eof {
            break;
        }
    }

    assert_eq!(
        actual_tokens,
        vec![
            TokenKind::Ident("foo".to_string()),
            TokenKind::Ident("bar".to_string()),
            TokenKind::Newline,
            TokenKind::Ident("baz".to_string()),
            TokenKind::Newline,
            TokenKind::Ident("qux".to_string()),
            TokenKind::Eof,
        ]
    );
}

#[test]
fn unterminated_block_comments_are_rejected() {
    let cursor = Cursor::new(b"/* missing end");
    let mut lexer = Lexer::new(cursor);

    let error = lexer
        .next_token()
        .expect_err("unterminated block comments should fail");
    assert_eq!(error.code, Code::Lex);
    assert_eq!(error.message, "unterminated block comment");
    assert_eq!(error.span.line, 1);
    assert_eq!(error.span.column, 1);
}
