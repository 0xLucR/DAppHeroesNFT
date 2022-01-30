// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    string public _name = "Heroes of Peace";
    string public _symbol = "HPT";

    constructor() ERC20(_name, _symbol) {
        // Mint 100,000 tokens to msg.sender
        // 1 token = 1 * 10 ** decimals
        _mint(_msgSender(), 100000 * 10**uint(decimals()));
    }
}