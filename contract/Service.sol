// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

function topicIncremented() pure returns (bytes32) {
    return keccak256("Incremented(address,address,uint256)");
}

contract Service {
    event Incremented(address indexed origin, address indexed sender, uint256 number);

    uint256 public number;
    address public leader;

    function increment() public {
        if (leader == msg.sender) {
            return;
        }
        number++;
        emit Incremented(tx.origin, msg.sender, number);
    }

    function dibs(uint256 value) public {
        if (leader != msg.sender && number == value) {
            leader = msg.sender;
        }
    }
}
