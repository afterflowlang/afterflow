FROM rust:1.96-trixie

WORKDIR /afterflow

RUN apt-get update && \
    apt-get install -y nasm binutils make && \
    rm -rf /var/lib/apt/lists/*

# Copy compiler source
COPY . .

# Build and install the compiler and its freestanding runtime archives.
RUN cargo install --path compile-direct --bin compiler && \
    cargo build -p freestanding-format --release && \
    cargo build -p freestanding-math --release && \
    mkdir -p /usr/local/lib/afterflow && \
    cp target/release/libfreestanding_format.a /usr/local/lib/afterflow/ && \
    cp target/release/libfreestanding_math.a /usr/local/lib/afterflow/
ENV PATH="/usr/local/cargo/bin:${PATH}"

# Install wrapper
COPY compile.sh /usr/local/bin/afterflow-compile
RUN chmod +x /usr/local/bin/afterflow-compile

ENTRYPOINT ["/usr/local/bin/afterflow-compile"]
