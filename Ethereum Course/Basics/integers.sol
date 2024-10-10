// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract ExampleInt{
    uint256 public myUint;

    function setMyUint(uint _myuint) public{
        myUint = _myuint;
    }
}