// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// can send money to this contract using transact
contract Sender{
    receive() external payable { }

    // transfer notifies when there is an error 
    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    // send function does not notify when there is an error
    function withdrawSend(address payable _to) public {
        // require is required to check if send is successful
        bool isSent = _to.send(10);

        require(isSent,"Sending is unsuccessful");
    }
}

contract ReceiverNoAction{

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}

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