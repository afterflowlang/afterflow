use std::fs;
use std::io::{Cursor, Write};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::OnceLock;
use std::time::{SystemTime, UNIX_EPOCH};

use compiler::compiler::error::{self, Code, Error};
use compiler::compiler::span::Span;
use compiler::compiler::{
    compile_path, format_air::render_air_functions, format_hir::render_normalized_rgo,
    lexer::Lexer, parser::Parser,
};
use compiler::debug_tools::test_helpers::{generate_air_functions, generate_hir_block_items};

const GENERATED_DIR: &str = "tests/generated";
const TEST_TARGET: &str = "main";

#[test]
fn golden_test() {
    generate_golden_snapshots();
    let bin_dir = Path::new("bin");
    fs::create_dir_all(bin_dir).expect("failed to create bin directory");
    verify_expected_runtime_outputs(Path::new("tests/golden"), bin_dir);
}

#[test]
fn failing_test() {
    generate_failure_snapshots();
    let bin_dir = Path::new("bin");
    fs::create_dir_all(bin_dir).expect("failed to create bin directory");
    verify_expected_compile_errors(Path::new("tests/failing"), bin_dir);
}

fn generate_golden_snapshots() {
    let golden_dir = Path::new("tests/golden");
    let out_dir = Path::new(GENERATED_DIR);
    fs::create_dir_all(out_dir).expect("failed to create generated output directory");

    process_snapshot_directory(golden_dir, out_dir, SnapshotKind::Success);
}

fn generate_failure_snapshots() {
    let failing_dir = Path::new("tests/failing");
    let out_dir = Path::new(GENERATED_DIR);
    fs::create_dir_all(out_dir).expect("failed to create generated output directory");

    process_snapshot_directory(failing_dir, out_dir, SnapshotKind::Failure);
}

fn process_snapshot_directory(src_dir: &Path, out_dir: &Path, kind: SnapshotKind) {
    if !src_dir.exists() {
        return;
    }

    for test in collect_test_cases(src_dir) {
        let test_out_dir = out_dir.join(&test.name);
        fs::create_dir_all(&test_out_dir).expect("failed to create generated test directory");
        if let Err(err) = build_reference_for_path(&test.source, &test_out_dir, kind) {
            panic!("{}: {err}", test.source.display());
        }
    }
}

struct TestCase {
    name: String,
    dir: PathBuf,
    source: PathBuf,
}

fn collect_test_cases(tests_dir: &Path) -> Vec<TestCase> {
    let mut cases: Vec<TestCase> = fs::read_dir(tests_dir)
        .expect("tests directory should exist")
        .filter_map(|entry| {
            let entry = entry.ok()?;
            let dir = entry.path();
            if !dir.is_dir() {
                return None;
            }
            let name = dir.file_name()?.to_str()?.to_string();
            let source = entry_source_path(&dir)?;
            assert_complexity_prefix(&name, &dir);
            Some(TestCase { name, dir, source })
        })
        .collect();
    cases.sort_by(|a, b| a.name.cmp(&b.name));
    cases
}

fn assert_complexity_prefix(name: &str, dir: &Path) {
    let Some((prefix, _)) = name.split_once('-') else {
        panic!(
            "{} must start with a complexity prefix like 1-hello",
            dir.display()
        );
    };
    match prefix {
        "1" | "2" | "3" | "4" | "5" => {}
        _ => panic!(
            "{} has invalid complexity prefix {prefix:?}; use 1 through 5",
            dir.display()
        ),
    }
}

fn entry_source_path(dir: &Path) -> Option<PathBuf> {
    let main_path = dir.join("main.af");
    if main_path.exists() {
        return Some(main_path);
    }

    let mut rgo_paths: Vec<PathBuf> = fs::read_dir(dir)
        .expect("test directory should exist")
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if path.is_file() && path.extension().and_then(|ext| ext.to_str()) == Some("af") {
                Some(path)
            } else {
                None
            }
        })
        .collect();
    rgo_paths.sort();
    match rgo_paths.as_slice() {
        [] => None,
        [path] => Some(path.clone()),
        _ => panic!(
            "{} contains multiple .af files; add main.af to choose the entrypoint",
            dir.display()
        ),
    }
}

