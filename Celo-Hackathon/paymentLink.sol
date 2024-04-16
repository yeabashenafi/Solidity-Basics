// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// imports the hardhat console file
import "hardhat/console.sol";

contract PaymentLinkContract{
    
    // struct for payment links
    struct PaymentLink{
        uint256 id; // unique identifier for the payment link
        address creator;// address of the creator of the payment link
        address recipient;// address of the recipient of the payments to be made
        uint amount; // amount to be paid using this link . this property is optional
        string message; // message for the payment link
    }

    // struct for payments
    struct Payment{
        uint256 link_id; // stores the payment link id
        address payer;// stores the address of the payer's address
        uint amount; // stores the amount paid
        uint timestamp;// stores the timestamp of the payment in non human readable format
    }

    // array of all payment links
    PaymentLink[] public links;

    mapping(uint256 => PaymentLink) public paymentLinks;

    constructor(){}

    // function to create payment links
    function createPaymentLink(address _creator, address _recipient, uint _amount, string memory _message) public{
        
        // checks the logical validity of the values input
        require(_amount > 0, "Amount must be greater than 0");

        // To Do
        // Generate a new random id by using VRFs

        // keccak256 hashes the provided data
        // abi.encodePacked combines the given parameters into a byte array for hashing
        // the blockhash method gets the block hash of the previous block to avoid manipulation based on the current block
        uint256 id = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), _recipient, _amount, _message)));
        
        // create a new Payment Link struct object
        PaymentLink memory newLink = PaymentLink(id,_creator,_recipient,_amount,_message);

        // store the newly created payment link on the mapping
        paymentLinks[id] = newLink;

        console.log(id);
    }

    // function to get the payment link
    function getPaymentLink(uint256 _id) public view returns(PaymentLink memory) {

        // checks that the link with the id exists
        require(paymentLinks[_id].id != 0, "Link does not exist");
        PaymentLink memory link = paymentLinks[_id];
        return link;
    }

    // To Do 
    // Pay function that can be connected to celo mini pay
    function pay() public {

    }

    // To Do
    // use this function to generate a random and unique id using a vrf provider
    // function to generate a unique id for the links
    function generateUniqueId() pure public returns (uint256){

        uint256 unique_id = 123456;
        return unique_id;
    }

    
}