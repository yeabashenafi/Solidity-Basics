// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

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
contract ContractTwo{
    receive() external payable {}

    function depositOnContractOne(address _contractOne) public {
        // this way the contract can be called with referencing the contract 
        // ContractOne one = ContractOne(_contractOne);
        // one.deposit{value:10, gas:100000}(); 
        // we can also call the function using specifc call data by using the following method
        bytes memory payload = abi.encodeWithSignature("depoist()");
        // values returned are success and the returned value from the function call
        // if there is no function call the secind param can be empty 
        // (bool success,)=_contractOne.call{value:10, gas: 1000000}(payload);
        // we can just send the transactionn if the other contract has a receive function
        (bool success, ) = _contractOne.call{value: 10, gas:3000000}("");
        require(success);
    }
}