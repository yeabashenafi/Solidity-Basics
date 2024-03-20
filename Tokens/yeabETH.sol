// SPDX-License-Identifier: MIT
pragma solidity 0.8.0-0.9.0;
// imports the erc-20 token standard
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// imports consoling property
import "hardhat/console.sol";

// token contract contract inherits the erc20 contract
contract YeabETH is ERC20{
    address public liquidityFeeWallet;

    // constructor defines receives the liquidity fees wallet address
    // also defines the token name and short name
    constructor( address liquidityFeesWallet1) ERC20("YEABETH","YEABETH"){
        // mints or gives ownership to the contract owner 
        // 1000 tokens considering 10**18
        _mint(_msgSender(), 1000 * 10**18);
        // assigns the liquidity fee wallet to the state address variable
        liquidityFeeWallet=liquidityFeesWallet1;
    }

    // defines a transfer variable that overrides the default transfer function form erc20
    // recieves the value and receiver wallet address as parameters
    function transfer(address to, uint256 value) public override returns (bool) {
       
       // assigns the owner of the contract
        address owner = _msgSender();
        // makes sure the owner has sufficient balance
        require(value<super.balanceOf(owner),"Not enough balance");
        // calculates the fee based on the amount
        uint256 theFeeValue=value - value * 90/100;
        uint256 theTransactionAmount=value-theFeeValue;
        require(theFeeValue>0,"The fees are 0");
        // logs the transaction amount and the fee value
        console.log(theTransactionAmount);
        console.log(theFeeValue);
        // calls the transfer method of the erc20 
        super._transfer(owner, to, theTransactionAmount);
        super._transfer(owner, liquidityFeeWallet, theFeeValue);
        return true;
    }

    // calss the super.transfer method without applying any fees
    function transferNormal(address to, uint256 value) public {
        (bool success)=super.transfer(to, value);
        require(success,"funds transfered");

    }

}