// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SampleContractFallback{
    // since the variables are public getters will be automatically generated for them
    uint public lastValueSent; 
    string public lastFunctionCalled;

    // this is a special function
    // primary function called when the contract receives plain ether without any data
    // called when someone sends ether to the contract address without specifiying a function call i.e with an empty 'data' payload
    // also called if the gas limit for the transaction is less than 2300 gas
    // payable keyword allows the function to receive ether
    receive() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    // this is a special function
    // called when ether is sent to the contract address without any data but no receive function is defined
    // also called when the contract receives ether and the transaction includes 'data' that is not defined in the contract
    // usually used to handle non-existing functions 
    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";
    }

    // four types of function visibility
    // public can be called internally and externally
    // private only for the contract , not externally reachable or not via desired contracts
    // external can only be called from other contracts and externally
    // internal only from contracts and derived contracts
}