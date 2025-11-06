// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.8.24;

contract DecentralizedPropertyRegistry {

    // Variables and structs
    struct Person {
        address id;
        string name;
        uint256 balance;
    }

    struct Property {
        uint256 deed;
        address ownerId;
        string location;
        uint256 price;
    }

    struct Transaction {
        uint256 propertyDeed;
        address buyerId;
        address sellerId;
        uint256 date;
        uint256 transactionValue;
    }

    mapping(address id => uint256 index) public personIdToIndex;
    mapping(address id => bool) public personIdExists;
    Person[] public persons;

    mapping(uint256 deed => uint256 index) public propertyDeedToIndex;
    mapping(uint256 deed => bool) public propertyDeedExists;
    Property[] public properties;

    Transaction[] public transactions;

    // Modifiers
    modifier idNotExist(address _id) {
        require(!personIdExists[_id], "el usuario ya existe");
        _;
    }

    modifier idIfExists(address _id) {
        require(personIdExists[_id], "el usuario No existe");
        _;
    }

    modifier deedNotExist(uint256 _deed) {
        require(!propertyDeedExists[_deed], "Matricula ya existe");
        _;
    }

    modifier deedIfExists(uint256 _deed) {
        require(propertyDeedExists[_deed], "Matricula No existe");
        _;
    }

    modifier validateSufficientBalanceBuyer(address _buyerId, uint256 _transactionValue) {
        require(persons[personIdToIndex[_buyerId]].balance >= _transactionValue, "Saldo usuario insuficiente");
        _;
    }

    // Events
    event PersonAdded(address id, string name, uint256 balance);
    event PropertyAdded(uint256 deed, address ownerId, string location, uint256 price);
    event PersonBalanceDiscount(address idPerson, uint256 discountedValue);
    event ValueReceivedPerson(address idPerson, uint256 valueReceived);
    event ChangeOwnerProperty(address idNewOwner, address idOldOwner, uint256 deedProperty);
    event NewTransaction(uint256 propertyDeed, address buyerId, address sellerId, uint256 date, uint256 transactionValue);

    // External functions
    function addPerson(address _id, string memory name, uint256 balance) public  {
        Person memory newPerson = Person({
            id: _id,
            name: name,
            balance: balance
        });
        addPersonLogic(newPerson);
    }

    function addProperty(uint256 _id, address _ownerId, string memory _location, uint256 _price) public {
        Property memory newProperty = Property(_id, _ownerId, _location, _price);
        addPropertyogic(newProperty);
    }

    function addTransaction(uint256 _propertyId, address _sellerId , address _buyerId, uint256 _amount) public {
        uint256 currentTime = block.timestamp;
        Transaction memory newTransaction = Transaction(_propertyId, _sellerId, _buyerId, currentTime, _amount);
        addTransactionLogic(newTransaction);
    }

    function updateBuyerBalance(address _buyerId, uint256 _transactionValue) internal {
        persons[personIdToIndex[_buyerId]].balance -= _transactionValue;
        emit PersonBalanceDiscount(_buyerId, _transactionValue);
    }

    function updateSellerBalance(address _sellerId, uint256 _transactionValue) internal {
        persons[personIdToIndex[_sellerId]].balance += _transactionValue;
        emit ValueReceivedPerson(_sellerId, _transactionValue);
    }

    function updateOwnerProperty(uint256 propertyDeed, address buyerId, address _sellerId) internal {
        properties[propertyDeedToIndex[propertyDeed]].ownerId =  buyerId;
        emit ChangeOwnerProperty(buyerId, _sellerId,propertyDeed);
    }

    
    function addPersonLogic(Person memory _person) internal idNotExist(_person.id) {
        persons.push(_person);
        personIdToIndex[_person.id] = persons.length - 1;
        personIdExists[_person.id] = true;
        emit PersonAdded(_person.id, _person.name, _person.balance);
    }

    function addPropertyogic(Property memory _property) internal  deedNotExist(_property.deed) {
        properties.push(_property);
        propertyDeedToIndex[_property.deed] = properties.length - 1;
        propertyDeedExists[_property.deed] = true;
        emit PropertyAdded(_property.deed, _property.ownerId, _property.location, _property.price);
    }

    function addTransactionLogic(Transaction memory _transaction) internal 
    idIfExists(_transaction.buyerId) 
    idIfExists(_transaction.sellerId) 
    deedIfExists(_transaction.propertyDeed)
    validateSufficientBalanceBuyer(_transaction.buyerId, _transaction.transactionValue)  {
        updateBuyerBalance(_transaction.buyerId, _transaction.transactionValue);
        updateSellerBalance(_transaction.sellerId, _transaction.transactionValue);
        updateOwnerProperty(_transaction.propertyDeed, _transaction.buyerId, _transaction.sellerId);
        transactions.push(_transaction);
        emit NewTransaction(_transaction.propertyDeed, _transaction.buyerId, _transaction.sellerId, _transaction.date, _transaction.transactionValue);
    }   

}

