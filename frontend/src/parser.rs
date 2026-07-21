use std::collections::{BTreeSet, HashSet, VecDeque};
use std::io::BufRead;

use crate::ast;
use crate::ast::{Block, BlockItem, Ident, Lambda, Literal, SigIdent, SigKind, Signature, Term};
use crate::builtins;
use crate::error::{Code, Error};
use crate::lexer::Lexer;
use crate::span::Span;
use crate::token::{Token, TokenKind};

pub struct Parser<R: BufRead> {
    lexer: Lexer<R>,
    peeked: VecDeque<Token>,
    source_namespaces: HashSet<String>,
    block_depth: usize,
    generic_param_stack: Vec<BTreeSet<String>>,
}

#[derive(Copy, Clone)]
enum ParamContext {
    Params,
    Lambda,
}

impl<R: BufRead> Parser<R> {
    pub fn new(lexer: Lexer<R>) -> Self {
        Self {
            lexer,
            peeked: VecDeque::new(),
            source_namespaces: HashSet::new(),
            block_depth: 0,
            generic_param_stack: Vec::new(),
        }
    }

    // TODO: iter
    // fn iter<'a>(
    //     &'a mut self,
    //     symbols: &'a mut SymbolRegistry,
    // ) -> impl Iterator<Item = Result<BlockItem, CompileError>> + 'a {
    //     std::iter::from_fn(move || match self.next(symbols) {
    //         Ok(Some(item)) => Some(Ok(item)),
    //         Ok(None) => None,
    //         Err(e) => Some(Err(e)),
    //     })
    // }

    pub fn next_block_item(&mut self) -> Result<Option<BlockItem>, Error> {
        self.skip_newlines()?;
        let token = self.peek_token()?.clone();
        match token.kind {
            TokenKind::Eof => Ok(None),
            _ => {
                let item = self.parse_block_item()?;
                self.consume_block_item_separators()?;
                Ok(Some(item))
            }
        }
    }

    fn skip_newlines(&mut self) -> Result<(), Error> {
        while self
            .consume_if(|k| matches!(k, TokenKind::Newline))?
            .is_some()
        {}
        Ok(())
    }

    fn parse_block_item(&mut self) -> Result<BlockItem, Error> {
        self.skip_newlines()?;
        let token = self.peek_token()?.clone();
        let span: Span = token.span;
        match token.kind {
            TokenKind::SourcePath(path) => {
                return Err(Error::new(
                    Code::Parse,
                    format!("source package '{path}' must be bound as 'name: {path}'"),
                    token.span,
                ));
            }
            TokenKind::Ident(name) => {
                let ident = self.bump()?; // Might be the name
                if matches!(self.peek_token()?.kind, TokenKind::Colon) {
                    self.bump()?; // consume colon
                    return self.parse_bind(name, span);
                }

                // Must be an exec
                self.peeked.push_front(ident); // restore token to attempt exec parse
            }
            TokenKind::Builtin(name) => {
                let builtin = self.bump()?;
                if matches!(self.peek_token()?.kind, TokenKind::Colon) {
                    if self.block_depth != 0 {
                        return Err(Error::new(
                            Code::Parse,
                            "builtin overrides are only allowed at the file root",
                            span,
                        ));
                    }
                    self.bump()?;
                    return self.parse_bind(format!("@{name}"), span);
                }
                self.peeked.push_front(builtin);
            }
            TokenKind::LParen => {
                return self.parse_lambda_or_scope_capture();
            }
            TokenKind::Newline => {}
            _ => return Err(Error::new(Code::Parse, "expected a top-level item", span)),
        }

        let term = self.parse_value(None)?;
        self.block_item_from_exec_term(term)
    }

    fn block_item_from_exec_term(&self, term: Term) -> Result<BlockItem, Error> {
        match term {
            Term::Lit(literal) => Err(Error::new(
                Code::Parse,
                "literals cannot be called yet",
                literal.span,
            )),
            Term::Ident(ident) => Ok(BlockItem::Ident(ident)),
            Term::Lambda(lambda) => Ok(BlockItem::Lambda(lambda)),
        }
    }

