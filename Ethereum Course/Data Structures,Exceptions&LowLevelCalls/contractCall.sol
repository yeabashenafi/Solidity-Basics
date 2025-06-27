// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
// shows different ways where contracts can interact


// the recipient
// saves the transaction related data
contract ContractOne{

    mapping(address => uint) public addressBalance;

    function deposit() public payable {
        addressBalance[msg.sender] += msg.value;
    }

    receive() external payable { 
        deposit();
    }
}

// send and transfer methods usually use 2300 gas
// the interactor contract
contract ContractTwo{
    receive() external payable {}
    
    // function expected an address of a deployed contract one contract
    function depositOnContractOne(address payable _contractOne) public {
        // method one
        // this way the contract can be called with referencing the contract
        // recommended and type safe way
        // creates an instance of contract one 
        ContractOne one = ContractOne(_contractOne);
        one.deposit{value:10, gas:100000}();
        
        // method two
        // we can also call the function using specifc call data by using the following method
        // low level call which provide high flexibility but requires careful handling
        // used to interact with contracts whose interfaces arent fully known at compile time
        // abi.encodeWithSignature creates the bytecode neccessary to call the deposit function
        bytes memory payload = abi.encodeWithSignature("depoist()");
        
        // executes the above function to send ether to contract_one 
        // the maximum gas 
        // values returned are success and the returned value from the function call
        // if there is no function return value the second param can be empty 
        (bool success,) = _contractOne.call{value:10, gas: 100000}(payload);
        require(success, "The above contract call failed");

        // method three
        // calling no specific function 
        // we can just send the transactionn if the other contract has a receive function or fallback too if receive is not defined
        (bool completed, ) = _contractOne.call{value: 10, gas:100000}("");
        // reverts if the contract call is not successful
        require(completed);
    }
}