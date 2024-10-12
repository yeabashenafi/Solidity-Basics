// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SampleContractFallback{

    uint public lastValueSent; 
    string public lastFunctionCalled;

    // allows to transact with the contract if there is no data
    receive() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    // allows to transact with the contract when there is no data
    // also works with no data if receive is not defined
    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";
    }

    // four types of function visibility
    // public can be called internally and externally
    // private only for the contract , not externally reachable or not via desired contracts
    // external can be called from other contracts and externally
    //internal only from contracts and derived contracts
}