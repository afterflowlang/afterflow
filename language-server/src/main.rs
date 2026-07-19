fn main() {
    if let Err(error) = afterflow_ls::run() {
        eprintln!("afterflow-ls: {error}");
        std::process::exit(1);
    }
}
