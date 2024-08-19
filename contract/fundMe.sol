// SPDX-License-Identifier: MIT

 pragma solidity ^0.8.18;

//  import "@chain"
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{
      using PriceConverter for uint256;
    mapping  (address =>uint256 ) public  addressToAmountToFund;
    address[] public funders;
    address public i_owner;
    uint256 public  constant MIN_USD = 5 * 10 ** 18;
    constructor() {
        i_owner = msg.sender;

    }

    function fund() public payable {
        require(msg.value >= MIN_USD);
        addressToAmountToFund[msg.sender]+= msg.value;
funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
         AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    modifier onlyOwner(){
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function withdraw() public onlyOwner{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder  = funders[funderIndex];
            addressToAmountToFund[funder]= 0;
        }
        funders = new address[](0);
// transfer
payable(msg.sender).transfer(address(this).balance);
//send 

//  bool sendSuccess = payable(msg.sender).send(address(this).balance);
 // require(sendSuccess, "Send failed");
//  call
           (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }
    receive() external payable {
        fund();
     }
}