// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Service} from "../contract/Service.sol";

contract CounterTest is Test {
    Service public service;

    function setUp() public {
        service = new Service();
    }

    function testBaseCase() public {
        service.increment();
        assertEq(service.number(), 1);
        assertEq(service.leader(), address(0));

        vm.prank(address(0x1));
        service.dibs(1);
        assertEq(service.leader(), address(0x1));

        vm.prank(address(0x1));
        service.increment();
        assertEq(service.number(), 1);

        vm.prank(address(0x2));
        service.increment();
        assertEq(service.number(), 2);

        vm.prank(address(0x2));
        service.dibs(2);
        assertEq(service.leader(), address(0x2));
    }
}
