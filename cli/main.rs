use alloy::{
    primitives::Address,
    providers::{Provider, ProviderBuilder, WsConnect},
};
use contract::Service;
use eyre::Result;

#[tokio::main]
async fn main() -> Result<()> {
    // Set up the HTTP transport which is consumed by the RPC client.
    // let rpc_url = "https://eth.merkle.io".parse()?;
    // let rpc_url = "http://localhost:8545".parse()?;
    // Create a provider with the HTTP transport using the `reqwest` crate.
    // let provider = ProviderBuilder::new().on_http(rpc_url);

    // Create the provider
    let rpc_url = "ws://localhost:8545";
    let ws = WsConnect::new(rpc_url);
    let provider = ProviderBuilder::new().on_ws(ws).await?;

    // Get latest block number
    let latest_block = provider.clone().get_block_number().await?;

    // Print the block number
    println!("Latest block number: {latest_block}");

    let address = "0x5fbdb2315678afecb367f032d93f642f64180aa3".parse::<Address>()?;
    //
    let contract = Service::new(address, provider);
    let tx_hash = contract.increment().send().await?.watch().await?;
    println!("Incremented number: {tx_hash}");
    let number = contract.number().call().await?._0;
    println!("number={number}");

    Ok(())
}
