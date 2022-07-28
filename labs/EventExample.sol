// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EventContract {
  mapping(address => uint) public tokenBalance;

  event TokensSent(address _from, address _to, uint _amount);

  constructor() {
    tokenBalance[msg.sender] = 100;
  }

  function sendToken(address _to, uint _amount) public returns(bool) {
    bool isTokenEnough = tokenBalance[msg.sender] >= _amount;
    require(isTokenEnough, "Not enough tokens.");
    assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
    assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
    tokenBalance[msg.sender] -= _amount;
    tokenBalance[_to] += _amount;
    emit TokensSent(msg.sender, _to, _amount);
    return true;
  }
}