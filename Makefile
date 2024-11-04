#!/usr/bin/make -f

default: release

dependencies:
	forge soldeer install

build: dependencies contract
	forge build --sizes

build/bindings: build
	forge bind --single-file --crate-name contract --skip-cargo-toml --alloy

release/reaconcom: build/bindings
	cargo build --release -p cli
	mrdir -p release
	cp target/release/reaconcom release/reaconcom
release: release/reaconcom

build/computing.wasm.gz:
	cargo run -p computing
	RUSTFLAGS='-C link-arg=-s' cargo build --target wasm32-unknown-unknown --release -p computing
	cat target/wasm32-unknown-unknown/release/computing.wasm | gzip -9 > build/computing.wasm.gz

clean:
	cargo clean
	forge clean
	rm -fr dependencies cache broadcast release

lint: build/bindings
	forge fmt --check
	#FIXME cargo +nightly fmt --all --check
	#FIXME cargo +nightly clippy

fmt: build/bindings
	forge fmt
	cargo +nightly fmt --all

test-contract: build/bindings
	forge test

test: test-contract
	#FIXME cargo +nightly test

qa: lint test

deploy: build
	FOUNDRY_PROFILE=local forge script script/Demo.sol:Deploy --broadcast
