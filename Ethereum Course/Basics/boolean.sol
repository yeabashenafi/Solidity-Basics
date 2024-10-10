// SPDX-License-Identifier: MIT
pragma solidity  0.8.14;

contract BooleanContract{
    bool public myBool;

    function setMyBool(bool _mybool) public{
        myBool = _mybool;
    }
}