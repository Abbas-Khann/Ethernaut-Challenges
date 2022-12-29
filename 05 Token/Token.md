## Token Challenge

### The goal of this challenge of this challenge is to end up getting additional tokens from the contract, and we only have 20 tokens to work with initially.

Solidity Code: 

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```

The bug can almost be found in the very beginning of the smart-contract by checking the solidity version. SafeMath was introduced after solidity verison 0.8

So if we were to execute the `transfer` function and input over 20 tokens, since we would be given 20 tokens in the beginning and due to overflow and underflow we would get some crazy number of tokens into the `msg.sender` address.

Next, we will paste another address in the transfer function and make a function call.

```
await contract.transfer({ value: "<paste-address-here>" }, 21);
```

And there you have it this would result in the contract transferring tokens.