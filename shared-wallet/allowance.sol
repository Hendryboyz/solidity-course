// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.2/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.2/contracts/utils/math/SafeMath.sol";

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