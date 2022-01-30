// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract HeroNFTGenerate is Ownable{
    
    IERC20 private _tokenInstance;
    INFT private _nftInstace;
    uint256 private _amountGenerate;
    uint private _decimals = 18;
    
    constructor(address contractAddressToken_, address contractAddressNFT_){
        _tokenInstance = IERC20(contractAddressToken_);
        _nftInstace = INFT(contractAddressNFT_);
        _amountGenerate = 10 * 10**_decimals;
    }
    
    function setAmountGenerate(uint256 amount) external onlyOwner {
        _amountGenerate = amount * 10**_decimals;
    }
    
    modifier amountAllowance(){
        require(_tokenInstance.allowance(_msgSender(), address(this)) >= _amountGenerate, "Funds not allowed");
        _;
    }

    // ALERT: msg.sender need to approve address(this) before to transfer the tokens(amountGenerate)
    function createNFT() public amountAllowance returns(bool){      
        if(_tokenInstance.transferFrom(_msgSender(), address(this), _amountGenerate))
            _nftInstace.createHero(_msgSender());
        return true;
    }

    function clearTokenAirDrop() public onlyOwner returns (bool){
        return _tokenInstance.transfer(owner(), _tokenInstance.balanceOf(address(this)));
    }
}

interface IERC20 {

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);
}

interface INFT{

    function createHero(address _to) external;    
}