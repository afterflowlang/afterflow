use std::io::{BufRead, BufReader, Write};
use std::process::{Command, Stdio};
use std::thread;
use std::time::{Duration, Instant};

fn write_message(writer: &mut impl Write, message: &str) {
    write!(writer, "Content-Length: {}\r\n\r\n{message}", message.len()).unwrap();
    writer.flush().unwrap();
}

fn read_message(reader: &mut impl BufRead) -> String {
    let mut content_length = None;
    loop {
        let mut header = String::new();
        reader.read_line(&mut header).unwrap();
        if header == "\r\n" {
            break;
        }
        if let Some(value) = header.strip_prefix("Content-Length: ") {
            content_length = Some(value.trim().parse::<usize>().unwrap());
        }
    }

    let mut body = vec![0; content_length.expect("response must include Content-Length")];
    reader.read_exact(&mut body).unwrap();
    String::from_utf8(body).unwrap()
}

#[test]
fn exits_cleanly_after_shutdown() {
    let mut child = Command::new(env!("CARGO_BIN_EXE_afterflow-ls"))
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();
    let mut stdin = child.stdin.take().unwrap();
    let mut stdout = BufReader::new(child.stdout.take().unwrap());

    write_message(
        &mut stdin,
        r#"{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{},"workspaceFolders":null}}"#,
    );
    assert!(read_message(&mut stdout).contains(r#""id":1"#));

    write_message(
        &mut stdin,
        r#"{"jsonrpc":"2.0","method":"initialized","params":{}}"#,
    );
    write_message(
        &mut stdin,
        r#"{"jsonrpc":"2.0","id":2,"method":"shutdown","params":null}"#,
    );
    assert!(read_message(&mut stdout).contains(r#""id":2"#));
    write_message(
        &mut stdin,
        r#"{"jsonrpc":"2.0","method":"exit","params":null}"#,
    );

    let deadline = Instant::now() + Duration::from_secs(2);
    loop {
        if let Some(status) = child.try_wait().unwrap() {
            assert!(status.success());
            break;
        }
        if Instant::now() >= deadline {
            child.kill().unwrap();
            child.wait().unwrap();
            panic!("language server did not exit after shutdown");
        }
        thread::sleep(Duration::from_millis(10));
    }
}
