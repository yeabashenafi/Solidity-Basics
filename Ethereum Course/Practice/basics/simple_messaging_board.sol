// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SimpleMessagingBoard{

    address public myAddress;
    string public currentMessage;
    uint16 public noOfUpdates;
    bool public hasBeenUpdated;

    constructor (){
        myAddress = msg.sender;
    }

    function postMessage(string memory _message ) {
        currentMessage = _message;
        myAddress = msg.sender;
        noOfUpdates++;
        hasBeenUpdated = true;
    }

    function getCurrentMessage() public view returns(string memory){
        return currentMessage;
    }

    function getSender() public pure returns (uint256) {
        return msg.sender;
    }

}