/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

import "./LPTokens.sol";
import "./interface/IDEXFactory.sol";
import "./interface/IDEXPair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEXRouter {
    address public pairFactory;

    LPTokens lpToken;

    constructor(address _pairFactory) {
        pairFactory = _pairFactory;
    }

    function liquidityProvide(address tokenA, address tokenB, uint256 amountA, uint256 amountB) external {
        if(IDEXFactory(pairFactory).getPair(tokenA, tokenB) == address(0)) {
            IDEXFactory(pairFactory).createPair(tokenA, tokenB);
        }

        (address pair) = IDEXFactory(pairFactory).getPair(tokenA, tokenB);

        IERC20(tokenA).transferFrom(msg.sender, pair, amountA);
        IERC20(tokenB).transferFrom(msg.sender, pair, amountB);

        IDEXPair(pair).mint(msg.sender, tokenA, tokenB, amountA, amountB);
    }

    function removeLiquidity(address tokenA, address tokenB, uint256 removeLPTokens) external {
        require(lpToken.balanceOf(msg.sender) >= removeLPTokens, "Don't have any liquidity!");
        (address pair) = IDEXFactory(pairFactory).getPair(tokenA, tokenB);

        IERC20(tokenA).transferFrom(pair, msg.sender, lpToken.underlyingTokensAmount(tokenA));
        IERC20(tokenB).transferFrom(pair, msg.sender, lpToken.underlyingTokensAmount(tokenB));

        IDEXPair(pair).burn(msg.sender, removeLPTokens); 
    }

    function swapTokens(address tokenA, address tokenB, uint256 amountA, uint256 amountB) external {
        (address pair) = IDEXFactory(pairFactory).getPair(tokenA, tokenB);
        require(pair != address(0), "You can't swap token!");

        uint256 tokenAAmount = IDEXPair(pair).tokenAmount(tokenA) - amountA;
        uint256 tokenBAmount = IDEXPair(pair).automateMarketMaker(tokenA, tokenB) / tokenAAmount;

        require(tokenBAmount == amountB, "You didn't send enough token for swaping");

        IDEXPair(pair).automate(tokenA, tokenB, tokenAAmount, tokenBAmount);

        IERC20(tokenA).transferFrom(pair, msg.sender, amountA);
        IERC20(tokenB).transferFrom(msg.sender, pair, amountB);
    }
}
