// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract TokenClaim is Ownable{
    
    IERC20 private _tokenInstance;
    uint256 private _amountClaim;
    uint private _decimals = 18;
    
    constructor(address contractAddress_){
        _tokenInstance = IERC20(contractAddress_);
        _amountClaim = 10 * 10**_decimals;
    }
    
    function setAmountClaim(uint256 amount) external onlyOwner {
        _amountClaim = amount * 10**_decimals;
    }
    
    modifier amountZero(){
        require(_tokenInstance.balanceOf(_msgSender()) == 0, "This balance is more then 0");
        _;
    }
    
    function claim() public amountZero returns (bool) {
        return _tokenInstance.transfer(_msgSender(), _amountClaim);
    }
    
    function clearTokenClaim() external onlyOwner returns (bool){
        return _tokenInstance.transfer(owner(), _tokenInstance.balanceOf(address(this)));
    }
}

interface IERC20 {

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
}


