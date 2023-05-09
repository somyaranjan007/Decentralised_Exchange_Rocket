/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

import "./LPTokens.sol";

contract DEXPair {
    address public pairFactory;
    address public tokenA;
    address public tokenB;

    mapping (address => mapping (address => uint256)) public automateMarketMaker;
    mapping (address => uint256) public tokenAmount;
    
    LPTokens internal lpToken;

    constructor() {
        pairFactory = msg.sender;
    }

    function initialise(address _tokenA, address _tokenB) external {
        require(pairFactory == msg.sender, "Factory Forbidden!");
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function mint(address _account, address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB) external {
        automate(_tokenA, _tokenB, _amountA, _amountB);
        lpToken = new LPTokens(_tokenA, _tokenB, _amountA, _amountB);
        lpToken.LPTokenMint(_account, _amountA + _amountB);
    }

    function burn(address _account, uint256 removeLpToken) external {
        lpToken.LPTokenBurn(_account, removeLpToken);
    }

    function automate(address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB) public {
        tokenAmount[_tokenA] = _amountA;
        tokenAmount[_tokenB] = _amountB;

        automateMarketMaker[_tokenA][_tokenB] = _amountA * _amountB;
        automateMarketMaker[_tokenB][_tokenA] = _amountA * _amountB;
    }
}