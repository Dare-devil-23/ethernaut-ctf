//SPDX-License-Identifier: MIT

// The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

// You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

// You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

pragma solidity ^0.8.0;

import {Test, console} from 'forge-std/Test.sol';
import {Dex, SwappableToken} from '../src/Dex.sol';

contract DexTest is Test {
    Dex dex;

    function setUp() public {
        dex = new Dex();
    }

    function test() public {
        SwappableToken token1 = new SwappableToken(address(dex), "Token1", "TKN1", 10000000000);
        SwappableToken token2 = new SwappableToken(address(dex), "Token2", "TKN2", 10000000000);

        dex.setTokens(address(token1), address(token2));

        dex.approve(address(this), type(uint256).max);
 
    }
}
