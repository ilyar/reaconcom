#!/usr/bin/make -f

default: release

dependencies:
	forge soldeer install
build/contract/%.sol: contract/%.sol dependencies
	forge build --out build/contract $<
build/script/%.sol: script/%.sol dependencies
	forge build --out build/script $<

contract/sdk: build/contract/Service.sol build/contract/ReactiveHandler.sol
	forge bind --bindings-path contract/sdk \
--select ReactiveHandler \
--select Service \
--crate-name contract \
--crate-version $(shell cat version) \
--alloy --alloy-version b2278c4

release/reaconcom: contract/sdk
	cargo build --release -p cli
	mrdir -p release
	cp target/release/reaconcom release/reaconcom
release: release/reaconcom
run:
	cargo run -p cli

build/computing.wasm.gz:
	cargo run -p computing
	RUSTFLAGS='-C link-arg=-s' cargo build --target wasm32-unknown-unknown --release -p computing
	cat target/wasm32-unknown-unknown/release/computing.wasm | gzip -9 > build/computing.wasm.gz

clean:
	cargo clean
	forge clean
	rm -fr dependencies cache broadcast release

lint: contract/sdk
	forge fmt --check
	cargo +nightly fmt --all --check
	cargo +nightly clippy

fmt: contract/sdk
	forge fmt
	cargo +nightly fmt --all

test-contract: contract/sdk
	forge test

test: test-contract
	cargo +nightly test

qa: lint test

deploy: build/script/demo.sol
	FOUNDRY_PROFILE=local forge script --quiet --broadcast script/demo.sol:deploy
