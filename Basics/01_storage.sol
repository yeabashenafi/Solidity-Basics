//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage{

    uint256 storedValue;

    function set(uint256 x) public{
        storedValue = x;
    }

    function get() public view returns (uint256){
        return storedValue;
    }
}