fn compile_source(path: &Path, target: &str) -> Result<String, Error> {
    let mut output = Vec::new();
    compile_path(path, target, &mut output)?;
    let asm = String::from_utf8(output).map_err(|err| {
        error::new(
            Code::Codegen,
            format!("assembly is not valid UTF-8: {err}"),
            Span::unknown(),
        )
    })?;
    Ok(asm) // TODO: This air_module can be done better
}

fn build_reference_for_path(path: &Path, out_dir: &Path, kind: SnapshotKind) -> Result<(), Error> {
    let stem = path
        .file_stem()
        .and_then(|stem| stem.to_str())
        .ok_or_else(|| {
            error::new(
                Code::Internal,
                "filename should be valid UTF-8",
                Span::unknown(),
            )
        })?;
    let source = fs::read_to_string(path)?;
    match kind {
        SnapshotKind::Success => {
            let artifacts = generate_artifacts(path, &source, TEST_TARGET)?;
            let actual_err_path = out_dir.join(format!("{stem}.actual.err"));
            if actual_err_path.exists() {
                fs::remove_file(&actual_err_path)?;
            }
            write_artifacts(out_dir, stem, &artifacts)?;
            Ok(())
        }
        SnapshotKind::Failure => match generate_artifacts(path, &source, TEST_TARGET) {
            Ok(_) => Err(error::new(
                Code::Internal,
                "expected compilation failure but succeeded",
                Span::unknown(),
            )),
            Err(err) => {
                let actual_err_path = out_dir.join(format!("{stem}.actual.err"));
                fs::write(actual_err_path, format!("{err}\n"))?;
                Ok(())
            }
        },
    }
}

struct GeneratedArtifacts {
    parser_output: String,
    normalized_hir: String,
    air: String,
    asm: String,
}

#[derive(Copy, Clone)]
enum SnapshotKind {
    Success,
    Failure,
}

fn generate_artifacts(
    path: &Path,
    source: &str,
    target: &str,
) -> Result<GeneratedArtifacts, Error> {
    let cursor = Cursor::new(source.as_bytes());
    let lexer = Lexer::new(cursor);
    let mut parser = Parser::new(lexer);
    let mut block_items = Vec::new();

    while let Some(item) = parser.next_block_item()? {
        reject_root_execution(&item)?;
        block_items.push(item.clone());
    }

    block_items.push(target_exec(target));
    let hir_block_items = generate_hir_block_items(path, target)?;

    let normalized_hir = render_normalized_rgo(&hir_block_items);
    let parser_output = format!("{:#?}", block_items);

    let air_functions = generate_air_functions(&hir_block_items)?;
    let air = render_air_functions(&air_functions);

    let asm = compile_source(path, target)?;
    Ok(GeneratedArtifacts {
        parser_output,
        normalized_hir,
        air,
        asm,
    })
}

fn write_artifacts(
    out_dir: &Path,
    stem: &str,
    artifacts: &GeneratedArtifacts,
) -> Result<(), Error> {
    fs::write(
        out_dir.join(format!("{stem}.txt")),
        &artifacts.parser_output,
    )?;
    fs::write(
        out_dir.join(format!("{stem}.hir.af")),
        &artifacts.normalized_hir,
    )?;
    fs::write(out_dir.join(format!("{stem}.air")), &artifacts.air)?;
    fs::write(out_dir.join(format!("{stem}.asm")), &artifacts.asm)?;
    Ok(())
}

