//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract SampleContract {

    string public myString = "Hello World";

    // required to make the contract able to receive eth during deployment
    // constructor () payable {

    // }

    // since the function is payable values can be passed
    function update(string memory _newString) public payable{
        // msg.value gets the ether value on the contract
        // 1 ether is a common key word 
        if (msg.value == 1 ether){
            myString = _newString;
        }
        else{
            // sends the ether back to the sender 
            // msg.sender is the address that deployed the contract
            // transfer is a function that sends the specific amount
            // payable type casts the message sender to a payable type
            payable (msg.sender).transfer(msg.value);
        }
    } 
}