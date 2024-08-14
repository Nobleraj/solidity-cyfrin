// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {
     
     function store(uint256 _favNumber) public override  {
        myFavoriteNumber = _favNumber + 5;
     }

}