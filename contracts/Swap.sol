// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/AggregatorV3Interface.sol";
import "./interfaces/ICustomERC20.sol";

contract TokenSwap {
    ICustomERC20 public tokenA;
    ICustomERC20 public tokenB;
    AggregatorV3Interface internal priceFeedA; // Chainlink price feed interface for token A
    AggregatorV3Interface internal priceFeedB; // Chainlink price feed interface for token B

    uint8 public tokenADecimals;
    uint8 public tokenBDecimals;

    uint256 public swapPercent; // Percentage of extra B tokens to give away

    event Swap(address indexed user, uint256 amountA, uint256 amountB);

    constructor(
        address _tokenA,
        address _tokenB,
        address _priceFeedA,
        address _priceFeedB,
        uint256 _swapPercent
    ) {
        tokenA = ICustomERC20(_tokenA);
        tokenB = ICustomERC20(_tokenB);
        priceFeedA = AggregatorV3Interface(_priceFeedA);
        priceFeedB = AggregatorV3Interface(_priceFeedB);
        swapPercent = _swapPercent;

        tokenADecimals = priceFeedA.decimals();
        tokenBDecimals = priceFeedB.decimals();
    }

    // Function to swap tokenA for tokenB
    function swap(uint256 amountA) external {
        require(amountA > 0, "Amount must be greater than zero");

        // Get the current price of tokenA and tokenB from Chainlink
        (uint256 priceA, ) = _getLatestPrice(priceFeedA);
        (uint256 priceB, ) = _getLatestPrice(priceFeedB);

        // Calculate the amount of tokenB to mint
        uint256 amountB = (amountA * priceA * (100 + swapPercent)) / (priceB * 100);

        // Transfer tokenA from the user to this contract
        tokenA.transferFrom(msg.sender, address(this), amountA);

        // Burn tokenA from this contract
        tokenA.burn(amountA);

        // Mint tokenB to the user
        tokenB.mint(msg.sender, amountB);

        // Emit the swap event
        emit Swap(msg.sender, amountA, amountB);
    }

    // Function to get the latest price of token from Chainlink
    function _getLatestPrice(AggregatorV3Interface _priceFeed) internal view returns (uint256, uint256) {
        (, int256 price, , , ) = _priceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        uint8 decimals = _priceFeed.decimals();
        return (uint256(price), uint256(decimals));
    }
}
