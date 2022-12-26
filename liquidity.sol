// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.17;
import "./@openzeppelin/contracts/access/AccessControlEnumerable.sol";

interface TransferOPCH {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract OPCHLiquidityBucket is AccessControlEnumerable {
    TransferOPCH private _OPCHToken;
    mapping(address => uint256) public userAllocation;
    uint256 public constant maxLimit = 100 * (10**6) * 10**18;
    uint256 public totalMembers;
    uint256 public allocatedSum;
    bytes32 public constant GRANTER_ROLE = keccak256("GRANTER_ROLE");

    event GrantAllocationEvent(address allcationAdd, uint256 amount);

    constructor(TransferOPCH tokenAddress) {
        require(
            address(tokenAddress) != address(0),
            "Token Address cannot be address 0"
        );

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _OPCHToken = tokenAddress;
        totalMembers = 0;
        allocatedSum = 0;
    }

    function GrantFund(address allocationAdd, uint256 amount) external
    {
        require(
            hasRole(GRANTER_ROLE, _msgSender()) || hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "Must have admin or granter role"
        );
        require(allocationAdd != address(0), "Invalid allocation address");
        require(amount > 0, "Invalid allocation amount");
        require(allocatedSum + amount <= maxLimit, "Limit exceeded");

        if (userAllocation[allocationAdd] == 0) {
            totalMembers++;
        }
        allocatedSum = allocatedSum + amount;
        userAllocation[allocationAdd] += amount;
        emit GrantAllocationEvent(allocationAdd, amount);
        require(
            _OPCHToken.transfer(allocationAdd, amount),
            "Token transfer failed!"
        );
    }
}
