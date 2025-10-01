// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";



library PriceConverter {
    
    function getPrice() internal view returns (uint256)  {
        // get price of ethereum in USD

        //-address: 0x694AA1769357215DE4FAC081bf1f309aDC325306(from chainlink data feeds address)
        //-ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // price of 1 ETH in terms of USD

        return uint256(price * 1e10);

    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        // price of given eth in USD
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethAmount * ethPrice)/1e18;
        return ethAmountInUSD;
    }


}
