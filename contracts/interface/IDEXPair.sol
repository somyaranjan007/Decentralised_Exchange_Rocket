/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.7;

interface IDEXPair {
    function pairFactory() external view returns(address);
    function tokenA() external view returns(address);
    function tokenB() external view returns(address);
    function automateMarketMaker(address _tokenA, address _tokenB) external view returns (uint256);
    function tokenAmount(address _token) external view returns(uint256);
    function initialise(address _tokenA, address _tokenB) external;
    function mint(address _account, address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB) external;
    function burn(address _account, uint256 removeLpToken) external;
    function automate(address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB) external;
}