// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

//266997490918

// safe math - uncheck int and checked integer

// contant and immutable variable to resuce gas cost

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;
    // gas cost
    // 537592 - without constant
    // 517293 - with constant
    uint256 public constant minimumUsd = 5e18;

    address[] public funders;
    mapping (address funder=>uint256 amoutFunded) addressToAmountFunded;

    //494790
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    modifier onlyOwner {
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }
    
    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd,"Not enough eth to proceed"); // 1 * 10 ** 18
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){
            addressToAmountFunded[funders[funderIndex]] = 0;
        }
        // reset to zero
        funders = new address[](0);
        // tranfer fund
        //payable(msg.sender).transfer(address(this).balance);
        //payable(msg.sender).send(address(this).balance);
         (bool sent,) =payable(msg.sender).call{value:address(this).balance}("");
         require(sent,"Transaction failed");
    }

    // what happens if someone sends this contract ETH  without caliing the fund function

    // receive()
    // fallback()

    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }

}