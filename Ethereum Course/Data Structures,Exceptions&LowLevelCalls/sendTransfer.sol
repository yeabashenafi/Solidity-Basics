// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// can send money to this contract using transact
// designed to hold ether and send it to other addresses
contract Sender{
    receive() external payable { }

    // sends 10 wei to the specified address
    // transfer is a high level function used to send to an address
    // transfer notifies when there is an error 
    // transfer only sends 2300 gas and is made to use only simple things
    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    // uses the send method of an address to transfer funds 10 wei
    // send is another high level function that sends a fixed 2300 gas stipend
    // send function does not notify when there is an error
    function withdrawSend(address payable _to) public {
        // require is required to check if send is successful
        bool isSent = _to.send(10);

        require(isSent,"Sending is unsuccessful");
    }
}

// A contract that receives ether without performing actions
contract ReceiverNoAction{

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}

// A contract that receives ether and performs action on the state
contract ReceiverAction{
    uint public balanceReceived;

    // assigning value to the variable costs more gas initially
    receive() external payable { 
        balanceReceived += msg.value;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }

}