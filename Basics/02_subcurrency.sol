//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin{
    // public keyword makes vaeiables accessible from other contracts
    address public minter;
    // the address type is 160 bit and does not allow any arithmetic operations
    // mappings are key value pairs
    mapping(address => uint) public balances;

    // Events allow clients to react to specific contract changes you declare
    // Events can be listened to by any web applications
    // it makes it possible to track transactions
    event Sent(address from, address to, uint amount);

    // constructor code is run when the contract is created
    constructor() {
        // msg variable along with tx and block variables are special global variables
        // msg.sender tells where the function call came from
        minter = msg.sender;
    }

    // Sends a newly created amount of coins to an address
    // can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        // require checks conditions that should be met
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Errors are returned to callers of the function
    error InsufficientBalance(uint requested, uint available);

    // sends an amount of existing coins from the caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender]){
            // revert aborts the current operations similar to the require keyword
            // revert allows us to provide the error message and type
            revert InsufficientBalance(amount,balances[msg.sender]);
        }
        
        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);   
    }

}