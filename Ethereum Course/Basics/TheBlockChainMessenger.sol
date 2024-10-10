// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract TheBlockChainMessenger{

    uint public changeCounter;

    address public owner;

    string public theMessage;

    constructor () {
        owner = msg.sender;
    }

    function updateTheMessage(string memory _newMessage) public {
        theMessage = _newMessage;
        changeCounter++;
    }
}