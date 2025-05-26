// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleConstructor{

    address public myAddress;

    // defines a constructor 
    constructor(address _newAdress){
        myAddress = _newAdress;
    }

    // sets the variable to the sender   
    function setMyAddressToMsgSender() public {
        // global variable that represents the address of the account that sends the transaction
        myAddress = msg.sender;
    }
}