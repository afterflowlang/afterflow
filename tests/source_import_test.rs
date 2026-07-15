use std::fs;
use std::path::{Path, PathBuf};
use std::time::{SystemTime, UNIX_EPOCH};

use compiler::compile_path;

struct Project {
    path: PathBuf,
}

impl Project {
    fn new(name: &str) -> Self {
        let nonce = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("clock is after epoch")
            .as_nanos();
        let path = std::env::temp_dir().join(format!("rgo-{name}-{}-{nonce}", std::process::id()));
        fs::create_dir_all(&path).expect("project directory is created");
        Self { path }
    }

    fn write(&self, relative: &str, source: &str) -> PathBuf {
        let path = self.path.join(relative);
        fs::create_dir_all(path.parent().expect("source has a parent"))
            .expect("source directory is created");
        fs::write(&path, source).expect("source is written");
        path
    }

    fn compile(&self, entry: &Path) -> Result<String, compiler::Error> {
        let mut output = Vec::new();
        compile_path(entry, "main", &mut output)?;
        Ok(String::from_utf8(output).expect("assembly is UTF-8"))
    }
}

impl Drop for Project {
    fn drop(&mut self) {
        fs::remove_dir_all(&self.path).expect("project directory is removed");
    }
}

#[test]
fn compiles_all_files_in_entry_and_imported_folders() {
    let project = Project::new("folder-import");
    let main = project.write(
        "main.rgo",
        r#"lib: /lib

main: () {
    lib.run(@exit(0))
}
"#,
    );
    let other = project.write(
        "anything.rgo",
        r#"unused: () {
    @exit(1)
}
"#,
    );
    project.write(
        "lib/a.rgo",
        r#"run: (ok: done) {
    helper(ok)
}
"#,
    );
    project.write(
        "lib/z.rgo",
        r#"done: ()

helper: (ok: done) {
    ok()
}
"#,
    );

    let from_main = project.compile(&main).expect("main entry compiles");
    let from_other = project.compile(&other).expect("other entry compiles");
    assert_eq!(from_main, from_other);
    assert!(from_main.contains("global __rgo_6c6962__run"));
    assert!(from_main.contains("global __rgo_6c6962__helper"));
}

#[test]
fn rejects_duplicate_labels_across_files() {
    let project = Project::new("duplicate-label");
    let entry = project.write("one.rgo", "main: () {\n    @exit(0)\n}\n");
    project.write("two.rgo", "main: () {\n    @exit(1)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("duplicate label is rejected");
    assert!(error.to_string().contains("duplicate symbol `main`"));
}

#[test]
fn rejects_importing_the_root_package() {
    let project = Project::new("import-cycle");
    let entry = project.write("main.rgo", "lib: /lib\n\nmain: () {\n    lib.run()\n}\n");
    project.write("lib/lib.rgo", "root: /\n\nrun: () {\n    @exit(0)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("root package import is rejected");
    assert!(
        error
            .to_string()
            .contains("the root package cannot be imported"),
        "{error}"
    );
}

#[test]
fn rejects_source_import_cycles() {
    let project = Project::new("import-cycle");
    let entry = project.write("main.rgo", "a: /a\n\nmain: () {\n    a.run()\n}\n");
    project.write("a/main.rgo", "b: /b\n\nrun: () {\n    b.run()\n}\n");
    project.write("b/main.rgo", "a: /a\n\nrun: () {\n    a.run()\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("import cycle is rejected");
    assert!(error.to_string().contains("source import cycle"));
}

#[test]
fn preserves_declaration_before_use_within_each_file() {
    let project = Project::new("declaration-order");
    let entry = project.write(
        "main.rgo",
        r#"main: () {
    later()
}

later: () {
    @exit(0)
}
"#,
    );

    let error = project
        .compile(&entry)
        .expect_err("later declaration in the same file is rejected");
    assert!(error
        .to_string()
        .contains("`later` is not defined before this use"));
}

#[test]
fn preserves_declaration_before_use_for_source_packages() {
    let project = Project::new("source-import-order");
    let entry = project.write(
        "main.rgo",
        r#"main: () {
    lib.run(@exit(0))
}

lib: /lib
"#,
    );
    project.write("lib/main.rgo", "run: (ok: ()) {\n    ok()\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("source package must be bound before use");
    assert!(error
        .to_string()
        .contains("source import 'lib' is not defined before this use"));
}

#[test]
fn reports_errors_from_the_originating_source_file() {
    let project = Project::new("source-diagnostic");
    let entry = project.write("main.rgo", "lib: /lib\n\nmain: () {\n    lib.run()\n}\n");
    project.write("lib/main.rgo", "run: () {\n    missing()\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("undefined imported label is rejected");
    assert!(error
        .to_string()
        .contains("lib/main.rgo:2\n    missing()\n    ^^^^^^^"));
}

#[test]
fn rejects_access_through_a_nested_source_folder() {
    let project = Project::new("nested-folder-access");
    let entry = project.write(
        "main.rgo",
        r#"lib: /lib

main: () {
    lib.strings.upper()
}
"#,
    );
    project.write("lib/lib.rgo", "marker: 1\n");
    project.write(
        "lib/strings/strings.rgo",
        r#"upper: () {
    @exit(0)
}
"#,
    );

    let error = project
        .compile(&entry)
        .expect_err("nested folders are not members of their parent folder");
    assert!(error
        .to_string()
        .contains("source import access 'lib.strings.upper' must contain one member name"));
}

#[test]
fn source_packages_can_use_an_explicit_alias() {
    let project = Project::new("file-import");
    let entry = project.write(
        "main.rgo",
        r#"strings: /lib/strings

main: () {
    strings.upper()
}
"#,
    );
    project.write(
        "lib/strings/main.rgo",
        r#"upper: () {
    @exit(0)
}
"#,
    );

    project
        .compile(&entry)
        .expect("source package can choose a namespace alias");
}

#[test]
fn source_packages_can_use_std_as_an_alias() {
    let project = Project::new("std-source-namespace");
    let entry = project.write(
        "main.rgo",
        "std: /std\n\nmain: () {\n    std.run(@exit(0))\n}\n",
    );
    project.write("std/main.rgo", "run: (ok: ()) {\n    ok()\n}\n");

    project
        .compile(&entry)
        .expect("std is available to source packages");
}

#[test]
fn imports_paths_with_spaces_and_hyphens_until_semicolon() {
    let project = Project::new("path-syntax");
    let entry = project.write(
        "main.rgo",
        r#"something: /some path/to-some/something;

main: () {
    something.run(@exit(0))
}
"#,
    );
    project.write(
        "some path/to-some/something/main.rgo",
        r#"run: (ok: ()) {
    ok()
}
"#,
    );

    project
        .compile(&entry)
        .expect("path is read through the semicolon and infers its namespace");
}
