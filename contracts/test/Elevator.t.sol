// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Elevator.sol";

contract ElevatorTest is Test {
    Elevator public elevator;
    Hack public hack;

    function setUp() public {
        elevator = new Elevator();
        hack = new Hack(msg.sender);
    }

    function testTopBoolean() public {
        assertFalse(elevator.top());
    }

    function test_isLastFloor() public {
        assertFalse(hack.isLastFloor(1));
        assertTrue(hack.isLastFloor(1));
    }
}
