// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {AbstractCallback} from "./system/AbstractCallback.sol";

contract ReactiveHandler is AbstractCallback {
    event CallbackReceived(address indexed origin, address indexed sender, address indexed reactive_sender);

    constructor() payable AbstractCallback(address(0)) {}

    receive() external payable {}

    function callback(address sender) external {
        emit CallbackReceived(tx.origin, msg.sender, sender);
    }
}
