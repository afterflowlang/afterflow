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
        let path =
            std::env::temp_dir().join(format!("afterflow-{name}-{}-{nonce}", std::process::id()));
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
fn compiles_the_complete_std_math_surface() {
    let entry =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures/std_math_surface/main.af");
    let mut output = Vec::new();
    compile_path(&entry, "main", &mut output).expect("the complete std math surface compiles");
    let assembly = String::from_utf8(output).expect("assembly is UTF-8");
    let native_symbols = assembly
        .lines()
        .filter(|line| line.starts_with("extern freestanding_math_"))
        .count();
    assert_eq!(native_symbols, 37);
}

#[test]
fn compiles_checked_in_test_source_fixture() {
    let entry =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures/test_sources/main_test.af");
    let mut output = Vec::new();
    compile_path(&entry, "main", &mut output).expect("the checked-in test source fixture compiles");
    let assembly = String::from_utf8(output).expect("assembly is UTF-8");
    assert!(!assembly.contains("write syscall"));
    assert!(assembly.contains("global emit"));
}

#[test]
fn compiles_all_files_in_entry_and_imported_folders() {
    let project = Project::new("folder-import");
    let main = project.write(
        "main.af",
        r#"lib: /lib

main: () {
    lib.run(@exit(0))
}
"#,
    );
    let other = project.write(
        "anything.af",
        r#"unused: () {
    @exit(1)
}
"#,
    );
    project.write(
        "lib/a.af",
        r#"run: (ok: done) {
    helper(ok)
}
"#,
    );
    project.write(
        "lib/z.af",
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
    let entry = project.write("one.af", "main: () {\n    @exit(0)\n}\n");
    project.write("two.af", "main: () {\n    @exit(1)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("duplicate label is rejected");
    assert!(error.to_string().contains("duplicate symbol `main`"));
}

#[test]
fn rejects_importing_the_root_package() {
    let project = Project::new("import-cycle");
    let entry = project.write("main.af", "lib: /lib\n\nmain: () {\n    lib.run()\n}\n");
    project.write("lib/lib.af", "root: /\n\nrun: () {\n    @exit(0)\n}\n");

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
fn private_file_declarations_remain_visible_inside_their_folder() {
    let project = Project::new("private-file-sibling-access");
    let entry = project.write("main.af", "lib: /lib\n\nmain: () {\n    lib.run()\n}\n");
    project.write("lib/main.af", "run: () {\n    helper()\n}\n");
    project.write("lib/_helper.af", "helper: () {\n    @exit(0)\n}\n");

    project
        .compile(&entry)
        .expect("public declarations can use private sibling declarations");
}

#[test]
fn rejects_imported_access_to_private_file_declarations() {
    let project = Project::new("private-file-import-access");
    let entry = project.write("main.af", "lib: /lib\n\nmain: () {\n    lib.helper()\n}\n");
    project.write("lib/main.af", "public: 1\n");
    project.write("lib/_helper.af", "helper: () {\n    @exit(0)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("private declaration access through an import is rejected");
    assert!(
        error
            .to_string()
            .contains("folder '/lib' has no label 'helper'"),
        "{error}"
    );
}

#[test]
fn rejects_private_file_declarations_as_compilation_targets() {
    let project = Project::new("private-file-target");
    let entry = project.write("_main.af", "main: () {\n    @exit(0)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("private declaration cannot be selected as a target");
    assert!(error
        .to_string()
        .contains("could not resolve target 'main'"));
}

#[test]
fn rejects_source_import_cycles() {
    let project = Project::new("import-cycle");
    let entry = project.write("main.af", "a: /a\n\nmain: () {\n    a.run()\n}\n");
    project.write("a/main.af", "b: /b\n\nrun: () {\n    b.run()\n}\n");
    project.write("b/main.af", "a: /a\n\nrun: () {\n    a.run()\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("import cycle is rejected");
    assert!(error.to_string().contains("source import cycle"));
}

#[test]
fn preserves_declaration_before_use_within_each_file() {
    let project = Project::new("declaration-order");
    let entry = project.write(
        "main.af",
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
        "main.af",
        r#"main: () {
    lib.run(@exit(0))
}

lib: /lib
"#,
    );
    project.write("lib/main.af", "run: (ok: ()) {\n    ok()\n}\n");

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
    let entry = project.write("main.af", "lib: /lib\n\nmain: () {\n    lib.run()\n}\n");
    project.write("lib/main.af", "run: () {\n    missing()\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("undefined imported label is rejected");
    assert!(error
        .to_string()
        .contains("lib/main.af:2\n    missing()\n    ^^^^^^^"));
}

#[test]
fn normal_compilation_ignores_test_sources() {
    let project = Project::new("ignore-test-sources");
    let entry = project.write("main.af", "main: () {\n    @exit(0)\n}\n");
    project.write("broken_test.af", "this is not valid afterflow\n");

    project
        .compile(&entry)
        .expect("test sources do not participate in normal compilation");
}

#[test]
fn test_sources_can_use_regular_sibling_declarations() {
    let project = Project::new("test-regular-sibling");
    project.write("run.af", "run: () {\n    @exit(0)\n}\n");
    let entry = project.write("main_test.af", "main: () {\n    run()\n}\n");

    project
        .compile(&entry)
        .expect("test sources can use regular sibling declarations");
}

#[test]
fn test_sources_can_import_regular_package_declarations() {
    let project = Project::new("test-import");
    let entry = project.write(
        "main_test.af",
        "lib: /lib\n\nmain: () {\n    lib.run()\n}\n",
    );
    project.write("lib/run.af", "run: () {\n    @exit(0)\n}\n");
    project.write("lib/broken_test.af", "this is not valid afterflow\n");

    project
        .compile(&entry)
        .expect("imports expose regular declarations and ignore dependency tests");
}

#[test]
fn regular_sources_cannot_use_test_declarations() {
    let project = Project::new("regular-cannot-see-test");
    project.write("run.af", "run: () {\n    helper()\n}\n");
    let entry = project.write(
        "main_test.af",
        "helper: () {\n    @exit(0)\n}\n\nmain: () {\n    run()\n}\n",
    );

    let error = project
        .compile(&entry)
        .expect_err("regular sources cannot use declarations from test sources");
    assert!(
        error
            .to_string()
            .contains("`helper` is only available to _test.af sources"),
        "{error}"
    );
}

#[test]
fn test_entry_sources_can_override_callable_builtins() {
    let project = Project::new("test-builtin-override");
    project.write(
        "run.af",
        "write: @write\n\nrun: () {\n    @write(\"not written\", @exit(0))\n}\n\nrun_alias: () {\n    write(\"also not written\", @exit(0))\n}\n",
    );
    let entry = project.write(
        "main_test.af",
        "discard: (message: @str, ok: ()) {\n    ok()\n}\n\n@write: discard\n\nmain: () {\n    run()\n}\n",
    );

    let assembly = project
        .compile(&entry)
        .expect("the selected test entry can replace a builtin with a function alias");
    assert!(!assembly.contains("write syscall"));
}

#[test]
fn regular_sources_cannot_override_builtins() {
    let project = Project::new("regular-builtin-override");
    let entry = project.write(
        "main.af",
        "discard: (message: @str, ok: ()) {\n    ok()\n}\n\n@write: discard\n\nmain: () {\n    @exit(0)\n}\n",
    );

    let error = project
        .compile(&entry)
        .expect_err("regular entry sources cannot override builtins");
    assert!(
        error
            .to_string()
            .contains("builtin overrides are only allowed in the selected _test.af entry source"),
        "{error}"
    );
}

#[test]
fn only_the_selected_test_entry_can_override_builtins() {
    let project = Project::new("non-entry-builtin-override");
    project.write(
        "other_test.af",
        "discard: (message: @str, ok: ()) {\n    ok()\n}\n\n@write: discard\n",
    );
    let entry = project.write("main_test.af", "main: () {\n    @exit(0)\n}\n");

    let error = project
        .compile(&entry)
        .expect_err("non-entry test sources cannot override builtins");
    assert!(
        error
            .to_string()
            .contains("builtin overrides are only allowed in the selected _test.af entry source"),
        "{error}"
    );
}

#[test]
fn rejects_access_through_a_nested_source_folder() {
    let project = Project::new("nested-folder-access");
    let entry = project.write(
        "main.af",
        r#"lib: /lib

main: () {
    lib.strings.upper()
}
"#,
    );
    project.write("lib/lib.af", "marker: 1\n");
    project.write(
        "lib/strings/strings.af",
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
        "main.af",
        r#"strings: /lib/strings

main: () {
    strings.upper()
}
"#,
    );
    project.write(
        "lib/strings/main.af",
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
        "main.af",
        "std: /std\n\nmain: () {\n    std.run(@exit(0))\n}\n",
    );
    project.write("std/main.af", "run: (ok: ()) {\n    ok()\n}\n");

    project
        .compile(&entry)
        .expect("std is available to source packages");
}

#[test]
fn imports_paths_with_spaces_and_hyphens_until_semicolon() {
    let project = Project::new("path-syntax");
    let entry = project.write(
        "main.af",
        r#"something: /some path/to-some/something;

main: () {
    something.run(@exit(0))
}
"#,
    );
    project.write(
        "some path/to-some/something/main.af",
        r#"run: (ok: ()) {
    ok()
}
"#,
    );

    project
        .compile(&entry)
        .expect("path is read through the semicolon and infers its namespace");
}
