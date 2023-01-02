## Vault Challenge

## The goal of this challenge is to unlock the locked vault and switch the boolean

Solidity Code: 

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```

Looking at the smart contract it is very clear that the only piece of code that switches the boolean is in the unlock function itself which says if the `password` state variable was equivalent to the `_password` input then the vault will be unlocked.

Now how do you find the password if it's a private state variable???

Well listen to this, This data can be read on the blockchain and let me clarify that setting up the variable in state doesn't mean it's been restricted of being seen and the data it consists of, but it actually means that this state has been pragrammaticaly locked from being accessed elsewhere.

So we can still read the state on the blockchain. Now there are many ways of reading this, you go to [alchemy composer](https://composer.alchemy.com/) and call the method `eth_getStorage_At()` and check the first index since the index 0 will be the first state variable of the contract which is the boolean locked.

After sending the request you will be able to get the response and the result should consist of the bytehash.

And that's your password, Now go ahead and call the unlock function and pass this hash as a parameter and boooom!!!

State variable changed, and the challenge is solved!