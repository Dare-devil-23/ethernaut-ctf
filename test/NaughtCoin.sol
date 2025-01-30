// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin public naughtCoin;
    address constant anvilAccount = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        naughtCoin = new NaughtCoin(anvilAccount);
    }

    function testTrnsfer() public {
        address friendAccount = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

        uint256 tokens = naughtCoin.balanceOf(anvilAccount);
        bool success = naughtCoin.approve(friendAccount, tokens);
        assert(success);

        console.log("Approving %s tokens from %s to %s", tokens, anvilAccount, friendAccount);

        naughtCoin.transferFrom(anvilAccount, friendAccount , tokens);

        console.log("Balance of %s: %s", anvilAccount, naughtCoin.balanceOf(anvilAccount));
        console.log("Balance of %s: %s", friendAccount, naughtCoin.balanceOf(friendAccount));

        assert(naughtCoin.balanceOf(anvilAccount) == 0);
        assert(naughtCoin.balanceOf(friendAccount) == tokens);
    }
}
