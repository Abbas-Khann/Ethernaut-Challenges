## Force Challenge

## The goal of this challenge is to send money to this completely empty contract with absolutely nothing.

Solidity Code: 

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
```

Well, what do you do with that? In order to send money to a contract you need a payable fallback or a recieve function or any other function that is payable. So how can we fund this contract?

Well, there is one way to do that and that is by using the keyword `selfdestruct()`

`selfdestruct` basically destroys the contract that consists of this keyword after the particular function is called and it funds the contract address that is passed into it.

It is important to note that `selfdestruct()` only takes payable addresses and will throw a compilation error if the provided address is not payable.


So let's fund the empty contract by getting it's instance in a payable constructor in a new contract and call selfdestruct on the constructor itself so that the paid eth goes directly to the empty contract as soon as it's deployed.

```javascript

contract HackForce {

    constructor(address payable _target) payable {
        selfdestruct(_target);
    }

}

```

and there you have it, We just funded the completely empty contract and the challenge is passed!!!