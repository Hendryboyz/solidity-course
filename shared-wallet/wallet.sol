// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./allowance.sol";

contract SharedWallet is Allowance {

  event MoneySent(address indexed _beneficiary, uint _amount);
  event MoneyReceived(address indexed _from, uint _amount);

  function withdraw(address payable _to, uint _amount) public isOwnerOrAllowed(_amount) {
    bool isFundEnough = _amount <= address(this).balance;
    require(isFundEnough, "Not enough fund in the contract");
    if (!isOwner()) {
      reduceAllowance(msg.sender, _amount);
    }
    emit MoneySent(_to, _amount);
    _to.transfer(_amount);
  }

  function renounceOwnership() view public override onlyOwner {
    revert("Can't renounce ownership"); // not possible
  }

  // fallback function to receive funds
  receive() external payable {
    emit MoneyReceived(msg.sender, msg.value);
  }
}