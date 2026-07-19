FROM rust:1.96-trixie

WORKDIR /afterflow

RUN apt-get update && \
    apt-get install -y nasm binutils make && \
    rm -rf /var/lib/apt/lists/*

# Copy compiler source
COPY . .

# Build + install compiler binary (named `compiler`)
RUN cargo install --path .
ENV PATH="/usr/local/cargo/bin:${PATH}"

# Install wrapper
COPY compile.sh /usr/local/bin/afterflow-compile
RUN chmod +x /usr/local/bin/afterflow-compile

ENTRYPOINT ["/usr/local/bin/afterflow-compile"]
