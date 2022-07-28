// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {

  function isOwner() view public returns (bool) {
    return owner() == msg.sender;
  }

  function withdraw(address payable _to, uint _amount) public onlyOwner {
    _to.transfer(_amount);
  }

  // fallback function to receive funds
  receive() external payable { }
}