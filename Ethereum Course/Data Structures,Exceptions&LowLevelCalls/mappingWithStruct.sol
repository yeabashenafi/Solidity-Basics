// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// advanced way to handle user balances and individual deposit and withdrawal 
contract MappingStructExample{

    // created to track the specific withdrawal and deposits
    struct Transaction{
        uint amount;
        uint timestamp;
    }

    // holds all financial related information for a single user
    struct Balance{
        // stores the total balance
        uint totalBalance;
        // a counter to keep track of the no of deposits made by a user 
        uint numDeposits;
        // nested mapping within a struct which maps an int index to the transaction struct
        // tracks each deposit transaction made
        mapping(uint => Transaction) deposits;
        // a counter to keep track of the no of withdrawals made by a user 
        uint numWithdrawals;
        // nested mapping within a struct which maps an int index to the transaction struct
        // tracks each withdrawal transaction made
        mapping(uint => Transaction) withdrawals;
    }

    // the main state variable that holds all financial data
    // maps the user's address to a balance struct
    mapping(address => Balance) public balances;

    // allows the retrieval of a specific deposit record for a user
    // returns the Transaction struct
    // uses view since the function does not modify the blockchain state but reads from it
    function getDepositNum(address _from, uint _numDeposit) public view returns(Transaction memory) {
        // fetches a specific deposit inside the balances mapping by index
        return balances[_from].deposits[_numDeposit];
    }
    
    // allows users to deposit money and function can receive ether this way
    function depositMoney() public payable{
        // adds the sent ether to the total balance property
        balances[msg.sender].totalBalance += msg.value;

        // creates a new transaction struct in memory by populating amount and timestamp taken fromm the block's timestamp
        Transaction memory deposit = Transaction(msg.value, block.timestamp);

        // add the created deposit transaction to the balances mapping inside the deposits mapping
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit; 

        // increment the no of deposits counter variable inside the users balances mapping
        balances[msg.sender].numDeposits ++;

    }

    // allows users to withdraw money 
    function withdrawMoney(address payable _to , uint _amount) public {
        // decreases the sent ether from the total balance property
        balances[msg.sender].totalBalance -= _amount;

        // creates a new transaction struct in memory by populating amount and timestamp taken from the block's timestamp
        Transaction memory withdrawal = Transaction(_amount , block.timestamp);

        // add the created withdrawal transaction to the balance mapping inside the withdrwals mapping
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;

        // increment the no of withdrawals counter varaiable inside the users balances mapping
        balances[msg.sender].numWithdrawals --;

        _to.transfer(_amount);
    }

     
}