    fn parse_bind(&mut self, name: String, name_span: Span) -> Result<BlockItem, Error> {
        if let TokenKind::SourcePath(path) = self.peek_token()?.kind.clone() {
            self.require_root_source_import(name_span)?;
            self.add_source_namespace(&name, name_span)?;
            self.bump()?;
            return Ok(BlockItem::Import {
                label: name,
                path,
                span: name_span,
            });
        }

        let generics = self.parse_generic_params()?;
        let next_token = self.peek_token()?.clone();
        let has_head = matches!(next_token.kind, TokenKind::LParen);
        let has_brace = matches!(next_token.kind, TokenKind::LBrace);

        if has_brace {
            return Err(Error::new(
                Code::Parse,
                "function definitions require a parameter list before the body block",
                next_token.span,
            ));
        }

        if has_head {
            let mut params = self.with_generic_scope(&generics, |parser| {
                parser.parse_params(ParamContext::Params)
            })?;

            if matches!(self.peek_token()?.kind, TokenKind::LBrace) {
                // FUNCTION CASE
                params.generics = generics.clone();

                let brace = self.expect_token("{", |k| matches!(k, TokenKind::LBrace))?;
                let body = self.parse_body(brace.span)?;
                self.expect_token("}", |k| matches!(k, TokenKind::RBrace))?;
                let lambda = Lambda {
                    params,
                    body,
                    args: Vec::new(),
                    span: name_span,
                };

                return Ok(BlockItem::FunctionDef {
                    name,
                    lambda,
                    span: name_span,
                });
            }

            for item in &mut params.items {
                item.name.clear();
            }
            params.generics = generics.clone();
            return Ok(BlockItem::SigDef {
                name,
                sig: params,
                span: name_span,
            });
        }

        // Case 2: alias or literal (no params or body block)
        let term = self.parse_value(Some(name_span.column))?;
        let term_span = term.span();
        match term {
            Term::Lit(literal) => Ok(BlockItem::LitDef {
                name,
                literal,
                span: name_span,
            }),
            Term::Ident(ident) => Ok(BlockItem::IdentDef {
                name,
                ident,
                span: name_span,
            }),
            _ => Err(Error::new(
                Code::Parse,
                "expected a literal or identifier alias on the right-hand side",
                term_span,
            )),
        }
    }

    fn parse_lambda_or_scope_capture(&mut self) -> Result<BlockItem, Error> {
        // 1. Parse params ALWAYS
        let params = self.parse_params(ParamContext::Lambda)?;

        // 2. Decide based on the next token
        match self.peek_token()?.kind {
            TokenKind::Equals => {
                self.bump()?; // consume '='
                let term = self.parse_term()?;
                let continuation = self.parse_body(params.span)?;
                Ok(BlockItem::ScopeCapture {
                    params: params.clone(),
                    continuation,
                    term,
                    span: params.span,
                })
            }
            TokenKind::LBrace => {
                let brace = self.expect_token("{", |kind| matches!(kind, TokenKind::LBrace))?;
                let body = self.parse_body(brace.span)?;
                self.expect_token("}", |kind| matches!(kind, TokenKind::RBrace))?;
                let term = Term::Lambda(Lambda {
                    params,
                    body,
                    args: Vec::new(),
                    span: brace.span,
                });
                let term = self.parse_application_suffixes(term)?;
                self.block_item_from_exec_term(term)
            }

            _ => Err(Error::new(
                Code::Parse,
                "expected '=' or '{' after parameter list",
                params.span,
            )),
        }
    }

    fn parse_term(&mut self) -> Result<Term, Error> {
        let term = self.parse_head()?;
        self.parse_application_suffixes(term)
    }

    fn parse_application_suffixes(&mut self, mut term: Term) -> Result<Term, Error> {
        while matches!(self.peek_token()?.kind, TokenKind::LParen) {
            let lparen = self.bump()?; // consume '('
            let args = self.parse_argument_list()?;
            Self::append_args(&mut term, args, lparen.span)?;
        }

        Ok(term)
    }

