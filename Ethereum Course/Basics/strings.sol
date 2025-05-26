// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract ExampleString{
    
    string public myString = "Hello World";
    
    // dynamically sized byte arrays 
    // converts the value to a raw byte interpretation
    bytes public myByte = "Hello World";

    function setMyString(string memory _myString) public{
        myString = _myString;
    }

    // function takes a string param stored in memory
    function compareTwoStrings(string memory _myString) public view returns(bool){
        // we cant just compare solidity strings or bytes just with == because that only compares the storage locations and references
        // abi-application binary interface
        // abi.encodePacked() -> . This function encodes the string into a compact sequence of bytes, encodePacked is effiecent for hashing as it doesnot add padding or type info
        // keccak256(value) - hash function which is built in and takes bytes and returns byte32 hash
        // keccak256() == keccak256() - compares the hashes thus compares the content
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }
}