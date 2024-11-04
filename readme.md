# Reaconcom [![ci](https://github.com/ilyar/reaconcom/actions/workflows/ci.yml/badge.svg)](https://github.com/ilyar/reactive-hackathon/actions/workflows/ci.yml)

**Rea**ctive **Con**fidential **Com**puting work fully on-chain and trusted execution environments (TEE) via Intel SGX

```mermaid
---
title: Reaconcom
---
%%{ init: { 'flowchart': { 'curve': 'basis' } } }%%
flowchart RL
    subgraph cli["CLI"]
        subgraph SN["Secret Network"]
            subgraph CC["Confidential Computing"]
                SNCC("ComputingContract")
            end
            subgraph SP["SecretPath"]
                SNGC("GatewayContract")
            end
     
        end
        subgraph L1["L1 Network"]
            subgraph EVM["EVM"]
                L1OC("ObservedContract")
                L1DC("DestinationContract")
            end
        end
        subgraph RN["Reactive Network"]
            subgraph RVM["ReactVM"]
                RNC("ReactiveContract")
            end
        end
    end

    L1OC -. emitted log .-> RNC
    RNC -. emitted log .-> SNGC
    SNGC -. emitted log .-> CC
    CC -. callback .-> SNGC
    SNGC -. callback .-> L1DC
```

## Work in progress

- [x] gateway contract via Secret Network
- [ ] implement computing contract
- [ ] implement destination contract
- [ ] implement reactive contract via Reactive Network
- [ ] implement demo observed contract
- [ ] deploy demo case
- [ ] implement cli
- [ ] add usage description
- [ ] add tests

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