    fn parse_value(&mut self, newline_boundary: Option<usize>) -> Result<Term, Error> {
        let mut term = self.parse_term()?;
        if self.consume_value_whitespace(newline_boundary)? {
            let argument = self.parse_value(newline_boundary)?;
            let span = argument.span();
            let arg = ast::Arg {
                name: None,
                term: argument,
                span,
            };
            let term_span = term.span();
            Self::append_args(&mut term, vec![arg], term_span)?;
        }
        Ok(term)
    }

    fn append_args(term: &mut Term, args: Vec<ast::Arg>, span: Span) -> Result<(), Error> {
        match term {
            Term::Ident(ident) => ident.args.extend(args),
            Term::Lambda(lambda) => lambda.args.extend(args),
            Term::Lit(_) => {
                return Err(Error::new(
                    Code::Parse,
                    "expected identifier or lambda before argument list",
                    span,
                ));
            }
        }
        Ok(())
    }

    fn consume_value_whitespace(&mut self, newline_boundary: Option<usize>) -> Result<bool, Error> {
        if !matches!(self.peek_token()?.kind, TokenKind::Newline) {
            return Ok(self.peek_token()?.has_leading_whitespace && self.is_value_head(0)?);
        }

        let mut newline_count = 0;
        while matches!(self.peek_nth(newline_count)?.kind, TokenKind::Newline) {
            newline_count += 1;
        }
        let next = self.peek_nth(newline_count)?.clone();
        if newline_boundary.is_some_and(|column| next.span.column <= column)
            || !self.is_value_head(newline_count)?
        {
            return Ok(false);
        }
        for _ in 0..newline_count {
            self.bump()?;
        }
        Ok(true)
    }

    fn is_value_head(&mut self, offset: usize) -> Result<bool, Error> {
        let token = self.peek_nth(offset)?.clone();
        if matches!(token.kind, TokenKind::Ident(_))
            && matches!(self.peek_nth(offset + 1)?.kind, TokenKind::Colon)
        {
            return Ok(false);
        }
        if matches!(token.kind, TokenKind::LParen) {
            return self.is_lambda_head(offset);
        }
        Ok(matches!(
            token.kind,
            TokenKind::Ident(_)
                | TokenKind::Builtin(_)
                | TokenKind::IntLiteral(_)
                | TokenKind::FloatLiteral(_)
                | TokenKind::StringLiteral(_)
        ))
    }

    fn is_lambda_head(&mut self, offset: usize) -> Result<bool, Error> {
        let mut depth = 0;
        let mut index = offset;
        loop {
            match self.peek_nth(index)?.kind {
                TokenKind::LParen => depth += 1,
                TokenKind::RParen => {
                    depth -= 1;
                    if depth == 0 {
                        return Ok(matches!(self.peek_nth(index + 1)?.kind, TokenKind::LBrace));
                    }
                }
                TokenKind::Eof => return Ok(false),
                _ => {}
            }
            index += 1;
        }
    }

    fn parse_head(&mut self) -> Result<Term, Error> {
        self.skip_newlines()?;
        let token = self.bump()?;
        match token.kind {
            TokenKind::IntLiteral(value) => Ok(Term::Lit(Literal {
                value: ast::Lit::Int(value),
                span: token.span,
            })),
            TokenKind::FloatLiteral(value) => Ok(Term::Lit(Literal {
                value: ast::Lit::F64(value),
                span: token.span,
            })),
            TokenKind::StringLiteral(value) => Ok(Term::Lit(Literal {
                value: ast::Lit::Str(value),
                span: token.span,
            })),
            TokenKind::Ident(name) => Ok(Term::Ident(Ident {
                name: self.parse_qualified_name(name)?,
                args: Vec::new(),
                span: token.span,
            })),
            TokenKind::Builtin(name) => Ok(Term::Ident(Ident {
                name: self.parse_builtin_name(name, token.span)?,
                args: Vec::new(),
                span: token.span,
            })),
            TokenKind::SourcePath(_) => Err(Error::new(
                Code::Parse,
                "source packages are only valid as file-root namespace bindings",
                token.span,
            )),
            TokenKind::LParen => {
                // (parameters) { body } → lambda with params
                self.peeked.push_front(token.clone());
                let params = self.parse_params(ParamContext::Lambda)?;
                let brace = self.expect_token("{", |kind| matches!(kind, TokenKind::LBrace))?;
                let body = self.parse_body(brace.span)?;
                self.expect_token("}", |k| matches!(k, TokenKind::RBrace))?;
                Ok(Term::Lambda(Lambda {
                    params,
                    body,
                    args: Vec::new(),
                    span: token.span,
                }))
            }
            _ => Err(Error::new(
                Code::Parse,
                format!("unexpected token: {:?}", token.kind),
                token.span,
            )),
        }
    }

