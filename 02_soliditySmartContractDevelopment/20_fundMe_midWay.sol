// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import Chainlink's AggregatorV3Interface so we can call the on-chain price feed.
// This interface exposes `latestRoundData()` which returns the latest price observation
// (among other metadata).
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    // -------------------------
    // State variables
    // -------------------------

    // `minimumUsd` is expressed using 18 decimals (like wei for ETH).
    // Storing USD values with 18 decimals makes it easy to work with ETH amounts
    // (which are also in 18-decimal units, i.e. wei). This keeps unit arithmetic
    // consistent across the contract.
    //
    // 5e18 means 5 * 10^18. Interpreted as USD with 18 decimals, that represents $5.00
    // (i.e. 5 * 10^18 / 10^18 = 5 USD in human-readable form).
    uint256 public minimumUsd = 5e18; // 5 USD (scaled to 18 decimals)

    // Simple list of funders (addresses that called `fund`).
    address[] public funders;

    // Mapping from funder address -> amount funded (in wei).
    // The mapping key and value names `funder` and `amountFunded` are just inline
    // documentation — underlying type is mapping(address => uint256).
    // `amountFunded` is stored in wei (the smallest ETH unit, 1 ETH = 10^18 wei).
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;


    // -------------------------
    // Public functions
    // -------------------------

    // Anyone can send ETH to this contract through `fund()`.
    // `msg.value` is provided in wei (1 ETH == 10^18 wei).
    function fund() public payable {
        // `getConversionRate(msg.value)` returns a USD value scaled to 18 decimals.
        // `minimumUsd` is also scaled to 18 decimals. Because both sides of the
        // comparison use *the same units* (USD with 18 decimals), the comparison is
        // correct.
        //
        // Example: if msg.value is 0.003 ETH (3e15 wei) and current ETH price is
        // $2,000 => getConversionRate(3e15) returns (2000 * 1e18) * 3e15 / 1e18 =
        // 6000e15 (i.e. $6 scaled to 18 decimals). That would be > minimumUsd (if min is $5).
        require(getConversionRate(msg.value) > minimumUsd, "didn't send enough ETH");

        // Track funders and the amount they sent (in wei)
        funders.push(msg.sender);
        // Solidity 0.8 automatically checks for overflows. We store wei here.
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    // -------------------------
    // Chainlink price feed helpers
    // -------------------------

    // Reads the ETH/USD price from the Chainlink data feed and returns it scaled
    // to 18 decimals (so it is compatible with wei-based ETH amounts).
    function getPrice() public view returns (uint256) {
        // Address of the Chainlink ETH/USD aggregator on the given network.
        // NOTE: This address is network-specific (Sepolia in prior examples).
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // latestRoundData returns multiple values; we only need `answer` which is the price.
        // The `answer` is an `int256` because the underlying Chainlink interface uses a signed type.
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // IMPORTANT: `price` **does not** use 18 decimals by default.
        // Many Chainlink ETH/USD feeds return price with 8 decimals (common case).
        // For example:
        //   If ETH = $1,600.12345678 -> `price` = 160012345678 (an integer with 8 implicit decimals)
        //
        // Our contract prefers working with 18-decimal values (same base as wei) so
        // math between ETH amounts and USD values is straightforward. To convert the
        // feed's 8-decimal number to 18-decimal format we multiply by 10^(18-8) = 10^10.
        // That is why we do `price * 1e10` below.
        //
        // Example numeric flow:
        //  - Chainlink `price` (8 decimals):           160012345678
        //  - After scaling to 18 decimals (x 1e10):   1600123456780000000000
        //  - Interpreting scaled value:               1600.12345678 * 10^18

        // SAFETY NOTE: `price` is int256; if you want to be extra cautious you
        // should check that price > 0 before converting to uint256.
        // e.g. require(price > 0, "Negative or zero price from oracle");

        // Multiply by 1e10 to convert 8-decimal feed -> 18-decimal representation.
        // The result is returned as uint256 (non-negative, 18-decimal USD per ETH).
        return uint256(price * 1e10);

        /*
         * A slightly more robust approach (supports any feed decimals):
         * uint8 feedDecimals = priceFeed.decimals();
         * // compute scalingFactor = 10^(18 - feedDecimals)
         * uint256 scalingFactor = 10 ** (uint256(18) - uint256(feedDecimals));
         * return uint256(price) * scalingFactor;
         */
    }


    // Convert a given ETH amount (in wei) to its USD value, with USD scaled to 18 decimals.
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        // ethPrice is the USD value of 1 ETH, scaled to 18 decimals (from getPrice()).
        // Example ethPrice for $1,600.12345678 would be: 1600123456780000000000
        uint256 ethPrice = getPrice();

        // ethAmount is in wei (1 ETH = 1e18 wei). Both ethAmount and ethPrice are
        // 18-decimal-based numbers.
        //
        // When we multiply ethAmount * ethPrice, the product temporarily has 36 decimals
        // of scaling (18 + 18). To return a USD value that is back to 18 decimals,
        // we divide the product by 1e18.
        //
        // Example numeric flow for 1 ETH:
        // - ethAmount = 1e18 (wei)
        // - ethPrice = 1600123456780000000000 (USD scaled to 18 decimals)
        // - product = ethAmount * ethPrice = 1600123456780000000000 * 1e18 (has 36 decimal scaling)
        // - divide by 1e18 => 1600123456780000000000 (USD scaled to 18 decimals)
        // This yields the USD-equivalent of the supplied ethAmount.
        uint256 ethAmountInUSD = (ethAmount * ethPrice) / 1e18;

        return ethAmountInUSD; // USD value with 18 decimals
    }

    // -------------------------
    // Notes & suggestions
    // -------------------------
    // 1) Always be explicit about units in comments: specify if a variable is
    //    in wei, gwei, ether, or USD (and what decimal scaling you are using).
    // 2) Consider checking `price > 0` after reading oracle to avoid edge cases.
    // 3) To support multiple networks or avoid hard-coding, store the price feed
    //    address in the contract constructor or set function instead of a literal.
    // 4) Using `priceFeed.decimals()` makes the conversion generic and resilient
    //    if a different feed with different decimals is used in the future.
}
