// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.9;

import "./@openzeppelin/contracts/security/Pausable.sol";
import "./@openzeppelin/contracts/access/Ownable.sol";

interface TransferOPCH {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract OPCHLiquidityBucket is Pausable, Ownable {
    TransferOPCH private _OPCHToken;
    mapping(address => uint256) public userAllocation;
    uint256 public constant maxLimit = 100 * (10**6) * 10**18;
    uint256 public totalMembers;
    uint256 public allocatedSum;

    event GrantAllocationEvent(address allcationAdd, uint256 amount);

    constructor(TransferOPCH tokenAddress) {
        require(address(tokenAddress) != address(0),"Token Address cannot be address 0");
        _OPCHToken = tokenAddress;
        totalMembers = 0;
        allocatedSum = 0;
    }

    function GrantAllocation(address[] calldata _allocationAdd,uint256[] calldata _amount
    ) external onlyOwner {
        require(_allocationAdd.length == _amount.length);

        for (uint256 i = 0; i < _allocationAdd.length; ++i) {
            _GrantAllocation(_allocationAdd[i], _amount[i]);
        }
    }

    function _GrantAllocation(address allocationAdd, uint256 amount) internal {
        require(allocationAdd != address(0), "Invalid allocation address");
        require(amount > 0, "Invalid allocation amount");
        require(allocatedSum  + amount <= maxLimit,"Limit exceeded");


        if (userAllocation[allocationAdd] == 0) {
            totalMembers++;
        }
        allocatedSum = allocatedSum + amount;
        userAllocation[allocationAdd] += amount;
        emit GrantAllocationEvent(allocationAdd, amount);
        require(_OPCHToken.transfer(allocationAdd, amount),"Token transfer failed!");
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
