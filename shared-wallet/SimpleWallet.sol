//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./SimpleAllowance.sol";

contract SimpleWallet is Allowance {
    event FundSent(address indexed _beneficiary, uint _amount, uint _walletBalance);
    event FundReceive(address indexed _from, uint _amount);

    function withdraw(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds stored in the smart contract");
        if (!_isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit FundSent(_to, _amount, address(this).balance - _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Renounce ownership is denied.");
    }

    receive() external payable {
        emit FundReceive(msg.sender, msg.value);
    }
}