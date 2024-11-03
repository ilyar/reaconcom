#!/usr/bin/make -f

default: release

dependencies:
	@forge soldeer install

build: dependencies
	@forge build --sizes

build/bindings: build
	@forge bind --single-file --crate-name contract --skip-cargo-toml --alloy

release: build/bindings
	@cargo build --release

clean:
	@cargo clean
	@forge clean
	@rm -fr dependencies cache broadcast

lint: build/bindings
	@forge fmt --check
	@cargo +nightly fmt --all --check
	@cargo +nightly clippy --workspace --tests --all-features

fmt:
	@forge fmt
	@cargo +nightly fmt --all

test: build/bindings
	@forge test
	@cargo +nightly test

qa: lint test

.PHONY: release clean fmt lint test qa
