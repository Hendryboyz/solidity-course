// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

library AddUint {
  function add(uint _augend, uint _addend) public pure returns(uint) {
    return _augend + _addend;
  }
}

contract LibraryContract {
  using AddUint for uint;

  uint public myUint;

  constructor() {}

  function increase(uint _amount) public {
    myUint = myUint.add(_amount);
  }
}