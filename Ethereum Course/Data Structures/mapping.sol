// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleMapping{

    mapping(uint => bool) public MyMapping;
    mapping(address => bool) public myAddressMapping;
    mapping(uint => mapping(uint => bool)) public uintuintBoolMapping;

    function setValue(uint _index) public{
        MyMapping[_index] = true;
    }

    function setMyAddressToTrue() public{
        myAddressMapping[msg.sender] = true;
    }

    function setUintUintBoolMapping(uint _key1, uint _key2, bool _value) public{
        uintuintBoolMapping[_key1][_key2] = _value;
    }
}