    fn parse_argument_list(&mut self) -> Result<Vec<ast::Arg>, Error> {
        let mut args = Vec::new();
        self.skip_newlines()?;
        if matches!(self.peek_token()?.kind, TokenKind::RParen) {
            self.bump()?;
            return Ok(args);
        }
        loop {
            self.skip_newlines()?;
            args.push(self.parse_call_arg()?);
            self.skip_newlines()?;
            if self
                .consume_if(|kind| matches!(kind, TokenKind::Comma))?
                .is_some()
            {
                continue;
            }
            break;
        }
        self.skip_newlines()?;
        self.expect_token(")", |kind| matches!(kind, TokenKind::RParen))?;
        Ok(args)
    }

    fn parse_call_arg(&mut self) -> Result<ast::Arg, Error> {
        let first = self.peek_token()?.clone();
        if let TokenKind::Ident(name) = first.kind {
            let second = self.peek_nth(1)?.clone();
            if matches!(second.kind, TokenKind::Colon) {
                let span = self.bump()?.span;
                self.expect_token(":", |kind| matches!(kind, TokenKind::Colon))?;
                let term = self.parse_value(None)?;
                return Ok(ast::Arg {
                    name: Some(name),
                    term,
                    span,
                });
            }
        }
        let term = self.parse_value(None)?;
        let span = term.span();
        Ok(ast::Arg {
            name: None,
            term,
            span,
        })
    }
    fn parse_sig_item(&mut self, context: ParamContext) -> Result<ast::SigItem, Error> {
        let item_span = self.peek_token()?.span;
        let token = self.peek_token()?.clone();

        let (name, ty) = if matches!(token.kind, TokenKind::Ident(_)) {
            let (name, name_span) = self.parse_identifier("parameter name")?;

            // Case: name: Type
            if matches!(self.peek_token()?.kind, TokenKind::Colon) {
                self.expect_token(":", |kind| matches!(kind, TokenKind::Colon))?;
                (Some(name), self.parse_type_kind()?)
            } else {
                match context {
                    ParamContext::Params => {
                        // Put back IDENT so parse_type_ref sees it
                        self.peeked.push_front(token);
                        (None, self.parse_type_kind()?)
                    }
                    ParamContext::Lambda => {
                        return Err(Error::new(
                            Code::Parse,
                            "lambda parameters must have a type",
                            name_span,
                        ));
                    }
                }
            }
        } else {
            // Pure type-only parameter: `int`, `str`, `(a:int)`
            (None, self.parse_type_kind()?)
        };

        let is_comptime = self
            .consume_if(|kind| matches!(kind, TokenKind::Bang))?
            .is_some();

        Ok(ast::SigItem {
            name: name.unwrap_or_default(),
            kind: ty,
            is_comptime,
            span: item_span,
        })
    }

    fn parse_generic_params(&mut self) -> Result<BTreeSet<String>, Error> {
        if !matches!(self.peek_token()?.kind, TokenKind::AngleOpen) {
            return Ok(BTreeSet::new());
        }
        let lt = self.expect_token("<", |kind| matches!(kind, TokenKind::AngleOpen))?;
        let mut params = BTreeSet::new();
        loop {
            let (name, span) = self.parse_identifier("generic parameter name")?;
            if !params.insert(name.clone()) {
                return Err(Error::new(
                    Code::Parse,
                    format!("generic parameter '{}' already declared", name),
                    span,
                ));
            }
            if self
                .consume_if(|kind| matches!(kind, TokenKind::Comma))?
                .is_none()
            {
                break;
            }
        }
        self.expect_token(">", |kind| matches!(kind, TokenKind::AngleClose))?;
        if params.is_empty() {
            return Err(Error::new(
                Code::Parse,
                "expected at least one generic parameter",
                lt.span,
            ));
        }
        Ok(params)
    }

