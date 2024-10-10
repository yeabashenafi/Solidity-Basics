// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleConstructor{

    address public myAddress;

    constructor(address _newAdress){
        myAddress = _newAdress;
    }

    function setMyAddressToMsgSender() public {
        myAddress = msg.sender;
    }
}