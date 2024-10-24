// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract WillThrow{
    // custom error definition
    error NotAllowedError(string);
    function aFunction() public pure {
        // require(false, "Error Message");
        // assert(false);

        revert NotAllowedError("You are not allowed!!");
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);

    function catchTheError() public {
        WillThrow will = new WillThrow();
        try will.aFunction(){
            // try code that works in this case
        } //fired from require statement 
         catch Error(string memory reason){
            emit ErrorLogging(reason);
        } 
        // fired from assert stat<
        catch Panic(uint errorCode){
            emit ErrorLogCode(errorCode);
        } 
        // to handle the custom error
        catch (bytes memory lowLevelData){
            emit ErrorLogBytes(lowLevelData);
        }
    }
}