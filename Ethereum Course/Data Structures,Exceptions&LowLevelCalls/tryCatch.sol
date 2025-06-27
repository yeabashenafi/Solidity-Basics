// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// contract is designed to cause a transaction to revert or fail
contract WillThrow{
    // custom error definition
    // are more gas efficient and help to provide specific error messages
    error NotAllowedError(string);
    function aFunction() public pure {
        // require(false, "Error Message");
        // assert(false);
        revert NotAllowedError("You are not allowed!!");
    }
}

// demonstrates how to call another contract and gracefully handle different types of errors that might be thrown by that external call
contract ErrorHandling {
    // These are events which are ways to log information on the blockchain that can be effieciently listened by the off-chain applications
    // Each event is designed to log a different type of message in the try catch block
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);


    function catchTheError() public {
        // creates a new instance of the WillThrow contract
        WillThrow will = new WillThrow();
        try will.aFunction(){
            // try code that works in this case
        } //fired from require statement 
         catch Error(string memory reason){
            emit ErrorLogging(reason);
        } 
        // fired from assert statement
        catch Panic(uint errorCode){
            emit ErrorLogCode(errorCode);
        } 
        // to handle the custom error
        catch (bytes memory lowLevelData){
            emit ErrorLogBytes(lowLevelData);
        }
    }
}