fn main() {
    if let Err(error) = afterflow_language_server::run() {
        eprintln!("afterflow-language-server: {error}");
        std::process::exit(1);
    }
}
