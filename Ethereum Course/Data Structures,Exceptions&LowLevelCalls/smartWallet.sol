// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Consumer {

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // by deploying this contract
    // calling the deposit method and copying the input data we can use it to call the send money function 
    // in the smart wallet contract by using it as the payload parameter
    function deposit() external payable { }
}

contract SmartWallet{
    address payable public owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;

    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor (){
        owner = payable(msg.sender);
    }

    receive() external payable { 
        // balances[msg.sender] += msg.value;
    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner ,"you are not the owner, aborting");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender],"You are not a guardian of this wallet, aborting");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted , aborting");

        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= confirmationsFromGuardiansForReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllowance(address _for, uint _amount) public{
        require(msg.sender == owner, "you are not the owner aborting");
        allowance[_for] = _amount;

        if(_amount > 0 ){
            isAllowedToSend[_for] = true;
        }else{
            isAllowedToSend[_for] = false;
        }
    }



    function sendMoney(address payable _to, uint _amount, bytes memory _payload) public returns (bytes memory) {
        // require(msg.sender == owner, "Only owner can send money");
        if(msg.sender != owner){
            require(isAllowedToSend[msg.sender],"Aborting ! You are not allowed to send from this contract");
            require(allowance[msg.sender] >= _amount,"Aborting! You are trying to send more than you are allowed to");

            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value:_amount}(_payload);

        require(success,"Aborting! Function call unsuccessfull");
        
        return returnData;
    }
}