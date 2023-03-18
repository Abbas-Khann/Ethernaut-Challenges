// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CoinFlip.sol";

contract CoinFlipTest is Test {
    CoinFlip public coinFlip;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {
        coinFlip = new CoinFlip();
    }

    function getSide() public view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 flip = blockValue / FACTOR;
        bool side = flip == 1 ? true : false;
        return side;
    }

    // The test will always fail since the value initially is false from the getSide() function and that's what we're passing, but in a real environment it would only execute if the bool was returned true otherwise it wouldn't call the functin in the first place
    function testperformCorrectFlipping() public {
        bool _guess = getSide();
        require(coinFlip.flip(_guess) == true, "NOT TRUE");
        bool correctGuess = true ? coinFlip.flip(_guess) : true;
        assertEq(correctGuess, true);
    }
}
