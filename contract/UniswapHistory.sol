// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {AbstractCallback} from "./system/AbstractCallback.sol";

contract UniswapHistory is AbstractCallback {
    event RequestReSync(address indexed pair, uint256 indexed block_number);

    event ReSync(address indexed pair, uint256 indexed block_number, uint112 reserve0, uint112 reserve1);

    address private owner;

    constructor(address _callback_sender) payable AbstractCallback(_callback_sender) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    receive() external payable {}

    function request(address pair, uint256 block_number) external onlyOwner {
        emit RequestReSync(pair, block_number);
    }

    function resync(address, /* sender */ address pair, uint256 block_number, uint112 reserve0, uint112 reserve1)
        external
        authorizedSenderOnly
    {
        emit ReSync(pair, block_number, reserve0, reserve1);
    }
}
