// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator {
    function goTo(uint256 _floor) external;
}

contract Building {
    Elevator elevator;
    uint256 public top;

    constructor(address _elevator){
        elevator = Elevator(_elevator);
    }

    function isLastFloor(uint256 _floor) external returns (bool){
        if(top == _floor){
            return true;
        }
        top = _floor;
        return false;
    }

    function goTo(uint256 _floor) public {
        elevator.goTo(_floor); 
    }
}
