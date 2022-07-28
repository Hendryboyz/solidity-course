// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Ownable.sol";

contract TokenContract is Owned {
  mapping(address => uint) public tokenBalance;
  uint tokenPrice = 1 ether;

  constructor() {
    tokenBalance[contractOwner] = 100;
  }

  function createNewToken() public allowOwnerOnly {
    tokenBalance[contractOwner]++;
  }

  function burnToken() public allowOwnerOnly  {
    tokenBalance[contractOwner]--;
  }

  function purchaseToken() payable public {
    uint tokenValue = tokenBalance[contractOwner] * tokenPrice;
    bool inStock = (tokenValue / msg.value) > 0;
    require(inStock, "Not enough tokens");
    uint purchaseAmount = msg.value / tokenPrice;
    tokenBalance[contractOwner] -= purchaseAmount;
    tokenBalance[msg.sender] += purchaseAmount;
  }

  function sendToken(address _to, uint _amount) public {
    require(tokenBalance[msg.sender] >= _amount, "Not enough token");
    assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
    assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
    tokenBalance[msg.sender] -= _amount;
    tokenBalance[_to] += _amount;
  }
}