// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {AbstractCallback} from "reactive-lib/abstract-base/AbstractCallback.sol";

contract ReactiveHandler is AbstractCallback {
    event CallbackReceived(address indexed origin, address indexed sender, address indexed reactive_sender);

    constructor() payable AbstractCallback(address(0)) {}

    receive() external payable override {}

    function callback(address sender) external {
        emit CallbackReceived(tx.origin, msg.sender, sender);
    }
}
