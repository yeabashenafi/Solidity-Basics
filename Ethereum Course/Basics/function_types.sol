// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract FunctionTypes{
    // stores 256-bit unsigned integer
    uint myStorageVariable;

    // view is a state mutability specifier that doesn't modfiy state variables but only reads them
    // typically dont cost gas externally
    function getStorageVariable() public view returns(uint){
        return myStorageVariable;
    }
    
    // pure is a state mutability modifier that does not read or modify state variables only operates on the input variables and global block chain variables
    // typically dont cost gas externally
    function getAddition(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    // when no state mutability modifier means the function modifies the state
    function setMyStorageVariable(uint _newValue) public {
        myStorageVariable = _newValue;
    }
}