    fn with_generic_scope<F, Res>(&mut self, params: &BTreeSet<String>, f: F) -> Result<Res, Error>
    where
        F: FnOnce(&mut Self) -> Result<Res, Error>,
    {
        self.generic_param_stack.push(params.clone());
        let result = f(self);
        self.generic_param_stack.pop();
        result
    }

    fn is_generic_param(&self, name: &str) -> bool {
        self.generic_param_stack
            .iter()
            .rev()
            .any(|scope| scope.contains(name))
    }

    fn parse_type_arguments(&mut self) -> Result<Vec<ast::SigKind>, Error> {
        self.expect_token("<", |kind| matches!(kind, TokenKind::AngleOpen))?;
        let mut args = Vec::new();
        loop {
            let ty = self.parse_type_kind()?;
            args.push(ty);
            if self
                .consume_if(|kind| matches!(kind, TokenKind::Comma))?
                .is_none()
            {
                break;
            }
        }
        self.expect_token(">", |kind| matches!(kind, TokenKind::AngleClose))?;
        Ok(args)
    }
    fn parse_type_kind(&mut self) -> Result<ast::SigKind, Error> {
        let token = self.bump()?;
        let span = token.span;
        match token.kind {
            TokenKind::LParen => {
                let lparen = token;
                let mut args = Vec::new();
                if !matches!(self.peek_token()?.kind, TokenKind::RParen) {
                    loop {
                        args.push(self.parse_sig_item(ParamContext::Params)?);
                        if self
                            .consume_if(|kind| matches!(kind, TokenKind::Comma))?
                            .is_some()
                        {
                            continue;
                        }
                        break;
                    }
                }
                self.expect_token(")", |kind| matches!(kind, TokenKind::RParen))?;
                let kind = SigKind::Sig(Signature {
                    items: args,
                    span: lparen.span,
                    generics: BTreeSet::new(),
                });
                Ok(kind)
            }
            TokenKind::Ident(name) => {
                let name = self.parse_qualified_name(name)?;
                if self.is_generic_param(&name) {
                    return Ok(SigKind::Generic(name));
                }

                if matches!(self.peek_token()?.kind, TokenKind::AngleOpen) {
                    let args = self.parse_type_arguments()?;
                    // TODO: Not parsers job
                    // if let Some(info) = symbols.get_type_info(&name) {
                    //     if info.generics.len() != args.len() {
                    //         return Err(CompileError::new(CompileErrorCode::Parse,
                    //             format!(
                    //                 "type '{}' expects {} generic arguments but got {}",
                    //                 name,
                    //                 info.generics.len(),
                    //                 args.len()
                    //             ),
                    //             span,
                    //         )
                    //         .into());
                    //     }
                    // } else if resolved_type.is_some() {
                    //     return Err(CompileError::new(CompileErrorCode::Parse,
                    //         format!("type '{}' is not generic", name),
                    //         span,
                    //     )
                    //     .into());
                    // } else {
                    //     return Err(
                    //         CompileError::new(CompileErrorCode::Parse, format!("unknown type '{}'", name), span).into()
                    //     );
                    // }
                    return Ok(SigKind::GenericInst { name, args });
                }

                // TODO: Not parsers job
                // let resolved_type = symbols.resolve_type(&name);
                // if let Some(ty) = resolved_type {
                //     if let SigKind::Ident(ident) = &ty {
                //         let alias_name = &ident.name;
                //         if let Some(info) = symbols.get_type_info(alias_name) {
                //             if !info.generics.is_empty() {
                //                 return Err(CompileError::new(CompileErrorCode::Parse,
                //                     format!("generic type '{}' must be specialized", alias_name),
                //                     span,
                //                 )
                //                 .into());
                //             }
                //         }
                //     }
                //     return Ok(ast::SigKind { kind: ty, span });
                // }
                // return Err(CompileError::new(CompileErrorCode::Parse, format!("unknown type '{}'", name), span).into());
                Ok(SigKind::Ident(SigIdent { name, span }))
            }
            TokenKind::Builtin(name) => Ok(SigKind::Ident(SigIdent {
                name: self.parse_builtin_name(name, span)?,
                span,
            })),
            TokenKind::SourcePath(_) => Err(Error::new(
                Code::Parse,
                "source packages are only valid as file-root namespace bindings",
                span,
            )),
            _ => Err(Error::new(Code::Parse, "expected a type", span)),
        }
    }

