// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Impersonator, ECLocker} from "../src/Impersonator.sol";

contract ImpersonatorTest is Test {
    Impersonator impersonator;
    uint256 private constant PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // Fixed test private key
    address signer;

    function setUp() public {
        signer = vm.addr(PRIVATE_KEY); // Generate address from private key

        vm.prank(signer); // Use the signer as the transaction sender
        impersonator = new Impersonator(1336);

        console.log("owner:", impersonator.owner());
    }

    function testSomething() public pure {
        // Compute lockId (next lock ID)
        uint256 lockId = 1337; 

        // Compute msgHash same as contract
        bytes32 msgHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", bytes32(lockId)));
        
        // Sign the msgHash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PRIVATE_KEY, msgHash);

        // Construct signature (r, s, v)
        bytes memory signature = abi.encodePacked(r, s, v);
        
        bytes32 _msgHash;
        assembly {
            mstore(0x00, "\x19Ethereum Signed Message:\n32") // 28 bytes
            mstore(0x1C, lockId) // 32 bytes
            _msgHash := keccak256(0x00, 0x3c) //28 + 32 = 60 bytes
        }
        
        // Recover the initial controller from the signature
        // address initialController = address(1);
        uint8 _v;
        bytes32 _r;
        bytes32 _s;

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, _msgHash) // 32 bytes
            mstore(add(ptr, 32), mload(add(signature, 0x60))) // 32 byte v
            mstore(add(ptr, 64), mload(add(signature, 0x20))) // 32 bytes r
            mstore(add(ptr, 96), mload(add(signature, 0x40))) // 32 bytes s
            
            mstore(0x40, add(ptr, 128))

            _v := byte(0, mload(add(signature, 0x60)))
            _r := mload(add(signature, 0x20))
            _s := mload(add(signature, 0x40))
            
        }

        assertEq(_msgHash, msgHash);
        assertEq(_r, r);
        assertEq(_s, s);
        assertEq(_v, v);
        
    }
}
