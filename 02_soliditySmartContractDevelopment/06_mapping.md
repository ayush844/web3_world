
## 1️⃣ Why Mappings Exist

On-chain storage is expensive.
If you keep everyone’s data in an **array**, finding a specific entry means looping through every element—this costs gas that grows with the array size.

A **mapping** is like a permanent key-value database inside your contract:

* **Key** → anything unique you can use as an identifier (address, string, uint, etc.).
* **Value** → any type of data you want to retrieve instantly.

Lookups are **O(1)** (constant time) and cheap.

---

## 2️⃣ Basic Syntax

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FavoriteNumbers {
    // Key: a person's name
    // Value: their favorite number
    mapping(string => uint256) public nameToFavNum;

    function addPerson(string memory _name, uint256 _favNum) public {
        nameToFavNum[_name] = _favNum;
    }

    function getFavoriteNumber(string memory _name) public view returns (uint256) {
        return nameToFavNum[_name]; // returns 0 if the name doesn't exist
    }
}
```

Usage:

```solidity
// Add data
addPerson("Alice", 42);
addPerson("Bob", 99);

// Retrieve
getFavoriteNumber("Bob"); // returns 99
getFavoriteNumber("Charlie"); // returns 0 (default)
```

---

## 3️⃣ Mapping with Structs

You can store **complex data** as the value.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PhoneBook {
    struct Contact {
        string phone;
        string email;
    }

    // Key: Ethereum address
    // Value: Contact struct
    mapping(address => Contact) private contacts;

    function setContact(string memory _phone, string memory _email) public {
        contacts[msg.sender] = Contact(_phone, _email);
    }

    function getContact(address _user) public view returns (string memory, string memory) {
        Contact memory c = contacts[_user];
        return (c.phone, c.email);
    }
}
```

Here the caller’s address is the unique key.
Each wallet can set and read **its own contact info**.

---

## 4️⃣ Nested Mappings

Mappings can point to **another mapping** to create two-level lookups.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenBalance {
    // balances[owner][tokenSymbol] = amount
    mapping(address => mapping(string => uint256)) public balances;

    function deposit(string memory _symbol, uint256 _amount) public {
        balances[msg.sender][_symbol] += _amount;
    }

    function balanceOf(address _owner, string memory _symbol) public view returns (uint256) {
        return balances[_owner][_symbol];
    }
}
```

Example:

```solidity
deposit("DAI", 100);
deposit("USDC", 50);

balanceOf(msg.sender, "DAI");  // 100
balanceOf(msg.sender, "USDC"); // 50
```

---

## 5️⃣ Important Properties & Limitations

### ➤ Default Values

If a key has never been written, its value is the type’s default:

* `uint` → `0`
* `bool` → `false`
* `address` → `0x000...0`
* Struct → all fields default to their own default values.

```solidity
uint256 x = nameToFavNum["NotAdded"]; // 0
```

### ➤ No Length or Key Enumeration

Mappings **do not store keys**.
You **cannot** ask for “all keys” or “the total size” on-chain.

If you need iteration later (e.g., show all users), maintain a **parallel array**:

```solidity
string[] public names;

function addPerson(string memory _name, uint256 _favNum) public {
    if (nameToFavNum[_name] == 0) { // avoid duplicates
        names.push(_name);
    }
    nameToFavNum[_name] = _favNum;
}
```

You can then loop through `names` if necessary.

### ➤ Deleting a Value

You can delete a key to reset it to the default:

```solidity
function removePerson(string memory _name) public {
    delete nameToFavNum[_name];
}
```

---

## 6️⃣ Practical Use Cases

Mappings are the backbone of many real dApps:

* **ERC-20 Tokens** – `mapping(address => uint256) balances`
* **NFT Ownership** – `mapping(uint256 tokenId => address owner)`
* **Voting** – `mapping(address => bool) hasVoted`

---

### 🔑 Key Takeaways

* **Mappings = On-chain hash tables** with constant-time lookups.
* Best when you need to quickly **read or update** data by a unique key.
* No built-in iteration or key listing; keep a separate array if you need that.
* Default values mean you must track whether a record truly exists if `0` can be a valid value.

These patterns—single, struct, nested mappings—are the everyday tools for efficient Solidity smart-contract design.
