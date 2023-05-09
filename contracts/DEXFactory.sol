/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

import "./DEXPair.sol";

contract DEXFactory {
    address[] public allPairs;
    mapping (address => mapping (address => address)) public getPair;

    event PairCreated(address tokenA, address tokenB, address pair, uint256 length);

    function createPair(address tokenA, address tokenB) external returns(address pair) {
        require(tokenA != tokenB, "Tokens are identical!");
        require(getPair[tokenA][tokenB] == address(0), "This pair already exist!");

        DEXPair tokenPair = new DEXPair();
        tokenPair.initialise(tokenA, tokenB);

        pair = address(tokenPair);
        getPair[tokenA][tokenB] = pair;
        getPair[tokenB][tokenA] = pair;

        allPairs.push(pair);
        emit PairCreated(tokenA, tokenB, pair, allPairs.length);
    }
} 