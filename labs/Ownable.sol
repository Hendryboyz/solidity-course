// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Owned {
  address contractOwner;

  constructor() {
    contractOwner = msg.sender;
  }

  modifier allowOwnerOnly() {
    require(msg.sender == contractOwner, "Access denied.");
    _;
  }
}