// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
  // creates an interface to interact with ERC20 tokens
  interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

// Creates a MultiSigWallet contract that allows multiple owners with multi signature to collaboratively manage funds.
contract SimpleMultisigWallet {
    // List of owners and the number of approvals required
    address[] public owners;
    uint public requiredApprovals;

    // Struct for a transaction request
    struct Transaction {
        address to;// address the transaction is sent too
        uint value;// amount sent in the transaction
        bool executed;// boolean that stores if the transaction has been completed or not
        uint approvalCount;// counts the no of approvals by the owners
        address tokenAddress;// address of the token for the transaction
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
    constructor(address[] memory _owners, uint _requiredApprovals) {
        // checks the logical validity of the parameters passed
        require(_owners.length > 0, "Owners required");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "Invalid number of required approvals");

        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    // Function to submit a new transaction request
    function submitTransaction(address _to, uint _value) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            executed: false,
            approvalCount: 0,
            tokenAddress: address(0)
            
        }));
    }

    // function submitTransactionWithTokenAddress(){
        
    // }

    

    // Function for an owner to approve a pending transaction
    // transaction must not be executed and that is checked by the modifier
    function approveTransaction(uint _txIndex) public onlyOwner notExecuted(_txIndex) {
        // verifies that an owner does not verify twice
        require(!approvals[_txIndex][msg.sender], "Transaction already approved by user");
        

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
            require(success, "Transaction failed");
        } else {
            // ERC20 token transfer
            IERC20 token = IERC20(transaction.tokenAddress);
            bool success = token.transfer(transaction.to, transaction.value);
            require(success, "Token transfer failed");
        }
    } 


    // Function to deposit funds into the wallet
    // allows deposits of ether directly to the wallet contract
    receive() external payable {}

    // Function to get the balance of the wallet
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}