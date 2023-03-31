## Privacy Challenge

## The goal of this challenge is to set the unlock state variable to false

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}
```

Understanding how memory slots in solidity work is important in solving this challenge.

First off it's important to note that each variable can take upto 256 bits which is 32 bytes.

Let's look at all the variables we have here and check their slots

```javscript
    <!-- bool is only 0 - 1 --> So it only takes two bits of data it will go into slot 0
    bool public locked = true;
    <!-- ID is a uint256 so it will take up a complete 256 bits which is why we can't shove boolean in there with it and this will occupy slot 1 -->
    uint256 public ID = block.timestamp;
    <!-- The next three are uint8 and 16 variables which means they only occupy upto 8 - 16 bits of data so they can all go into slot 2 -->
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    <!-- bytes32, arrays, strings or anything with dynamic memory always starts at it's own storage slots and they can't be shoved into previously existing slots so this will start at slot 3 but the data type here is bytes32[3] which means there are 3 elements so it will have a flow like this -->
    <!-- bytes32[0] => slot 3 -->
    <!-- bytes32[1] => slot 4 -->
    <!-- bytes32[2] => slot 5 -->
    <!-- bytes32[3] => slot 6 -->
    bytes32[3] private data;
```

We care about slot 5 in this case since that's what will allow us to call the unlock function successfully.

Now if you look at the unlock function it requires bytes16 to be passed in and if that is equivalent to bytes16(data[2]) it will set the boolean to false.

We can access the slot 5 via [alchemy composer](https://dashboard.alchemy.com/composer) by passing in the address of the contract.

Next we can slice the returned data in half using the slice method and pass it to the function.
And Boom!!!
The contract is unlocked!
