// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// shows how to use the require statement
contract ExampleExceptionRequire{

    // tracks the balances received 
    mapping(address => uint8) public balanceReceived;

    // ether receiving function
    function receiveMoney() public payable {
        // different from require in that it is used when the case must not be reached
        // and does not have a message
        // used to validate conditions that logically should never be used
        // if the assert fails the transaction will revert, all remaining gas will be consumed
        // assert failures are considered critical internal errors
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
    }

    // the withdraw function WHICH HODLDS THE REQUIRE STATEMENT
    // REQUIRE IS USED TO VALIDATE EXTERNAL CONDITIONS, INPUTS ABD STATE CHANGES
    // transaction is reverted and gas is returned to the sender
    function withdrawMoney(address payable _to, uint8 _amount ) public payable {
        require(_amount <= balanceReceived[msg.sender], "Reverting ! Not enough balance");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}