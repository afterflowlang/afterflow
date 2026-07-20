use std::env;
use std::fs;
use std::io::{self, Read, Write};
use std::path::PathBuf;
use std::process::ExitCode;

use afterflow_frontend::formatter::format_source;

fn main() -> ExitCode {
    match run() {
        Ok(code) => code,
        Err(error) => {
            eprintln!("afterflow-fmt: {error}");
            ExitCode::from(2)
        }
    }
}

fn run() -> Result<ExitCode, String> {
    let mut write_files = false;
    let mut check = false;
    let mut paths = Vec::new();
    for arg in env::args().skip(1) {
        match arg.as_str() {
            "-w" | "--write" => write_files = true,
            "--check" => check = true,
            "-h" | "--help" => {
                print_help();
                return Ok(ExitCode::SUCCESS);
            }
            _ if arg.starts_with('-') => return Err(format!("unknown option '{arg}'")),
            _ => paths.push(PathBuf::from(arg)),
        }
    }
    if write_files && check {
        return Err("--write and --check cannot be used together".to_string());
    }
    if paths.is_empty() {
        if write_files || check {
            return Err("--write and --check require at least one file".to_string());
        }
        let mut source = String::new();
        io::stdin()
            .read_to_string(&mut source)
            .map_err(|error| format!("stdin: {error}"))?;
        let formatted = format_source(&source).map_err(|error| error.to_string())?;
        io::stdout()
            .write_all(formatted.as_bytes())
            .map_err(|error| format!("stdout: {error}"))?;
        return Ok(ExitCode::SUCCESS);
    }

    let mut differs = false;
    for path in paths {
        let source =
            fs::read_to_string(&path).map_err(|error| format!("{}: {error}", path.display()))?;
        let formatted =
            format_source(&source).map_err(|error| format!("{}: {error}", path.display()))?;
        if check {
            if formatted != source {
                differs = true;
                println!("{}", path.display());
            }
        } else if write_files {
            if formatted != source {
                fs::write(&path, formatted)
                    .map_err(|error| format!("{}: {error}", path.display()))?;
            }
        } else {
            io::stdout()
                .write_all(formatted.as_bytes())
                .map_err(|error| format!("stdout: {error}"))?;
        }
    }
    Ok(if differs {
        ExitCode::from(1)
    } else {
        ExitCode::SUCCESS
    })
}

fn print_help() {
    println!(
        "Canonical Afterflow source formatter\n\n\
         Usage: afterflow-fmt [OPTIONS] [FILES...]\n\n\
         With no files, reads stdin and writes stdout.\n\n\
         Options:\n  -w, --write  write results to files\n      --check  list files that need formatting\n  -h, --help   print help"
    );
}
