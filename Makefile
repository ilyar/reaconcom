#!/usr/bin/make -f

default: release

dependencies:
	forge soldeer install

build: dependencies
	forge build --sizes

build/bindings: build
	forge bind --single-file --crate-name contract --skip-cargo-toml --alloy

release: build/bindings
	cargo build --release -p reaconcom

computing:
	cargo run -p computing
	RUSTFLAGS='-C link-arg=-s' cargo build --target wasm32-unknown-unknown --release -p computing
	cat target/wasm32-unknown-unknown/release/computing.wasm | gzip -9 > build/computing.wasm.gz

clean:
	cargo clean
	forge clean
	rm -fr dependencies cache broadcast

lint: build/bindings
	forge fmt --check
	cargo +nightly fmt --all --check
	cargo +nightly clippy

fmt:
	forge fmt
	cargo +nightly fmt --all

test: build/bindings
	forge test
	cargo +nightly test

qa: lint test

.PHONY: release clean fmt lint test qa
