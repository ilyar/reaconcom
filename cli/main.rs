use alloy::{
    network::EthereumWallet,
    primitives::{Address, U256},
    providers::{Provider, ProviderBuilder, WsConnect},
    signers::local::{coins_bip39::English, LocalSignerError, MnemonicBuilder, PrivateKeySigner},
};
use reaconcom::Service;

fn new_singer(phrase: &str) -> Result<PrivateKeySigner, LocalSignerError> {
    let index = 0u32;
    let password = "";

    // Access mnemonic phrase with password.
    // Child key at derivation path: m/44'/60'/0'/0/{index}.
    MnemonicBuilder::<English>::default()
        .phrase(phrase)
        .index(index)?
        // Use this if your mnemonic is encrypted.
        .password(password)
        .build()
}

#[tokio::main]
async fn main() -> eyre::Result<()> {
    let phrase = "test test test test test test test test test test test junk";
    let rpc_url = "ws://localhost:8545";
    let wallet = EthereumWallet::from(new_singer(phrase)?);
    let ws = WsConnect::new(rpc_url);
    let provider =
        ProviderBuilder::new().with_recommended_fillers().wallet(wallet).on_ws(ws).await?;

    // Get latest block number
    let latest_block = provider.get_block_number().await?;

    // Print the block number
    println!("Latest block number: {latest_block}");

    let address = "0x9d4454b023096f34b160d6b654540c56a1f81688".parse::<Address>()?;
    //
    let contract = Service::new(address, provider);
    let tx_hash = contract.increment().send().await?.watch().await?;
    println!("increment tx: {tx_hash}");
    let number = contract.number().call().await?._0;
    println!("number={number}");
    let leader = contract.leader().call().await?._0;
    println!("leader={leader}");
    let tx_hash = contract.dibs(U256::from(7)).send().await?.watch().await?;
    println!("dibs tx: {tx_hash}");
    Ok(())
}
