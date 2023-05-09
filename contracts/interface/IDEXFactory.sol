/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

interface IDEXFactory {
    function getPair(address tokenA, address tokenB) external returns(address pair);
    function createPair(address tokenA, address tokenB) external returns(address pair);
}