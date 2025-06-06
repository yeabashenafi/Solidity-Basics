// SPDX-License-Identifier: MIT
pragma solidity  0.8.15;

contract BooleanContract{
    bool public myBool;

    function setMyBool(bool _mybool) public{
        myBool = _mybool;
    }
}