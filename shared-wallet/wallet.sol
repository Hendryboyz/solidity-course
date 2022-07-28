// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/v4.7.2/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/v4.7.2/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {

  using SafeMath for uint;

  mapping(address => uint) public allowance;

  event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

  function setAllowance(address _who, uint _amount) public onlyOwner {
    emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
    allowance[_who] = _amount;
  }

  modifier isOwnerOrAllowed(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "Access denied");
    _;
  }

  function isOwner() view public returns (bool) {
    return owner() == msg.sender;
  }

  function reduceAllowance(address _who, uint _amount) internal isOwnerOrAllowed(_amount) {
    emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
    allowance[_who] -= _amount;
  }
}

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

  // fallback function to receive funds
  receive() external payable {
    emit MoneyReceived(msg.sender, msg.value);
  }
}