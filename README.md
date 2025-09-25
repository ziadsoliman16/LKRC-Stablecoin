# LKRC Stablecoin Token

A fully-featured ERC20 stablecoin token built on Ethereum with comprehensive security features including blacklisting, pausability, and controlled minting/burning mechanisms.

## 🏗️ Architecture

LKRC is built using OpenZeppelin's battle-tested smart contract libraries, ensuring maximum security and gas efficiency:

- **ERC20**: Standard token functionality
- **Ownable**: Access control for administrative functions
- **Pausable**: Emergency stop mechanism for all transfers
- **ReentrancyGuard**: Protection against reentrancy attacks

## 🚀 Key Features

### 1. **Standard ERC20 Functionality**
- Transfer tokens between addresses
- Approve spending allowances
- Check balances and total supply
- Standard events for transfers and approvals

### 2. **Administrative Controls**
- **Owner-only functions**: Critical operations restricted to contract owner
- **Ownership transfer**: Ability to transfer ownership to new address
- **Secure access patterns**: Uses OpenZeppelin's proven access control

### 3. **Emergency Pause System**
- **Global pause**: Owner can halt all token transfers during emergencies
- **Granular control**: Pause and unpause functions available
- **Safety mechanism**: Protects users during security incidents or upgrades

### 4. **Comprehensive Blacklisting**
- **Individual blacklisting**: Add/remove specific addresses from blacklist
- **Batch operations**: Efficiently blacklist multiple addresses at once
- **Transfer restrictions**: Blacklisted addresses cannot send, receive, or approve tokens
- **Transparency**: Public function to check blacklist status

### 5. **Fund Management**
- **Controlled minting**: Owner can mint new tokens to any non-blacklisted address
- **Controlled burning**: Owner can burn tokens from their own balance
- **Blacklist enforcement**: Cannot mint to blacklisted addresses

### 6. **Regulatory Compliance**
- **Fund destruction**: Ability to destroy tokens held by blacklisted addresses
- **Audit trail**: All blacklist actions emit events for transparency
- **Compliance features**: Similar to established stablecoins like USDT

## 📋 Contract Interface

### Constructor
```solidity
constructor(uint256 _initialSupply, address initialOwner)
```
- `_initialSupply`: Initial token supply (in whole tokens, automatically converted to wei)
- `initialOwner`: Address that will own the contract and receive initial supply

### Core Functions

#### Token Operations
```solidity
function transfer(address to, uint256 amount) public returns (bool)
function transferFrom(address from, address to, uint256 amount) public returns (bool)
function approve(address spender, uint256 amount) public returns (bool)
```

#### Administrative Functions
```solidity
function mint(address to, uint256 amount) public onlyOwner
function burn(uint256 amount) public onlyOwner
function pause() public onlyOwner
function unpause() public onlyOwner
```

#### Blacklist Management
```solidity
function addToBlacklist(address account) public onlyOwner
function removeFromBlacklist(address account) public onlyOwner
function addToBlacklistBatch(address[] calldata accounts) public onlyOwner
function removeFromBlacklistBatch(address[] calldata accounts) public onlyOwner
function isBlacklisted(address account) public view returns (bool)
function destroyBlackFunds(address blackListedUser) public onlyOwner
```

## 💼 Stablecoin Operations Guide

### **Minting New Tokens**
1. **Access Control**: Only the contract owner can mint tokens
2. **Blacklist Check**: Cannot mint to blacklisted addresses
3. **Supply Increase**: Minting increases total token supply
4. **Use Cases**: Backing new tokens with reserves, market expansion

```solidity
// Mint 1000 tokens to address
mint(userAddress, 1000 * 10**18);
```

### **Burning Tokens**
1. **Owner Only**: Only owner can burn tokens from their balance
2. **Supply Decrease**: Burning reduces total token supply
3. **Use Cases**: Removing tokens from circulation, reserve management

```solidity
// Burn 500 tokens from owner's balance
burn(500 * 10**18);
```

### **Emergency Procedures**

#### **Pausing the Token**
- **When to use**: Security incidents, smart contract upgrades, regulatory requirements
- **Effect**: All transfers, approvals, and minting/burning are halted
- **Recovery**: Owner can unpause when situation is resolved

#### **Blacklisting Addresses**
- **Purpose**: Regulatory compliance, fraud prevention, sanctions enforcement
- **Effect**: Blacklisted addresses cannot send, receive, or approve tokens
- **Batch operations**: Efficiently manage multiple addresses

#### **Fund Destruction**
- **Purpose**: Remove tokens from blacklisted addresses
- **Process**: Burns all tokens held by the blacklisted address
- **Compliance**: Similar to USDT's approach for regulatory compliance

## 🔒 Security Features

### **Reentrancy Protection**
- All state-changing functions protected against reentrancy attacks
- Uses OpenZeppelin's `ReentrancyGuard` modifier

### **Access Control**
- Administrative functions restricted to contract owner
- Owner can transfer ownership to new address

### **Input Validation**
- Zero address checks on critical functions
- Blacklist status verification before operations
- Proper error messages for failed operations

### **Event Logging**
- All significant actions emit events for transparency
- Blacklist changes tracked with dedicated events
- Standard ERC20 events for all transfers and approvals

## 🎯 Use Cases

### **For Stablecoin Operators**
- **Reserve Management**: Mint tokens backed by reserves
- **Regulatory Compliance**: Blacklist non-compliant addresses
- **Emergency Response**: Pause operations during incidents
- **Supply Control**: Manage token supply based on demand

### **For DeFi Integration**
- **Standard Interface**: Full ERC20 compliance for DEX integration
- **Pausability**: Built-in circuit breaker for emergency situations
- **Transparency**: Public functions for checking token status

### **For Enterprises**
- **Compliance Tools**: Blacklisting for regulatory requirements
- **Audit Trail**: Comprehensive event logging
- **Access Control**: Secure ownership and permission model

## 🚨 Important Considerations

### **Centralization Trade-offs**
- Owner has significant control over token operations
- Necessary for regulatory compliance and emergency response
- Consider multi-signature wallets for owner address

### **Gas Optimization**
- Uses OpenZeppelin contracts for optimal gas usage
- Batch operations available for efficiency
- ReentrancyGuard adds small gas overhead for security

### **Upgrade Path**
- Current contract is not upgradeable
- Consider proxy patterns for future versions
- Plan migration strategy if upgrades needed

## 📊 Token Specifications

- **Name**: LKRC Token
- **Symbol**: LKRC
- **Decimals**: 18
- **Standard**: ERC20
- **Network**: Ethereum Compatible
- **License**: MIT

## 🛠️ Development Setup

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Compile Contract**
   ```bash
   # Using Hardhat
   npx hardhat compile

   # Using Foundry
   forge build
   ```

3. **Deploy Contract**
   ```solidity
   // Example deployment parameters
   uint256 initialSupply = 1000000; // 1 million tokens
   address owner = 0x...; // Owner address

   LKRC token = new LKRC(initialSupply, owner);
   ```

## 📄 License

This project is licensed under the MIT License - see the contract header for details.