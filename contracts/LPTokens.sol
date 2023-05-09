/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LPTokens is ERC20 {

    address public underlyingTokenA;
    address public underlyingTokenB;

    mapping (address => uint256) public underlyingTokensAmount;

    constructor(address tokenA, address tokenB, uint256 amountA, uint256 amountB) ERC20("LPToken", "LP") {
        underlyingTokenA = tokenA;
        underlyingTokenB = tokenB;

        underlyingTokensAmount[underlyingTokenA] = amountA;
        underlyingTokensAmount[underlyingTokenB] = amountB;
    }

    function LPTokenMint(address account, uint256 lpAmount) external {
        _mint(account, lpAmount);
    }

    function LPTokenBurn(address account, uint256 lpAmount) external {
        _burn(account, lpAmount);
    }
}