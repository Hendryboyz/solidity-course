// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract WillThrow {
  function aFunction() public pure {
    require(false, "Always wrong here.");
  }
}

contract ErrorHandling {
  event ErrorLogging(string reason);

  function catchError() public {
    WillThrow will = new WillThrow();
    try will.aFunction() {
      // Nothing happend here.
    } catch Error(string memory reason) {
      emit ErrorLogging(reason);
    }
  }
}