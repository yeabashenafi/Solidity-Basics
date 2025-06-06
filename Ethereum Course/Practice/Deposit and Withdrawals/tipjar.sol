//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract SimpleTipJar{
    address public owner;
    uint public totalBalance;
    uint public lastValueSent;
    uint public minTipAmount;
    string public tipType;
    string public lastFunctionCalled;

    constructor() payable{
        owner = msg.sender;
        totalBalance = 0;
        minTipAmount = 1 ether;
    }

    receive() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = 'receive';
        tipType = 'Anonymous tip';    
        totalBalance += lastValueSent;
    }

    fallback() external payable {
        lastFunctionCalled = 'fallback';
        payable (msg.sender).transfer(msg.value);

    }

    function tip(string memory _message) external payable {
        if (msg.value < minTipAmount) {
            payable (msg.sender).transfer(msg.value);
        }
        else{
            lastValueSent = msg.value;
            totalBalance += lastValueSent;
            lastFunctionCalled = 'tip';
            tipType = _message;
        }        
    }

    function withdraw() public {
        // require could be better suited here 
        if (owner == msg.sender){
            // gets the balance of the current contract
            uint _amountToWithdraw = address(this).balance;

            payable (owner).transfer(_amountToWithdraw);

            totalBalance = 0;
        }
        else{
            revert("Only owner of the contract can withdraw");
        }
    }
}