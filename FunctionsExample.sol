// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionsContract {
  mapping(address => uint) public balanceReceived;
  address payable contractOwner;

  constructor() {
    contractOwner = payable(msg.sender);
  }

  function destroy() public {
    require(msg.sender == contractOwner, "Owner allow to destroy contract.");
    selfdestruct(contractOwner);
  }

  function getOwner() view public returns(address) {
    return contractOwner;
  }

  function deposit() payable public {
    address account = msg.sender;
    bool isAccountOverflow = (balanceReceived[account] + msg.value) < balanceReceived[account];
    assert(!isAccountOverflow);
    balanceReceived[account] += msg.value;
  }

  function withdraw(address payable _to, uint _amount) public {
    address account = msg.sender;
    bool haveEnoughFunds = balanceReceived[account] >= _amount;
    require(haveEnoughFunds, "Not enough funds.");
    bool isAccountUnderflow = (balanceReceived[account] - _amount) > balanceReceived[account];
    assert(!isAccountUnderflow);
    _to.transfer(_amount);
  }

  function convertWeiToEther(uint _amount) pure public returns(uint) {
    return _amount / 1 ether;
  }

  receive() external payable {
    deposit();
  }
}