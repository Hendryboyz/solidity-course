// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {

  mapping(address => uint) public allowance;

  function addAllowance(address _who, uint _amount) public onlyOwner {
    allowance[_who] += _amount;
  }

  modifier isOwnerOrAllowed(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "Access denied");
    _;
  }

  function isOwner() view public returns (bool) {
    return owner() == msg.sender;
  }

  function reduceAllowance(address _who, uint _amount) internal isOwnerOrAllowed(_amount) {
    allowance[_who] -= _amount;
  }

  function withdraw(address payable _to, uint _amount) public isOwnerOrAllowed(_amount) {
    bool isFundEnough = _amount <= address(this).balance;
    require(isFundEnough, "Not enough fund in the contract");
    if (!isOwner()) {
      reduceAllowance(msg.sender, _amount);
    }
    _to.transfer(_amount);
  }

  // fallback function to receive funds
  receive() external payable { }
}