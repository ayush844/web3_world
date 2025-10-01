
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { PriceConverter } from "./PriceCoverter.sol";


error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18; // 5usd

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor () {
        i_owner = msg.sender;
    }

    function fund() public payable   {
        require(msg.value.getConversionRate() > MINIMUM_USD, "didn't send enough ETH");  // 1e18 = 1ETH = 1 * 10 ** 18 wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {

        // require(msg.sender == i_owner, "you must be owner to withdraw funds");

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++)  // for (initialization; condition; increment) 
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset the array
        funders = new address[](0);

        // withdraw the funds:
        // 3 ways: transfer | send | call

        // 1
        // payable (msg.sender).transfer(address(this).balance);
        // msg.sender --type--> address
        // payable (msg.sender) --type--> payable address

        // 2
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess, "SEND failed");

        // 3
        (bool callSucces,) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSucces, "CALL failed");

    }


    modifier onlyOwner(){
        // require(msg.sender == i_owner, "you must be owner to withdraw funds");

        if(msg.sender != i_owner) { revert NotOwner(); }

        _;  // this tells that rest oif code in function will be added after our require/revert statement
    }


    // what happens if someone sends this contract ETH without calling the fund function
    // receive()
    receive() external payable {
        fund();
     }
    // fallback()
    fallback() external payable { 
        fund();
    }



}