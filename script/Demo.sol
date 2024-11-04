// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Service, topicIncremented} from "../contract/Service.sol";
import {ReactiveHandler} from "../contract/ReactiveHandler.sol";
import {Reactive} from "../contract/Reactive.sol";

contract Deploy is Script {
    uint256 constant LOCAL_CHAIN_ID = 31337;
    address constant KOPLI_CALLBACK_PROXY_ADDR = address(0x0000000000000000000000000000000000fffFfF);
    uint256 currentChainId;
    address deployer;
    uint256 deployerPrivateKey;
    Service public service;
    ReactiveHandler public reactiveHandler;
    Reactive public reactive;

    function setUp() public {
        currentChainId = block.chainid;
        deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        if (currentChainId != LOCAL_CHAIN_ID) {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        deployer = vm.addr(deployerPrivateKey);
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        service = new Service();
        reactiveHandler = new ReactiveHandler();
        (bool success,) = address(reactiveHandler).call{value: 0.1 ether}("");
        require(success, "deposit reactive handler failed");
        vm.stopBroadcast();
        string memory reactiveRpcUrl = "http://127.0.0.1:8545";
        if (currentChainId != LOCAL_CHAIN_ID) {
            reactiveRpcUrl = vm.rpcUrl("reactive");
        }
        vm.createFork(reactiveRpcUrl);
        vm.startBroadcast(deployerPrivateKey);
        reactive = new Reactive(
            currentChainId, KOPLI_CALLBACK_PROXY_ADDR, address(service), topicIncremented(), address(reactiveHandler)
        );
        vm.stopBroadcast();
    }
}
