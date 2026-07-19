use std::sync::Arc;

use afterflow_frontend::span::Span;
use language_server_protocol::types::{Position, Range, Url};

use crate::analysis::Analysis;

#[derive(Clone, Debug)]
pub(crate) struct Document {
    uri: Url,
    version: Option<i32>,
    text: Arc<str>,
    line_starts: Vec<usize>,
    analysis: Analysis,
}

impl Document {
    pub(crate) fn new(uri: Url, version: Option<i32>, text: String) -> Self {
        let line_starts = line_starts(&text);
        let analysis = Analysis::new(&text);
        Self {
            uri,
            version,
            text: Arc::from(text),
            line_starts,
            analysis,
        }
    }

    pub(crate) fn uri(&self) -> &Url {
        &self.uri
    }

    pub(crate) fn version(&self) -> Option<i32> {
        self.version
    }

    #[cfg(test)]
    pub(crate) fn text(&self) -> &str {
        &self.text
    }

    pub(crate) fn analysis(&self) -> &Analysis {
        &self.analysis
    }

    pub(crate) fn position_to_offset(&self, position: Position) -> Option<usize> {
        let start = *self.line_starts.get(position.line as usize)?;
        let raw_end = self
            .line_starts
            .get(position.line as usize + 1)
            .copied()
            .unwrap_or(self.text.len());
        let end = self.text[..raw_end]
            .strip_suffix('\n')
            .map(str::len)
            .unwrap_or(raw_end);
        let end = self.text[..end]
            .strip_suffix('\r')
            .map(str::len)
            .unwrap_or(end);
        let line = self.text.get(start..end)?;
        let mut utf16_column = 0_u32;
        for (byte_offset, ch) in line.char_indices() {
            if utf16_column == position.character {
                return Some(start + byte_offset);
            }
            utf16_column += ch.len_utf16() as u32;
            if utf16_column > position.character {
                return None;
            }
        }
        (utf16_column == position.character).then_some(end)
    }

    pub(crate) fn span_range(&self, span: Span) -> Range {
        let start_offset = span.offset.min(self.text.len());
        let end_offset = token_end(&self.text, start_offset);
        Range::new(
            self.offset_to_position(start_offset),
            self.offset_to_position(end_offset),
        )
    }

    pub(crate) fn name_range(&self, span: Span, name: &str) -> Range {
        let start_offset = span.offset.min(self.text.len());
        let end_offset = start_offset.saturating_add(name.len()).min(self.text.len());
        Range::new(
            self.offset_to_position(start_offset),
            self.offset_to_position(end_offset),
        )
    }

    fn offset_to_position(&self, offset: usize) -> Position {
        let offset = offset.min(self.text.len());
        let line = self.line_starts.partition_point(|start| *start <= offset) - 1;
        let start = self.line_starts[line];
        let character = self.text[start..offset].encode_utf16().count();
        Position::new(line as u32, character as u32)
    }
}

fn line_starts(text: &str) -> Vec<usize> {
    let mut starts = vec![0];
    for (offset, byte) in text.bytes().enumerate() {
        if byte == b'\n' {
            starts.push(offset + 1);
        }
    }
    starts
}

fn token_end(text: &str, start: usize) -> usize {
    let Some(rest) = text.get(start..) else {
        return start;
    };
    let mut chars = rest.char_indices();
    let Some((_, first)) = chars.next() else {
        return start;
    };
    if first == '"' || first == '\'' {
        let mut is_escaped = false;
        for (offset, ch) in chars {
            if ch == first && !is_escaped {
                return start + offset + ch.len_utf8();
            }
            is_escaped = ch == '\\' && !is_escaped;
            if ch != '\\' {
                is_escaped = false;
            }
        }
        return text.len();
    }
    if first == '/' {
        return start + rest.find(['\n', '\r', ';']).unwrap_or(rest.len());
    }
    if first == '@' || first == '_' || first.is_ascii_alphabetic() {
        return start
            + rest
                .char_indices()
                .take_while(|(_, ch)| {
                    *ch == '@' || *ch == '_' || *ch == '.' || ch.is_ascii_alphanumeric()
                })
                .map(|(offset, ch)| offset + ch.len_utf8())
                .last()
                .unwrap_or(first.len_utf8());
    }
    start + first.len_utf8()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn document(text: &str) -> Document {
        Document::new(
            Url::parse("file:///workspace/main.af").expect("valid URI"),
            Some(1),
            text.to_string(),
        )
    }

    #[test]
    fn maps_utf16_positions_after_non_bmp_characters() {
        let document = document("name: \"😀\"\nnext: name\n");
        assert_eq!(
            document.position_to_offset(Position::new(0, 8)),
            None,
            "a position may not split a UTF-16 surrogate pair"
        );
        assert_eq!(document.position_to_offset(Position::new(1, 6)), Some(19));
    }

    #[test]
    fn ranges_cover_qualified_names() {
        let document = document("fmt.new(@exit)\n");
        let range = document.span_range(Span::new(1, 1, 0));
        assert_eq!(range, Range::new(Position::new(0, 0), Position::new(0, 7)));
    }

    #[test]
    fn rejects_positions_past_the_end_of_a_line() {
        let document = document("abc\r\nnext\n");
        assert_eq!(document.position_to_offset(Position::new(0, 3)), Some(3));
        assert_eq!(document.position_to_offset(Position::new(0, 4)), None);
        assert_eq!(document.position_to_offset(Position::new(1, 4)), Some(9));
    }
}
