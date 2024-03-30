// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// imports the hardhat console 
import "hardhat/console.sol";

// creates an interface to interact with ERC20 tokens
// defines a set of functions an erc20 token should implement
// allows the struct to hold an erc29 token address, allows the submission of transaction with a token address
// acts as a bridge between the erc 20 token and the contract
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 value) external  returns (bool);
    function totalSupply() external view returns (uint256);
}

// Creates a MultiSigWallet contract that allows multiple owners with multi signature to collaboratively manage funds.
contract EnhancedMultisigWallet {
    // List of owners and the number of approvals required
    address[] public owners;
    uint public requiredApprovals;

    //add** Make an event for proposals submitted along with their required info

    // Struct for a transaction request
    struct Transaction {
        address to;// address the transaction is sent too
        uint value;// amount sent in the transaction
        address tokenAddress; // address of the token for the transaction
        bool executed;// boolean that stores if the transaction has been completed or not
        uint approvalCount;// counts the no of approvals by the owners
    }

    // Array of all submitted transactions
    Transaction[] public transactions;

    // Mapping from transaction ID => owner => bool
    // tracks which owners have approved each transaction
    mapping(uint => mapping(address => bool)) public approvals;

    // Modifier to check if the caller is an owner
    modifier onlyOwner() {
        bool isOwner = false;
        // checks if the user is in the list of owners 
        for (uint i = 0; i < owners.length; i++) {
            if (msg.sender == owners[i]) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not an owner");
        _;
    }

    // Modifier to check if the transaction has not been executed before interacting with it
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    // Constructor to set up owners and the number of required approvals
    // in the definition payable allows the contract to receive eth during deployment if any
    constructor(address[] memory _owners, uint _requiredApprovals) payable {
        // checks the logical validity of the parameters passed
        require(_owners.length > 0, "Owners required");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "Invalid number of required approvals");
        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    // Function to submit a new transaction request for eth
    function submitTransaction(address _to, uint _value) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            tokenAddress: address(0),
            executed: false,
            approvalCount: 0
        }));
    }

    // Function to submit a new transaction request with a specific token address(for erc20 tokens)
    function submitTransactionWithTokenAdress(address _to, uint _value, address _tokenAddress) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            executed: false,
            approvalCount: 0,
            tokenAddress: _tokenAddress
            
        }));
    }

    // Function for an owner to approve a pending transaction
    // transaction must not be executed and that is checked by the modifier
    function approveTransaction(uint _txIndex) public onlyOwner notExecuted(_txIndex) {
        // Transaction storage transaction = transactions[_txIndex];
        // IERC20 token=IERC20(transaction.tokenAddress);

        // verifies that an owner does not verify twice
        require(!approvals[_txIndex][msg.sender], "Transaction already approved");

        approvals[_txIndex][msg.sender] = true;
        transactions[_txIndex].approvalCount++;

        // executes the transaction if the required approvals are met
        if (transactions[_txIndex].approvalCount >= requiredApprovals) {
            executeTransaction(_txIndex);
        }
    }

    // Function to execute a transaction after the required number of approvals has been met
    // receives the transaction index
    function executeTransaction(uint _txIndex) private notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        // checks the maximum no of approvals is met
        require(transaction.approvalCount >= requiredApprovals, "Insufficient approvals");

        transaction.executed = true;

        // transfers the amount by checking the type of token
        if (transaction.tokenAddress == address(0)) {
            // Ether transfer
            (bool success,) = transaction.to.call{value: transaction.value}("");
            console.log(success);
            require(success, "Transaction failed");
            // assert(success!=false);
        } else {
            // uses the interface deined above for use with erc20 tokens
            IERC20 token = IERC20(transaction.tokenAddress);
            bool success = token.transfer(transaction.to, transaction.value);
            require(success, "Token transfer failed");
            
        }
    }

    // Allows owners to change the required number of approvals
    function setRequiredApprovals(uint approvalCount) public onlyOwner {
        requiredApprovals=approvalCount;
    } 

    receive() external payable {}

    // returns the balance
    function getBalance() public view returns (uint) {
        require(address(this).balance>0,"not enough balance");
        return address(this).balance;
    }

    // New function to get the balance of ERC20 tokens
    // function getTokenBalance(address _tokenAddress) public view returns (uint) {
    //     IERC20 token = IERC20(_tokenAddress);
    //     return token.balanceOf(address(this));
    // }

    //add** require statements for unavailable data.

    // returns the balance of the token with the address
    function getTokenBalance(address _tokenAddress) public view returns (uint) {
         IERC20 token = IERC20(_tokenAddress);
        // require(token.balanceOf(address(this))>0,"not enough token balance");
        return token.balanceOf(address(this));
    }
}