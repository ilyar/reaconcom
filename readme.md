# Reaconcom [![ci](https://github.com/ilyar/reaconcom/actions/workflows/ci.yml/badge.svg)](https://github.com/ilyar/reactive-hackathon/actions/workflows/ci.yml)

**Rea**ctive **Con**fidential **Com**puting work fully on-chain and trusted execution environments (TEE) via Intel SGX

```mermaid
---
title: Reaconcom
---
%%{ init: { 'flowchart': { 'curve': 'basis' } } }%%
flowchart RL
    subgraph cli["CLI"]
        setup -. call .-> computing
        subgraph SN["Secret Network"]
            subgraph CC["Confidential Computing"]
                computing("ComputingContract")
            end
            subgraph SPSN["SecretPath"]
                gatewaySN("GatewayContract")
            end
        end

        external -. call .-> appL1
        appL1 -. event .-> appL1
        subgraph L1["L1 Network"]
            subgraph EVM["EVM"]
                appL1("ServiceContract")
                сallbackL1("CallbackContract")
                gatewayL1("GatewayContract")
            end
        end

        subgraph RN["Reactive Network"]
            subgraph RVM["ReactVM"]
                reactiveRN("ReactiveContract")
            end
        end
    end

    appL1 -. emitted log .-> reactiveRN
    reactiveRN -. emitted log .-> сallbackL1
    сallbackL1 -. emitted log .-> gatewayL1
    gatewayL1 -. emitted log .-> gatewaySN
    gatewaySN -. emitted log .-> computing
    computing -. callback .-> gatewaySN
    gatewaySN -. callback .-> gatewayL1
    gatewayL1 -. callback .-> appL1
```

## Work in progress

- [x] gateway contract via Secret Network
- [ ] implement computing contract
- [x] implement destination contract
- [ ] implement reactive contract via Reactive Network
- [x] implement demo observed contract
- [ ] deploy demo case
- [ ] implement cli
- [ ] add usage description
- [x] add tests destination basic case
- [ ] add tests reactive basic case
- [ ] add tests demo case

## Usage

TBD

## Development

### Setup environment

```shell
curl -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
cargo install cargo-generate --features vendored-openssl
curl -L -o secretcli-Linux https://github.com/scrtlabs/SecretNetwork/releases/latest/download/secretcli-Linux
chmod +x secretcli-Linux
mv secretcli-Linux /usr/local/bin/secretcli
curl -sSf https://foundry.paradigm.xyz | sh
```

### Coding

```shell
make qa
make fmt
```

### Release

```shell
make release
```