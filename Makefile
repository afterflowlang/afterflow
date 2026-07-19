ASDF ?= asdf
ASDF_DATA_DIR ?= $(HOME)/.asdf
RUST_VERSION := 1.96.0
NASM_VERSION := 3.01
NASM_URL := https://www.nasm.us/pub/nasm/releasebuilds/$(NASM_VERSION)/nasm-$(NASM_VERSION).tar.gz
INPUT ?= compile-direct/code/main.af
TARGET := $(word 2,$(MAKECMDGOALS))
FORMAT_ARCHIVE := target/release/libfreestanding_format.a
MATH_ARCHIVE := target/release/libfreestanding_math.a
FREESTANDING_ARCHIVES := $(FORMAT_ARCHIVE) $(MATH_ARCHIVE)

ifneq ($(filter compile run hir mir example,$(firstword $(MAKECMDGOALS))),)
ifneq ($(TARGET),)
.PHONY: $(TARGET)
$(TARGET):
	@:
endif
endif

.PHONY: install
install: install-check-deps install-rust install-nasm
	@echo "Installed project toolchain:"
	@rustc --version
	@cargo --version
	@nasm -v

.PHONY: install-check-deps
install-check-deps:
	@command -v $(ASDF) >/dev/null || { echo "asdf is required. Install it first: https://asdf-vm.com/guide/getting-started.html"; exit 1; }
	@command -v curl >/dev/null || { echo "curl is required. On Debian: sudo apt-get install curl"; exit 1; }
	@command -v tar >/dev/null || { echo "tar is required. On Debian: sudo apt-get install tar"; exit 1; }
	@command -v gcc >/dev/null || { echo "gcc is required. On Debian: sudo apt-get install build-essential"; exit 1; }
	@command -v make >/dev/null || { echo "make is required. On Debian: sudo apt-get install build-essential"; exit 1; }
	@command -v ld >/dev/null || { echo "ld is required. On Debian: sudo apt-get install binutils"; exit 1; }
	@tmp_file="$$(mktemp)"; \
	  tmp_bin="$$(mktemp)"; \
	  printf '#include <zlib.h>\nint main(void) { return 0; }\n' > "$$tmp_file"; \
	  gcc -x c "$$tmp_file" -lz -o "$$tmp_bin" >/dev/null 2>&1 || { \
	    rm -f "$$tmp_file" "$$tmp_bin"; \
	    echo "zlib development headers are required. On Debian: sudo apt-get install zlib1g-dev"; \
	    exit 1; \
	  }; \
	  rm -f "$$tmp_file" "$$tmp_bin"

.PHONY: install-rust
install-rust:
	@$(ASDF) plugin list | grep -qx rust || $(ASDF) plugin add rust
	@$(ASDF) list rust $(RUST_VERSION) >/dev/null 2>&1 || $(ASDF) install rust $(RUST_VERSION)
	@$(ASDF) set rust $(RUST_VERSION)
	@$(ASDF) reshim rust

.PHONY: install-nasm
install-nasm:
	@$(ASDF) plugin list | grep -qx nasm || $(ASDF) plugin add nasm
	@if ! $(ASDF) list nasm $(NASM_VERSION) >/dev/null 2>&1; then \
	  tmp_dir="$$(mktemp -d)"; \
	  trap 'rm -rf "$$tmp_dir"' EXIT; \
	  curl -fsSL "$(NASM_URL)" -o "$$tmp_dir/nasm.tar.gz"; \
	  tar -xzf "$$tmp_dir/nasm.tar.gz" -C "$$tmp_dir"; \
	  cd "$$tmp_dir/nasm-$(NASM_VERSION)"; \
	  ./configure --prefix="$(ASDF_DATA_DIR)/installs/nasm/$(NASM_VERSION)"; \
	  make; \
	  make install; \
	fi
	@$(ASDF) set nasm $(NASM_VERSION)
	@$(ASDF) reshim nasm

.PHONY: compile
compile: $(FREESTANDING_ARCHIVES)
	@test -n "$(TARGET)" || { echo "usage: make compile <target> [INPUT=path/to/main.af]"; exit 2; }
	@mkdir -p bin
	@cargo run -p compiler -- $(INPUT) $(TARGET) bin/$(TARGET).asm
	@nasm -felf64 bin/$(TARGET).asm -o bin/$(TARGET).o
	@ld --gc-sections --strip-debug bin/$(TARGET).o $(FREESTANDING_ARCHIVES) -o bin/$(TARGET)

.PHONY: example
example: $(FREESTANDING_ARCHIVES)
	@test -f compile-direct/code/examples/$(TARGET)/main.af || { echo "unknown example: $(TARGET)"; exit 2; }
	@mkdir -p bin
	@cargo run -p compiler -- compile-direct/code/examples/$(TARGET)/main.af main bin/$(TARGET).asm
	@nasm -felf64 bin/$(TARGET).asm -o bin/$(TARGET).o
	@ld --gc-sections --strip-debug bin/$(TARGET).o $(FREESTANDING_ARCHIVES) -o bin/$(TARGET)
	@./bin/$(TARGET)
	@echo ""

$(MATH_ARCHIVE): kit/math/Cargo.toml kit/math/src/lib.rs Cargo.lock
	@cargo build -p freestanding-math --release

$(FORMAT_ARCHIVE): kit/format/Cargo.toml kit/format/src/lib.rs Cargo.lock
	@cargo build -p freestanding-format --release

.PHONY: run
run: compile
	@./bin/$(TARGET)

.PHONY: hir
hir:
	@test -n "$(TARGET)" || { echo "usage: make hir <target> [INPUT=path/to/main.af]"; exit 2; }
	@mkdir -p compile-direct/code/generated/$(TARGET)
	@cargo run -p compiler --bin render_hir -- $(INPUT) $(TARGET) compile-direct/code/generated/$(TARGET)/main.af

.PHONY: mir
mir:
	@test -n "$(TARGET)" || { echo "usage: make mir <target> [INPUT=path/to/main.af]"; exit 2; }
	@mkdir -p compile-direct/code/generated/$(TARGET)
	@cargo run -p compiler --bin render_mir -- $(INPUT) $(TARGET) compile-direct/code/generated/$(TARGET)/main.mir

.PHONY: test
test:
	@cargo test
