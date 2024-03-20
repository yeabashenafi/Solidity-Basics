// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// imports the yeabETH contract
// imports the console file
import "Tokens/yeabETH.sol";
import "hardhat/console.sol";

// creates a simple wallet contract
// is a wallet of the YeabETH token
// defines the owner, the token contract and prefferedSendingAddress
contract SimpleWalletContract {
    address public owner;
    YeabETH public TokenContract;
    address[] public preferredSendingAddresses;

    // Defines events to deposit and withdraw
    event Deposit(address indexed sender, uint256 value);
    event Withdraw(address indexed to, uint256 value);

    // constructor receives the liquidity address
    // sets the owner to the contract deployer
    constructor( address liquidityAddress){
        owner=msg.sender;
        TokenContract=new YeabETH(owner,liquidityAddress);
    }

     // restricts function access to the contract owner
     // when this modifier is used the function can only be accessed by the owner
     modifier onlyOwner(){
        require(msg.sender==owner,"Only allowed for owners");
        _;
    }

    // deposit function that is accessible by anyone
    // accepts an amount that can be sent to the contract
    function deposit(uint256 _amount) public payable {
        require(_amount<owner.balance,"Not enough balance");
        // emits the deposit event
        emit Deposit(msg.sender, msg.value);
    }

    // withdraw function that is only accessible to the owner
    // withdrwas a token to an address specified
    function withdraw(uint256 _amount,address withdrwalAddress) public onlyOwner {
        // require(_amount<TokenContract.balanceOf(owner),"Not enough balance");
        // approves the transaction sends the owner address and an amount
        TokenContract.approve(address(this), _amount);
        // logs the balanace
        // approve, transfer and balnaceOf are functions of the erc20 standard
        console.log(TokenContract.balanceOf(owner));
        TokenContract.transfer(withdrwalAddress,_amount);
        
        // emits the withdraw event
        emit Withdraw(msg.sender, _amount);
        // return TokenContract.balanceOf(owner);
    }

    // function checkAssembly()
    //     external
    //     payable
    // {
    //     assembly {
    //         let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
    //         calldatacopy(0, 0, calldatasize())
    //         let success := delegatecall(not(0), masterCopy, 0, calldatasize(), 0, 0)
    //         returndatacopy(0, 0, returndatasize())
    //         switch success
    //         case 0 { revert(0, returndatasize()) }
    //         default { return(0, returndatasize()) }
    //     }
    // }

    function BalanceOf(address addressBalance)public view returns (uint){
        return TokenContract.balanceOf(addressBalance);
    }
}


// interface ISimpleWallet{
//     function Deposited(address) external returns(bool);
// }

// contract Caller {
//     function callSetValue(address _callee, uint _value) public {
//         // Callee contract is being called here
//         (bool success, ) = _callee.call(abi.encodeWithSignature("setValue(uint256)", _value));
//         require(success, "Call failed");
// 