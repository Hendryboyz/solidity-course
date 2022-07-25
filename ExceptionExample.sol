// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract ExceptionContract {
  mapping(address => uint64) public balanceReceived;
  address public contractOwner;

  constructor() public {
    contractOwner = msg.sender;
  }

  function send() payable public {
    assert(msg.value == uint64(msg.value));
    balanceReceived[msg.sender] += uint64(msg.value);
    assert(balanceReceived[msg.sender] >= uint64(msg.value));
  }

  function withdraw(address payable _to, uint64 _amount) public {
    uint remainingBalance = balanceReceived[msg.sender];
    require(_amount <= remainingBalance, "Not enough funds to withdraw, aboring.");
    assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
    balanceReceived[msg.sender] -= _amount;
    _to.transfer(_amount);
  }
}