//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.2/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.2/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {
    using SafeMath for uint;

    event AllowanceChanged(address _who, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].add(_amount));
        // TODO: verify total allowance should be smaller than the balance stored in the smart contract
        allowance[_who] = allowance[_who].add(_amount);
    }

    function _isOwner() internal view returns (bool) {
        return _msgSender() == owner();
    }

    modifier ownerOrAllowed(uint _amount) {
        require(_isOwner() || allowance[msg.sender] > _amount, "Not allowed");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        // TODO: allowance should not be negative ?
        allowance[_who] = allowance[_who].sub(_amount);
    }
}