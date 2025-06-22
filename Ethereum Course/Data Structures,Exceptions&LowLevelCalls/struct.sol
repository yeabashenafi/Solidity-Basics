// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// this code compares internal struct implementation versus external contract instantiation
// and shows the struct option is prefferable because it is more efficient and cost less gas

// attempts to record payment information by deploying a new payment received contract instance everytime a payment is made
contract Wallet {
    // defines a public variable of type PaymentReceived
    // when ever a contract name is used the address of an instance of the contract is being referred
    PaymentReceived public payment;

    function payContract() public payable{
        // creates a new object of the payment received class
        payment = new PaymentReceived(msg.sender, msg.value);
    }
}

// a very simple contract used to store for a single payment event
contract PaymentReceived{

    address public from;
    uint public amount;

    // accepets the from address and the amount
    constructor(address _from, uint _amount){
        from = _from;
        amount = _amount;
    }
}

// uses a struct data structure whenever the payment is made
contract NewWallet{
    
    // struct definition
    struct PaymentReceivedStruct{
        address from;
        uint amount;
    }

    PaymentReceivedStruct public payment;

    // the payable contract 
    function payContract() public payable{
        // struct definition and instantiation
        payment = PaymentReceivedStruct(msg.sender, msg.value);
        payment.from = msg.sender;
        payment.amount = msg.value;
    }
} 