use compiler::compile_path;
use std::env;
use std::error::Error as StdError;
use std::fs::File;
use std::io::{self, BufWriter, IsTerminal, Write};
use std::path::Path;
use std::process::ExitCode;

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            if let Some(error) = error.downcast_ref::<compiler::Error>() {
                eprintln!("{}", error.display(io::stderr().is_terminal()));
            } else {
                eprintln!("Error: {error}");
            }
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<(), Box<dyn StdError>> {
    let mut args = env::args().skip(1);
    let input = args.next();
    let target = args.next();
    let output = args.next();
    if args.next().is_some() {
        return Err("expected exactly three arguments: <input> <target> <output>".into());
    }

    let (input_path, target, output_path) = match (input, target, output) {
        (Some(input), Some(target), Some(output)) => (input, target, output),
        _ => return Err("compiler requires <input> <target> <output>".into()),
    };

    let mut assembly = Vec::new();
    compile_path(Path::new(&input_path), &target, &mut assembly)?;
    let mut output = BufWriter::new(File::create(output_path)?);
    output.write_all(&assembly)?;

    Ok(())
}
