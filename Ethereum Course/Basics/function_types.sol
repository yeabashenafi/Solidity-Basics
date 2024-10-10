// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract FunctionTypes{
    uint myStorageVariable;

    function getStorageVariable() public view returns(uint){
        return myStorageVariable;
    }

    function getAddition(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    function setMyStorageVariable(uint _newValue) public {
        myStorageVariable = _newValue;
    }
}