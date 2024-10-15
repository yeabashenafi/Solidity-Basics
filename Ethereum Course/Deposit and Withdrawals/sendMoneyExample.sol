// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SendWithdrawMoney{

    uint balanceReceived;

    function deposit() public payable{
        balanceReceived += msg.value;
    }
    
    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function withdrawAll() public{
        address payable transferTo = payable (msg.sender);
        transferTo.transfer(getBalance());
    }

    function withdraw(address payable transferTo) public {
        transferTo.transfer(getBalance());
    }
}