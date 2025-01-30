// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/DoubleEntryPoint.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract DetectionBot {
    address private cryptoVault;

    constructor(address _cryptoVault) {
        cryptoVault = _cryptoVault;
    }
    
    function handleTransaction(address user, bytes calldata msgData) public {
        address origSender;

        assembly {
            origSender := calldataload(0xa8)
        }

        if(origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }

        console.logBytes(msgData);
    }
}

contract DoubleEntryPointAttack is Script {
    DoubleEntryPoint public doubleEntryPoint = DoubleEntryPoint(0xa965d41D29B8535bf0452cF941E81f6aBa2F74Bb);
    Forta public forta = Forta(address(doubleEntryPoint.forta()));
    LegacyToken public legacyToken = LegacyToken(address(doubleEntryPoint.delegatedFrom()));
    CryptoVault public cryptoVault = CryptoVault(address(doubleEntryPoint.cryptoVault()));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        DetectionBot detectionBot = new DetectionBot(address(doubleEntryPoint.cryptoVault()));

        forta.setDetectionBot(address(detectionBot));
        cryptoVault.sweepToken(legacyToken);

        vm.stopBroadcast();
    }
}