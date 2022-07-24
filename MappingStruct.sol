// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

struct Payment {
  uint amount;
  uint timestamp;
}

struct Balance {
  uint totalBalance;
  uint numPayments;
  mapping(uint => Payment) payments;
}

contract MappingStructContract {
  address contractOwner;
  mapping(address => Balance) public accountBalances;

  constructor() {
    contractOwner = msg.sender;
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  function send() payable public {
    accountBalances[msg.sender].totalBalance += msg.value;

    Payment memory payment = Payment(msg.value, block.timestamp);
    uint currentPaymentNumber = accountBalances[msg.sender].numPayments;
    accountBalances[msg.sender].payments[currentPaymentNumber] = payment;
    accountBalances[msg.sender].numPayments++;
  }

  function withdrawAll(address payable _to) public {
    uint balanceToSend = accountBalances[msg.sender].totalBalance;
    require(balanceToSend > 0, "Withdraw denied.");
    _to.transfer(balanceToSend);
    accountBalances[msg.sender].totalBalance = 0;
  }

  function withdraw(address payable _to, uint _balanceToSend) public {
    uint remainingBalance = accountBalances[msg.sender].totalBalance;
    require(remainingBalance >= _balanceToSend, "Not enough funds.");
    _to.transfer(_balanceToSend);
    accountBalances[msg.sender].totalBalance -= _balanceToSend;
  }
}