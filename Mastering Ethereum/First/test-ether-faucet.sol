// version of solidity compiler this program was written for
// SPDX-License-Identifier: MIT
pragma solidity ^0.4.19;

// our first contract is a faucet
contract faucet {
    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        // limit withdrawal amount
        require(withdraw_amount <= 100000000000000000);

        // send the amount to the address that requested it
        msg.sender.transfer(withdraw_amount);
    }

    // Accept any incoming amount
    function() external  payable {}
}