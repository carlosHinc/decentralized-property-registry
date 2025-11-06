# Real Estate Transaction System

A decentralized real estate transaction management system built on Ethereum blockchain using Solidity smart contracts. This system allows for secure registration of persons, properties, and property transactions with proper validation, access controls, and automated balance management.

## Features

### Core Functionality

- **Register a Person** - Register users in the system with their balance
- **Register a Property** - Add properties to the registry with deed, location, and price
- **Execute a Transaction** - Facilitate property sales between registered users
- **Automatic Balance Management** - Automatically updates buyer and seller balances
- **Property Ownership Transfer** - Transfers property ownership upon successful transaction

### Key Features

- **Decentralized Storage**: All records are stored on the blockchain ensuring immutability and transparency
- **Validation System**: Built-in checks to prevent duplicate registrations and invalid transactions
- **Event Logging**: Comprehensive event system for tracking all operations
- **Address-based Access**: Uses Ethereum addresses for unique user identification
- **Balance Verification**: Ensures buyers have sufficient funds before transaction execution
- **Optimized Lookups**: Uses mapping-based indexing for O(1) access complexity

## Smart Contract Details

**Contract**: `UnitTwoProject`  
**Solidity Version**: `0.8.24`  
**License**: `LGPL-3.0-only`

## Data Structures

```solidity
struct Person {
    address id;           // User's Ethereum address
    string name;          // User's name
    uint256 balance;      // User's balance
}

struct Property {
    uint256 deed;         // Property deed number (unique identifier)
    address ownerId;      // Current owner's address
    string location;      // Property location
    uint256 price;        // Property price
}

struct Transaction {
    uint256 propertyDeed; // Property deed involved in transaction
    address buyerId;      // Buyer's address
    address sellerId;     // Seller's address
    uint256 date;         // Transaction timestamp
    uint256 transactionValue; // Transaction amount
}
```

## Functions

### `addPerson(address _id, string memory name, uint256 balance)`

**Purpose**: Register a new person in the system  
**Parameters**:

- `_id`: Ethereum address of the person
- `name`: Name of the person
- `balance`: Initial balance

**Access**: Public  
**Validation**: Prevents duplicate person registration  
**Event**: Emits `PersonAdded` event

---

### `addProperty(uint256 _id, address _ownerId, string memory _location, uint256 _price)`

**Purpose**: Register a new property in the system  
**Parameters**:

- `_id`: Property deed number (unique identifier)
- `_ownerId`: Address of the property owner
- `_location`: Property location
- `_price`: Property price

**Access**: Public  
**Validation**: Prevents duplicate property deed registration  
**Event**: Emits `PropertyAdded` event

---

### `addTransaction(uint256 _propertyId, address _sellerId, address _buyerId, uint256 _amount)`

**Purpose**: Execute a property transaction between two registered users  
**Parameters**:

- `_propertyId`: Deed number of the property being sold
- `_sellerId`: Address of the seller
- `_buyerId`: Address of the buyer
- `_amount`: Transaction amount

**Access**: Public  
**Validations**:

- Buyer exists in the system
- Seller exists in the system
- Property deed exists
- Buyer has sufficient balance

**Events**: Emits multiple events:

- `PersonBalanceDiscount` (buyer's balance reduced)
- `ValueReceivedPerson` (seller's balance increased)
- `ChangeOwnerProperty` (property ownership transferred)
- `NewTransaction` (transaction recorded)

## Events

- **PersonAdded(address id, string name, uint256 balance)** - Emitted when a person is registered
- **PropertyAdded(uint256 deed, address ownerId, string location, uint256 price)** - Emitted when a property is registered
- **PersonBalanceDiscount(address idPerson, uint256 discountedValue)** - Emitted when buyer's balance is reduced
- **ValueReceivedPerson(address idPerson, uint256 valueReceived)** - Emitted when seller receives payment
- **ChangeOwnerProperty(address idNewOwner, address idOldOwner, uint256 deedProperty)** - Emitted when property ownership changes
- **NewTransaction(uint256 propertyDeed, address buyerId, address sellerId, uint256 date, uint256 transactionValue)** - Emitted when a transaction is completed

## Architecture & Optimization

### Mapping-Based Indexing

The contract uses an optimized data structure combining arrays with mappings for efficient lookups:

```solidity
// Persons
Person[] public persons;
mapping(address => uint256) public personIdToIndex;  // O(1) lookup
mapping(address => bool) public personIdExists;      // O(1) validation

// Properties
Property[] public properties;
mapping(uint256 => uint256) public propertyDeedToIndex;  // O(1) lookup
mapping(uint256 => bool) public propertyDeedExists;      // O(1) validation
```

**Benefits**:

- **O(1) access time** instead of O(n) with array loops
- **Efficient validation** of existence
- **Gas optimization** for large datasets

## Testing

This contract has been tested and verified on **Remix IDE**, ensuring:

- ✅ All functions work as expected
- ✅ Validation mechanisms prevent duplicate registrations
- ✅ Transaction logic correctly updates all parties
- ✅ Events are properly emitted
- ✅ Balance management works correctly
- ✅ Gas optimization is maintained

## Future Enhancements

### Planned Features

**Role-based Access Control**:

- Implement admin roles for system management
- Add property inspector role for verification
- Implement notary role for transaction validation

**Enhanced Security**:

- Multi-signature requirements for high-value transactions
- Escrow system for safer transactions
- Time-locked transactions

**Additional Functionality**:

- Property history tracking
- Transaction cancellation mechanism
- Partial payments and installment plans
- Property rental system
- Property valuation updates
- Integration with external property registries

**Governance Features**:

- Transaction fee system
- Dispute resolution mechanism
- Property verification system
- Automated tax calculation

## Getting Started

### Prerequisites

- Ethereum wallet (MetaMask recommended)
- Access to an Ethereum network (testnet or mainnet)
- Remix IDE or compatible development environment

### Deployment

1. Compile the contract in Remix IDE
2. Deploy to your chosen Ethereum network
3. Interact with the contract using the deployed address

## Usage Example

```javascript
// Register a person (buyer)
await contract.addPerson(
  "0xBuyerAddress",
  "John Doe",
  1000000 // Balance: 1,000,000
);

// Register a person (seller)
await contract.addPerson("0xSellerAddress", "Jane Smith", 500000);

// Register a property
await contract.addProperty(
  123456, // Deed number
  "0xSellerAddress", // Owner
  "123 Main St", // Location
  500000 // Price
);

// Execute a transaction
await contract.addTransaction(
  123456, // Property deed
  "0xSellerAddress", // Seller
  "0xBuyerAddress", // Buyer
  500000 // Amount
);

// Result:
// - Buyer balance: 1,000,000 - 500,000 = 500,000
// - Seller balance: 500,000 + 500,000 = 1,000,000
// - Property owner: 0xBuyerAddress
```

## Security Considerations

- All data is stored on the blockchain and is publicly readable
- Ensure proper key management for wallet addresses
- Validate all inputs before contract interaction
- Consider implementing additional access controls for production use
- Regular security audits recommended for production deployment
- Be aware of transaction costs and gas optimization

## Gas Optimization

The contract implements several gas optimization techniques:

- **Mapping-based indexing** for O(1) lookups
- **`-=` and `+=` operators** instead of explicit subtraction/addition
- **Memory vs Storage** optimization for structs
- **Event emission** for off-chain data tracking instead of on-chain storage

## License

This project is licensed under the **LGPL-3.0-only** license.

---

**Author**: Carlos Hincapie  
**Last Updated**: November 6, 2025
