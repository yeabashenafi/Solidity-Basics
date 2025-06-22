// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleMappingWithdrawal{
    // key value pair where the key is an ethereum cinema
    mapping(address => uint) public balanceReceived;

    // function that can receive eth
    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    // returns the balance of the contract itself
    function getBalance() public view returns(uint){
        return  address(this).balance;
    }

    function withdrawAllMoney(address payable _to) public {
        // gets the balance for the sender address inside the balance Received variable
        uint balanceToSendOut = balanceReceived[msg.sender];
        // sets the msg senders value in the mapping to 0
        balanceReceived[msg.sender] = 0;
        // actually sends the amount to the address in the parameter
        _to.transfer(balanceToSendOut);
    }
}