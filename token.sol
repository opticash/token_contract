// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./@openzeppelin/contracts/access/Ownable.sol";

interface ArbitraryTokenStorage {
    function unlockERC(IERC20 token) external;
}

contract ERC20Storage is Ownable, ArbitraryTokenStorage {
    function unlockERC(IERC20 token) external virtual override onlyOwner {
        uint256 balance = token.balanceOf(address(this));

        require(balance > 0, "Contract has no balance");
        require(token.transfer(owner(), balance), "Transfer failed");
    }
}

contract OPCH is ERC20Burnable, ERC20Storage {
    bool mintCalled = false;

    address public MarketingBucketAddress;
    address public TeamBucketAddress;
    address public StrategicBucketAddress;
    address public PublicBucketAddress;
    address public LiquidityBucketAddress;
    address public PrivateBucketAddress;
    address public FoundationBucketAddress;
    address public AdvisersBucketAddress;

    uint256 public constant MarketingLimit = 250 * (10**6) * 10**18;
    uint256 public constant TeamLimit = 60 * (10**6) * 10**18;
    uint256 public constant StrategicLimit = 100 * (10**6) * 10**18;
    uint256 public constant PublicSaleLimit = 250 * (10**6) * 10**18;
    uint256 public constant LiquidityLimit = 100 * (10**6) * 10**18;
    uint256 public constant PrivateSaleLimit = 100 * (10**6) * 10**18;
    uint256 public constant FoundationLimit = 100 * (10**6) * 10**18;
    uint256 public constant AdvisersLimit = 40 * (10**6) * 10**18;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function setAllocation(
        address marketingBucketAddress,
        address teamBucketAddress,
        address strategicBucketAddress,
        address publicBucketAddress,
        address liquidityBucketAddress,
        address privateBucketAddress,
        address foundationBucketAddress,
        address advisersBucketAddress
    ) external onlyOwner {
        require(mintCalled == false, "Allocation already done.");

        MarketingBucketAddress = marketingBucketAddress;
        TeamBucketAddress = teamBucketAddress;
        StrategicBucketAddress = strategicBucketAddress;
        PublicBucketAddress = publicBucketAddress;
        LiquidityBucketAddress = liquidityBucketAddress;
        PrivateBucketAddress = privateBucketAddress;
        FoundationBucketAddress = foundationBucketAddress;
        AdvisersBucketAddress = advisersBucketAddress;

        _mint(MarketingBucketAddress, MarketingLimit);
        _mint(TeamBucketAddress, TeamLimit);
        _mint(StrategicBucketAddress, StrategicLimit);
        _mint(PublicBucketAddress, PublicSaleLimit);
        _mint(LiquidityBucketAddress, LiquidityLimit);
        _mint(PrivateBucketAddress, PrivateSaleLimit);
        _mint(AdvisersBucketAddress, AdvisersLimit);
        _mint(FoundationBucketAddress, FoundationLimit);

        mintCalled = true;
    }
}
