// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// A code showing multi signature or guardian wallet


// A utility contract 
contract Consumer { 

    // returns the balance of the contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // by deploying this contract
    // calling the deposit method and copying the input data we can use it to call the send money function 
    // in the smart wallet contract by using it as the payload parameter
    function deposit() external payable { }
}

// This contract acts as a more sophisticated wallet that allows single owner control, delegated spending via allowances
// and a multi signature-like mechanism for changing the wallet owner using guardians
contract SmartWallet{
    // defines the owner of the wallet
    // made payable because owner can be made to receive ether
    address payable public owner;

    // defines the maximum amount in wei an address is allowed to send from this wallet
    mapping(address => uint) public allowance;
    // maps an address to a boolean indicating that they are currently authorized to use send money by not having a not zero allowance
    mapping(address => bool) public isAllowedToSend;
    // maps an address to a boolean indicating an address is a guardian or not
    mapping(address => bool) public guardians;
    // stores the address of the proposed new owner during the owner change process
    address payable nextOwner;
    // nested mapping to track which guardian has voted for which proposed nextOwner
    // nextOwnerGuardianVotedBool[_newOwner][msg.sender] would store true if msg.sender has voted for _newOwner
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;

    // counts the number of guardians who have voted for the current nextOwner proposal
    uint guardiansResetCount;
    // A constant defining how many guardian confirmations are needed to change the owner
    uint public constant confirmationsFromGuardiansForReset = 3;

    // when contract is first deployed the address that deploys it becomes the owner
    constructor (){
        owner = payable(msg.sender);
    }

    // receives ether to the contract with no actions
    receive() external payable { 
        // balances[msg.sender] += msg.value;
    }

    // allows assigning or unassigning of guardians
    function setGuardian(address _guardian, bool _isGuardian) public {
       // ensures that only the owner can make this operation
        require(msg.sender == owner ,"you are not the owner, aborting");
        guardians[_guardian] = _isGuardian;
    }

    // allows for the proposal of a new owner   
    function proposeNewOwner(address payable _newOwner) public {
        // makes sure only a guardian can propose for a vote of a new owner
        require(guardians[msg.sender],"You are not a guardian of this wallet, aborting");
        // makes sure the guardian does not vote multiple times for the proposed new owner
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted , aborting");

        // if the proposed owner is different from the one currently being voted on it resets the process for the new proposal
        // next owner is updated and guardiansResetCount is set to 0
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        // Mark guardian's vote for this proposal
        nextOwnerGuardianVotedBool[_newOwner][msg.sender] = true;

        // increments the count of confirmations for the current nextOwner proposal
        guardiansResetCount++;
        
        // if enough voters have voted for the nextOwner proposal the owner change happens
        if(guardiansResetCount >= confirmationsFromGuardiansForReset){
            // changes the owner address
            owner = nextOwner;
            // the next owner address is cleared by setting it to the zero address
            nextOwner = payable(address(0));
        }
    }

    // function to set the allowance
    function setAllowance(address _for, uint _amount) public{
        // make sure the sender is the owner
        require(msg.sender == owner, "you are not the owner aborting");
        // sets the maximmum amount of ether that the _for address is permitted to spend using sendMoney
        allowance[_for] = _amount;
        
        // automatically manages the isAllowedToSend flag based on the amount
        if(_amount > 0 ){
            isAllowedToSend[_for] = true;
        }else{
            isAllowedToSend[_for] = false;
        }
    }

    // core function for sending ether
    function sendMoney(address payable _to, uint _amount, bytes memory _payload) public returns (bytes memory) {
        // require(msg.sender == owner, "Only owner can send money");
        // If sender is not the owner allowance is checked 
        if(msg.sender != owner){
            // checks if the sender is allowed to send
            require(isAllowedToSend[msg.sender],"Aborting ! You are not allowed to send from this contract");
            // checks if the amount is below the allowed amount for the sender
            require(allowance[msg.sender] >= _amount,"Aborting! You are trying to send more than you are allowed to");

            // the allowance for the sender is decreased
            allowance[msg.sender] -= _amount;
        }

        // low level call
        // the _to address's is called
        // amount is passed
        // _payload expects a raw bytecode that the target contract will try to interpret as a function call
        // if empty value is passed to the _payload parameter will call receive or feedback
        (bool success, bytes memory returnData) = _to.call{value:_amount}(_payload);

        require(success,"Aborting! Function call unsuccessfull");
        
        return returnData;
    }
}