fn verify_expected_runtime_outputs(tests_dir: &Path, bin_dir: &Path) {
    for test in collect_test_cases(tests_dir) {
        let expected_path = test.dir.join("expected.out");
        let expected_hex_path = test.dir.join("expected.out.hex");
        if !expected_path.exists() && !expected_hex_path.exists() {
            continue;
        }
        let expected_status_path = test.dir.join("expected.status");
        let expected_status = if expected_status_path.exists() {
            fs::read_to_string(&expected_status_path)
                .expect("expected status file should be readable")
                .trim()
                .parse::<i32>()
                .expect("expected status should be an integer")
        } else {
            0
        };

        let asm_path = bin_dir.join(format!("{}.asm", test.name));
        compile_rgo_source(&test.source, &asm_path);

        let obj_path = bin_dir.join(format!("{}.o", test.name));
        let mut nasm_cmd = Command::new("nasm");
        nasm_cmd
            .arg("-felf64")
            .arg(&asm_path)
            .arg("-o")
            .arg(&obj_path);
        run_command(
            &mut nasm_cmd,
            &format!(
                "nasm -felf64 {} -o {}",
                asm_path.display(),
                obj_path.display()
            ),
        );

        let bin_path = bin_dir.join(&test.name);
        let mut ld_cmd = Command::new("ld");
        ld_cmd
            .arg("--gc-sections")
            .arg("--strip-debug")
            .arg(&obj_path);
        let assembly =
            fs::read_to_string(&asm_path).expect("generated assembly should be readable");
        let mut archives = Vec::new();
        if assembly.contains("extern freestanding_format_") {
            archives.push(freestanding_format_archive());
        }
        if assembly.contains("extern freestanding_math_") {
            archives.push(freestanding_math_archive());
        }
        for archive in &archives {
            ld_cmd.arg(archive);
        }
        ld_cmd.arg("-o").arg(&bin_path);
        let archive_args = archives
            .iter()
            .map(|archive| format!(" {}", archive.display()))
            .collect::<String>();
        run_command(
            &mut ld_cmd,
            &format!(
                "ld --gc-sections --strip-debug {}{} -o {}",
                obj_path.display(),
                archive_args,
                bin_path.display()
            ),
        );

        let mut run_cmd = Command::new(&bin_path);
        log_breadcrumb(
            "compile-direct-golden-run",
            &format!("test={} command={}", test.name, bin_path.display()),
        );
        let output = run_cmd
            .output()
            .unwrap_or_else(|err| panic!("running {} failed to start: {err}", bin_path.display()));
        assert_eq!(
            output.status.code(),
            Some(expected_status),
            "unexpected exit status for {}:\nstdout:\n{}\nstderr:\n{}",
            test.name,
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr),
        );
        let expected_output = if expected_hex_path.exists() {
            parse_hex_output(&expected_hex_path)
        } else {
            fs::read(&expected_path).expect("expected output file should be readable")
        };

        // The console output is part of the golden snapshot and should only change when the source intentionally changes.
        assert_eq!(
            output.stdout, expected_output,
            "unexpected runtime output for {}",
            test.name
        );
    }
}

fn freestanding_math_archive() -> &'static Path {
    static ARCHIVE: OnceLock<PathBuf> = OnceLock::new();
    ARCHIVE.get_or_init(|| freestanding_archive("freestanding-math", "libfreestanding_math.a"))
}

fn freestanding_format_archive() -> &'static Path {
    static ARCHIVE: OnceLock<PathBuf> = OnceLock::new();
    ARCHIVE.get_or_init(|| freestanding_archive("freestanding-format", "libfreestanding_format.a"))
}

fn freestanding_archive(package: &str, filename: &str) -> PathBuf {
    let repo_root = Path::new(env!("CARGO_MANIFEST_DIR"));
    let mut cmd = Command::new("cargo");
    cmd.current_dir(repo_root)
        .arg("build")
        .arg("-p")
        .arg(package)
        .arg("--release");
    run_command(&mut cmd, &format!("cargo build -p {package} --release"));
    repo_root.join("target/release").join(filename)
}

fn parse_hex_output(path: &Path) -> Vec<u8> {
    fs::read_to_string(path)
        .expect("expected hex output should be readable")
        .split_whitespace()
        .map(|hex| u8::from_str_radix(hex, 16).expect("expected output should contain byte hex"))
        .collect()
}

