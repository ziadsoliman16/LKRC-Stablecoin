// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LKRC is ERC20, Ownable, Pausable, ReentrancyGuard {
    // Blacklist functionality
    mapping(address => bool) public blacklist;
    
    // Events
    event AddedToBlacklist(address indexed account);
    event RemovedFromBlacklist(address indexed account);
    event DestroyedBlackFunds(address indexed blackListedUser, uint256 balance);
    
    // Modifiers
    modifier notBlacklisted(address account) {
        require(!blacklist[account], "LKRC: account is blacklisted");
        _;
    }
    
    constructor(uint256 _initialSupply, address initialOwner)
        ERC20("LKRC Token", "LKRC")
        Ownable(initialOwner)
    {
        _mint(initialOwner, _initialSupply * 10**decimals());
    }
    
    // Override transfer functions to add blacklist and pause protection
    function transfer(address to, uint256 amount)
        public
        override
        nonReentrant
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(to)
        returns (bool)
    {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        override
        nonReentrant
        whenNotPaused
        notBlacklisted(from)
        notBlacklisted(to)
        notBlacklisted(msg.sender)
        returns (bool)
    {
        return super.transferFrom(from, to, amount);
    }

    function approve(address spender, uint256 amount)
        public
        override
        nonReentrant
        notBlacklisted(msg.sender)
        notBlacklisted(spender)
        returns (bool)
    {
        return super.approve(spender, amount);
    }
    
    
    // Blacklist Functions
    function addToBlacklist(address account) public onlyOwner {
        require(!blacklist[account], "LKRC: account is already blacklisted");
        blacklist[account] = true;
        emit AddedToBlacklist(account);
    }
    
    function removeFromBlacklist(address account) public onlyOwner {
        require(blacklist[account], "LKRC: account is not blacklisted");
        blacklist[account] = false;
        emit RemovedFromBlacklist(account);
    }
    
    function isBlacklisted(address account) public view returns (bool) {
        return blacklist[account];
    }
    
    // Destroy blacklisted funds (similar to USDT)
    function destroyBlackFunds(address blackListedUser) public onlyOwner nonReentrant {
        require(blacklist[blackListedUser], "LKRC: account is not blacklisted");
        uint256 dirtyFunds = balanceOf(blackListedUser);
        _burn(blackListedUser, dirtyFunds);
        emit DestroyedBlackFunds(blackListedUser, dirtyFunds);
    }
    
    // Batch blacklist operations for efficiency
    function addToBlacklistBatch(address[] calldata accounts) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            if (!blacklist[accounts[i]]) {
                blacklist[accounts[i]] = true;
                emit AddedToBlacklist(accounts[i]);
            }
        }
    }
    
    function removeFromBlacklistBatch(address[] calldata accounts) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            if (blacklist[accounts[i]]) {
                blacklist[accounts[i]] = false;
                emit RemovedFromBlacklist(accounts[i]);
            }
        }
    }
    
    // Pause functionality (inherited from OpenZeppelin Pausable)
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
    
    // Mint function (only owner)
    function mint(address to, uint256 amount) public onlyOwner nonReentrant notBlacklisted(to) {
        _mint(to, amount);
    }

    // Burn function (only owner)
    function burn(uint256 amount) public onlyOwner nonReentrant {
        _burn(owner(), amount);
    }
}