    fn parse_params(&mut self, context: ParamContext) -> Result<Signature, Error> {
        let lparen = self.expect_token("(", |k| matches!(k, TokenKind::LParen))?;

        let mut params = Vec::new();
        loop {
            if matches!(self.peek_token()?.kind, TokenKind::RParen) {
                break;
            }

            params.push(self.parse_sig_item(context)?);

            if self
                .consume_if(|kind| matches!(kind, TokenKind::Comma))?
                .is_none()
            {
                break;
            }
        }

        self.expect_token(")", |k| matches!(k, TokenKind::RParen))?;
        Ok(Signature {
            items: params,
            span: lparen.span,
            generics: BTreeSet::new(),
        })
    }

    fn parse_identifier(&mut self, expected: &str) -> Result<(String, Span), Error> {
        let token = self.bump()?;
        match token.kind {
            TokenKind::Ident(name) => Ok((name, token.span)),
            _ => Err(Error::new(
                Code::Parse,
                format!("expected {}", expected),
                token.span,
            )),
        }
    }

    fn parse_qualified_name(&mut self, mut name: String) -> Result<String, Error> {
        while self
            .consume_if(|kind| matches!(kind, TokenKind::Dot))?
            .is_some()
        {
            let (member, _) = self.parse_identifier("identifier after '.'")?;
            name.push('.');
            name.push_str(&member);
        }
        Ok(name)
    }

    fn parse_builtin_name(&self, name: String, span: Span) -> Result<String, Error> {
        if builtins::get_spec(&name).is_none() {
            return Err(Error::new(
                Code::Parse,
                format!("unknown builtin '@{name}'"),
                span,
            ));
        }
        Ok(format!("@{name}"))
    }

    fn require_root_source_import(&self, span: Span) -> Result<(), Error> {
        if self.block_depth != 0 {
            return Err(Error::new(
                Code::Parse,
                "source package bindings are only allowed at the file root",
                span,
            ));
        }
        Ok(())
    }

    fn add_source_namespace(&mut self, namespace: &str, span: Span) -> Result<(), Error> {
        if !self.source_namespaces.insert(namespace.to_string()) {
            return Err(Error::new(
                Code::Parse,
                format!("duplicate import namespace '{namespace}'"),
                span,
            ));
        }
        Ok(())
    }

    fn expect_token<F>(&mut self, expected: &str, predicate: F) -> Result<Token, Error>
    where
        F: Fn(&TokenKind) -> bool,
    {
        let token = self.bump()?;
        if predicate(&token.kind) {
            Ok(token)
        } else {
            Err(Error::new(
                Code::Parse,
                format!("expected {}", expected),
                token.span,
            ))
        }
    }

    fn consume_if<F>(&mut self, predicate: F) -> Result<Option<Token>, Error>
    where
        F: Fn(&TokenKind) -> bool,
    {
        if predicate(&self.peek_token()?.kind) {
            Ok(Some(self.bump()?))
        } else {
            Ok(None)
        }
    }

    fn bump(&mut self) -> Result<Token, Error> {
        if let Some(token) = self.peeked.pop_front() {
            return Ok(token);
        }
        self.lexer.next_token()
    }

    fn peek_token(&mut self) -> Result<&Token, Error> {
        if self.peeked.is_empty() {
            let token = self.lexer.next_token()?;
            self.peeked.push_back(token);
        }
        Ok(self.peeked.front().expect("peeked token exists"))
    }

    fn peek_nth(&mut self, n: usize) -> Result<&Token, Error> {
        while self.peeked.len() <= n {
            let token = self.lexer.next_token()?;
            self.peeked.push_back(token);
        }
        Ok(self.peeked.get(n).expect("peeked token exists"))
    }

