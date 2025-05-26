// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleAddress {

    // stores a 20 byte ethereum address
    // when public is used automattically creates a getter function
    // can be read by anyone
    // ExampleAddress.someAddress() can be used by an external contract to return its value
    address public someAddress;

    // _ distinguishes the function parameters from state variables
    function setSomeAddress(address _someAddress) public{
        // someAddress is a state variable, which when changed changes the state of the contract
        someAddress = _someAddress;
    }

    // view is a state mutability specifier
    // function promises not to modify the state of the blockchain only to read from it
    // doesn't cost gas if called externally , but can cost gas if called internally by another contract that does modify state
    // uint is returned in this function
    function getAddressBalance() public view returns(uint){
        // returns the balance of the given address in wei(smallest unit of Ether, where 1 Ether = 10^18 wei
        return  someAddress.balance;
    }
}