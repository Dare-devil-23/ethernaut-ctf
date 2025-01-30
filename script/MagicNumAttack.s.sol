// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import  "../src/MagicNum.sol";
import {Script} from "forge-std/Script.sol";

contract MagicNumAttack is Script {
    MagicNum public magicNum = MagicNum(0xFB7cAe54dE608350DD535eF0521f1f699216581d);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address solverInstance;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
            solverInstance := create(0, ptr, 0x13)
        }

        magicNum.setSolver(solverInstance);

        vm.stopBroadcast();
    }
}