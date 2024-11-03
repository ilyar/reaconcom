# reactive-hackathon

[![ci](https://github.com/ilyar/reactive-hackathon/actions/workflows/ci.yml/badge.svg)](https://github.com/ilyar/reactive-hackathon/actions/workflows/ci.yml)

## Setup

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl --proto '=https' --tlsv1.2 -sSf https://foundry.paradigm.xyz | sh
```

## Development

```shell
make qa
make fmt
```

## Release

```shell
make release
```