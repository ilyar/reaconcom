// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {AbstractReactive} from "reactive-lib/abstract-base/AbstractPausableReactive.sol";
import {ISystemContract} from "reactive-lib/interfaces/ISystemContract.sol";

contract Reactive is AbstractReactive {
    event Event(
        uint256 indexed chain_id,
        address indexed _contract,
        uint256 indexed topic_0,
        uint256 topic_1,
        uint256 topic_2,
        uint256 topic_3,
        bytes data,
        uint256 counter
    );

    //    uint256 private constant SEPOLIA_CHAIN_ID = 11155111;

    uint64 private constant GAS_LIMIT = 1000000;

    // State specific to reactive network instance of the contract

    uint256 private CHAIN_ID;
    address private _callback;

    // State specific to ReactVM instance of the contract

    uint256 public counter;

    constructor(uint256 chain_id, address proxy, address provider, bytes32 topic, address callback) {
        service = ISystemContract(payable(proxy));
        CHAIN_ID = chain_id;
        bytes memory payload = abi.encodeWithSignature(
            "subscribe(uint256,address,uint256,uint256,uint256,uint256)",
            CHAIN_ID,
            provider,
            topic,
            REACTIVE_IGNORE,
            REACTIVE_IGNORE,
            REACTIVE_IGNORE
        );
        (bool subscription_result,) = address(service).call(payload);
        vm = !subscription_result;
        _callback = callback;
    }

    // Methods specific to ReactVM instance of the contract

    function react(
        uint256 chain_id,
        address _contract,
        uint256 topic_0,
        uint256 topic_1,
        uint256 topic_2,
        uint256 topic_3,
        bytes calldata data,
        uint256, /* block_number */
        uint256 /* op_code */
    ) external vmOnly {
        emit Event(chain_id, _contract, topic_0, topic_1, topic_2, topic_3, data, ++counter);
        if (topic_3 >= 0.1 ether) {
            bytes memory payload = abi.encodeWithSignature("callback(address)", address(0));
            emit Callback(chain_id, _callback, GAS_LIMIT, payload);
        }
    }

    // Methods for testing environment only

    function pretendVm() external {
        vm = true;
    }

    function subscribe(address provider, uint256 topic) external {
        service.subscribe(CHAIN_ID, provider, topic, REACTIVE_IGNORE, REACTIVE_IGNORE, REACTIVE_IGNORE);
    }

    function unsubscribe(address provider, uint256 topic) external {
        service.unsubscribe(CHAIN_ID, provider, topic, REACTIVE_IGNORE, REACTIVE_IGNORE, REACTIVE_IGNORE);
    }

    function resetCounter() external {
        counter = 0;
    }
}