    fn parse_body(&mut self, start_span: Span) -> Result<Block, Error> {
        self.block_depth += 1;
        let mut items = Vec::new();
        loop {
            self.consume_block_item_separators()?;
            let token = self.peek_token()?;
            match token.kind {
                TokenKind::RBrace | TokenKind::Eof => break,
                _ => {
                    let item = self.parse_block_item()?;
                    items.push(item);
                }
            }
        }
        self.block_depth -= 1;

        if items.is_empty() {
            let token = self.peek_token()?.clone();
            return Err(Error::new(
                Code::Parse,
                "block must contain at least one item",
                token.span,
            ));
        }

        Ok(Block {
            items: desugar_block_sequence(items),
            span: start_span,
        })
    }

    fn consume_block_item_separators(&mut self) -> Result<(), Error> {
        while self
            .consume_if(|kind| matches!(kind, TokenKind::Semicolon | TokenKind::Newline))?
            .is_some()
        {}
        Ok(())
    }
}

fn desugar_block_sequence(items: Vec<BlockItem>) -> Vec<BlockItem> {
    let mut continuation = Vec::new();

    for item in items.into_iter().rev() {
        if continuation.is_empty() {
            continuation.push(item);
            continue;
        }

        let term = match item {
            BlockItem::Ident(ident) => Term::Ident(ident),
            BlockItem::Lambda(lambda) => Term::Lambda(lambda),
            item => {
                continuation.insert(0, item);
                continue;
            }
        };
        let span = term.span();
        continuation = vec![BlockItem::ScopeCapture {
            params: Signature {
                items: Vec::new(),
                span,
                generics: BTreeSet::new(),
            },
            continuation: Block {
                items: continuation,
                span,
            },
            term,
            span,
        }];
    }

    continuation
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lexer::Lexer;
    use std::io::Cursor;

    #[test]
    fn parse_accepts_every_registered_builtin() {
        for name in builtins::registered_names() {
            let source = format!("value: @{name}");
            let mut parser = Parser::new(Lexer::new(Cursor::new(source)));
            parser
                .next_block_item()
                .unwrap_or_else(|error| panic!("registered builtin '@{name}' failed: {error}"))
                .unwrap_or_else(|| panic!("registered builtin '@{name}' produced no item"));
        }
    }

    #[test]
    fn parse_body_rejects_empty_block() {
        let mut parser = Parser::new(Lexer::new(Cursor::new("{}")));
        let brace = parser
            .expect_token("{", |kind| matches!(kind, TokenKind::LBrace))
            .expect("expected opening brace");
        let err = parser
            .parse_body(brace.span)
            .expect_err("empty block must fail");
        parser
            .expect_token("}", |kind| matches!(kind, TokenKind::RBrace))
            .expect("expected closing brace");
        assert!(
            err.to_string()
                .contains("block must contain at least one item"),
            "unexpected error: {err}"
        );
    }

    #[test]
    fn parse_rejects_bare_empty_param_function_body() {
        let mut parser = Parser::new(Lexer::new(Cursor::new("foo: { bar }")));
        let err = parser
            .next_block_item()
            .expect_err("bare function body must require ()");
        assert!(
            err.to_string()
                .contains("function definitions require a parameter list before the body block"),
            "unexpected error: {err}"
        );
    }

    #[test]
    fn parse_rejects_bare_empty_param_lambda() {
        let mut parser = Parser::new(Lexer::new(Cursor::new("foo: () { bar({ baz }) }")));
        let err = parser
            .next_block_item()
            .expect_err("bare lambda must require ()");
        assert!(
            err.to_string().contains("unexpected token: LBrace"),
            "unexpected error: {err}"
        );
    }

    #[test]
    fn space_application_is_right_associative_in_definition_values() {
        let mut parser = Parser::new(Lexer::new(Cursor::new("chain: a b c")));
        let item = parser
            .next_block_item()
            .expect("definition should parse")
            .expect("definition should exist");
        let BlockItem::IdentDef { ident, .. } = item else {
            panic!("expected identifier definition");
        };
        assert_eq!(ident.name, "a");
        let Term::Ident(b) = &ident.args[0].term else {
            panic!("expected b application");
        };
        assert_eq!(b.name, "b");
        let Term::Ident(c) = &b.args[0].term else {
            panic!("expected c application");
        };
        assert_eq!(c.name, "c");
        assert!(c.args.is_empty());
    }

    #[test]
    fn indented_space_application_stays_inside_definition_value() {
        let source = "chain:\n    a\n    b\n    c\nnext: d";
        let mut parser = Parser::new(Lexer::new(Cursor::new(source)));
        let first = parser
            .next_block_item()
            .expect("chain should parse")
            .expect("chain should exist");
        let BlockItem::IdentDef { ident, .. } = first else {
            panic!("expected identifier definition");
        };
        let Term::Ident(b) = &ident.args[0].term else {
            panic!("expected b application");
        };
        let Term::Ident(c) = &b.args[0].term else {
            panic!("expected c application");
        };
        assert_eq!(c.name, "c");

        let second = parser
            .next_block_item()
            .expect("next should parse")
            .expect("next should exist");
        let BlockItem::IdentDef { name, .. } = second else {
            panic!("expected following definition");
        };
        assert_eq!(name, "next");
    }

    #[test]
    fn block_application_is_right_associative_across_newlines() {
        let source = "main: (){\n    a\n    b\n    c\n}";
        let mut parser = Parser::new(Lexer::new(Cursor::new(source)));
        let item = parser
            .next_block_item()
            .expect("function should parse")
            .expect("function should exist");
        let BlockItem::FunctionDef { lambda, .. } = item else {
            panic!("expected function definition");
        };
        assert_eq!(lambda.body.items.len(), 1);
        let BlockItem::Ident(a) = &lambda.body.items[0] else {
            panic!("expected right-associated application");
        };
        assert_eq!(a.name, "a");
        let Term::Ident(b) = &a.args[0].term else {
            panic!("expected b application");
        };
        assert_eq!(b.name, "b");
        let Term::Ident(c) = &b.args[0].term else {
            panic!("expected c application");
        };
        assert_eq!(c.name, "c");
        assert!(c.args.is_empty());
    }

    #[test]
    fn block_execution_captures_a_following_definition() {
        let source = "main: (){\n    a\n    value: b\n    c(value)\n}";
        let mut parser = Parser::new(Lexer::new(Cursor::new(source)));
        let item = parser
            .next_block_item()
            .expect("function should parse")
            .expect("function should exist");
        let BlockItem::FunctionDef { lambda, .. } = item else {
            panic!("expected function definition");
        };
        let BlockItem::ScopeCapture {
            params,
            continuation,
            term,
            ..
        } = &lambda.body.items[0]
        else {
            panic!("expected implicit unit scope capture");
        };
        assert!(params.items.is_empty());
        let Term::Ident(a) = term else {
            panic!("expected a invocation");
        };
        assert_eq!(a.name, "a");
        let BlockItem::IdentDef { name, ident, .. } = &continuation.items[0] else {
            panic!("expected value definition");
        };
        assert_eq!(name, "value");
        assert_eq!(ident.name, "b");
        let BlockItem::Ident(c) = &continuation.items[1] else {
            panic!("expected c invocation");
        };
        assert_eq!(c.name, "c");
        let Term::Ident(value) = &c.args[0].term else {
            panic!("expected value argument");
        };
        assert_eq!(value.name, "value");
    }

    #[test]
    fn type_bang_marks_scalar_and_callable_parameters() {
        let source = "new: (source: @str, invalid: ()!, args: arg!, run: (calculation)){ run }";
        let mut parser = Parser::new(Lexer::new(Cursor::new(source)));
        let item = parser
            .next_block_item()
            .expect("function should parse")
            .expect("function should exist");
        let BlockItem::FunctionDef { lambda, .. } = item else {
            panic!("expected function definition");
        };
        assert!(!lambda.params.items[0].is_comptime);
        assert!(lambda.params.items[1].is_comptime);
        assert!(lambda.params.items[2].is_comptime);
        assert!(!lambda.params.items[3].is_comptime);
    }

    #[test]
    fn call_bang_is_not_source_syntax() {
        let source = "main: (){ q!() }";
        let mut parser = Parser::new(Lexer::new(Cursor::new(source)));

        assert!(parser.next_block_item().is_err());
    }
}