fn verify_expected_compile_errors(tests_dir: &Path, bin_dir: &Path) {
    if !tests_dir.exists() {
        return;
    }

    for test in collect_test_cases(tests_dir) {
        let expected_path = test.dir.join("expected.err");
        if !expected_path.exists() {
            continue;
        }

        let expected_error = fs::read_to_string(&expected_path)
            .expect("expected error file should be readable")
            .trim_end()
            .to_string();
        let asm_path = bin_dir.join(format!("{}.err.asm", test.name));
        let mut cmd = Command::new("cargo");
        cmd.arg("run")
            .arg("--")
            .arg(&test.source)
            .arg(TEST_TARGET)
            .arg(&asm_path);
        let actual_error = capture_compile_failure_output(
            &mut cmd,
            &format!("cargo run -- {}", test.source.display()),
        );

        assert!(
            actual_error.contains(&expected_error),
            "expected error substring \"{}\" not found for {}: actual error:\n{}",
            expected_error,
            test.name,
            actual_error
        );
    }
}

fn compile_rgo_source(rgo_path: &Path, asm_path: &Path) {
    let mut cmd = Command::new("cargo");
    cmd.arg("run")
        .arg("--")
        .arg(rgo_path)
        .arg(TEST_TARGET)
        .arg(asm_path);
    run_command(
        &mut cmd,
        &format!(
            "cargo run -- {} {} {}",
            rgo_path.display(),
            TEST_TARGET,
            asm_path.display()
        ),
    );
}

fn target_exec(target: &str) -> compiler::compiler::ast::BlockItem {
    compiler::compiler::ast::BlockItem::Ident(compiler::compiler::ast::Ident {
        name: target.to_string(),
        args: Vec::new(),
        span: Span::unknown(),
    })
}

fn reject_root_execution(item: &compiler::compiler::ast::BlockItem) -> Result<(), Error> {
    match item {
        compiler::compiler::ast::BlockItem::Ident(_)
        | compiler::compiler::ast::BlockItem::Lambda(_)
        | compiler::compiler::ast::BlockItem::ScopeCapture { .. } => Err(error::new(
            Code::Parse,
            "root-level invocation is not supported; choose a target function",
            item.span(),
        )),
        _ => Ok(()),
    }
}

fn run_command(cmd: &mut Command, description: &str) {
    log_breadcrumb("compile-direct-command-start", description);
    let output = cmd
        .output()
        .unwrap_or_else(|err| panic!("{description} failed to start: {err}"));
    if !output.status.success() {
        panic!(
            "{} failed (status: {}):\nstdout:\n{}\nstderr:\n{}",
            description,
            output.status,
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr)
        );
    }
}

fn capture_compile_failure_output(cmd: &mut Command, description: &str) -> String {
    log_breadcrumb("compile-direct-command-start", description);
    let output = cmd
        .output()
        .unwrap_or_else(|err| panic!("{description} failed to start: {err}"));
    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if output.status.success() {
        panic!(
            "{} unexpectedly succeeded:\nstdout:\n{}\nstderr:\n{}",
            description, stdout, stderr
        );
    }

    format!("{stdout}{stderr}")
}

fn log_breadcrumb(label: &str, detail: &str) {
    let Some(path) = std::env::var_os("RGO_TEST_BREADCRUMB_LOG").map(PathBuf::from) else {
        return;
    };
    if let Some(parent) = path.parent() {
        let _ = fs::create_dir_all(parent);
    }
    let Ok(mut file) = fs::OpenOptions::new().create(true).append(true).open(path) else {
        return;
    };
    let timestamp_ms = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|duration| duration.as_millis())
        .unwrap_or_default();
    let label = label.replace('\\', "\\\\").replace('\n', "\\n");
    let detail = detail.replace('\\', "\\\\").replace('\n', "\\n");
    let _ = writeln!(
        file,
        "ts_ms={timestamp_ms} pid={} kind=process-start label={label} detail={detail}",
        std::process::id()
    );
    let _ = file.sync_data();
}
