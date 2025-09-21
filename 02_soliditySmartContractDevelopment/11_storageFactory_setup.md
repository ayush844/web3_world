
## 1️⃣ Understanding the Goal – Composability

**Composability** means that smart contracts can *seamlessly* talk to each other and even deploy other contracts.

* In **DeFi**, for example, lending protocols interact with decentralized exchanges by simply calling each other’s public functions.
* Here, our `StorageFactory` contract will:

  1. Deploy fresh instances of the `SimpleStorage` contract.
  2. Interact with those instances (store/read numbers, etc.).

---

## 2️⃣ Base Contract: `SimpleStorage`

Create a new file called **`SimpleStorage.sol`**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {
    uint256 public favoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}
```

This is the external contract we will deploy from `StorageFactory`.

---

## 3️⃣ StorageFactory – First Approach (All in One File)

You *could* copy the `SimpleStorage` code above `StorageFactory` in the same file:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// --- SimpleStorage code here ---

contract StorageFactory {
    SimpleStorage public simpleStorage;

    function createSimpleStorageContract() public {
        // Deploy a new SimpleStorage instance
        simpleStorage = new SimpleStorage();
    }
}
```

* `SimpleStorage` on the **left** is the contract **type**.
* `simpleStorage` on the **right** is the **state variable** that stores the deployed instance.
* `new SimpleStorage()` actually **deploys** a new contract on-chain.

> 🟠 **Note**: This works but clutters the file and makes maintenance harder.

---

## 4️⃣ Using `import` for Clean Code

Best practice is to separate contracts into different files.

### File Structure

```
contracts/
  ├─ SimpleStorage.sol
  └─ StorageFactory.sol
```

### StorageFactory.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import only what we need
import { SimpleStorage } from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageContracts;  // Array of deployed instances

    function createSimpleStorageContract() public {
        SimpleStorage newStorage = new SimpleStorage();
        simpleStorageContracts.push(newStorage);
    }

    // Store a number in a specific SimpleStorage instance
    function sfStore(uint256 _index, uint256 _favoriteNumber) public {
        SimpleStorage target = simpleStorageContracts[_index];
        target.store(_favoriteNumber);
    }

    // Retrieve a number from a specific instance
    function sfGet(uint256 _index) public view returns (uint256) {
        return simpleStorageContracts[_index].retrieve();
    }
}
```

Key points:

* **`import { SimpleStorage } from "./SimpleStorage.sol";`**
  Named import ensures only `SimpleStorage` is pulled in, not any other contract accidentally present in that file.
* `SimpleStorage[] public simpleStorageContracts` keeps track of every deployed instance.
* `sfStore` and `sfGet` show how to interact with a specific deployed contract by its index.

---

## 5️⃣ Deployment & Interaction in Remix

1. **Compile** both files with the same compiler version (e.g., 0.8.18).

   > ⚠️ All imported files must have compatible `pragma` statements.
2. In Remix, select **StorageFactory** as the deployment contract and click **Deploy**.
3. Click **createSimpleStorageContract** to deploy a new `SimpleStorage` instance.

   * The address of each deployed contract is visible in the array `simpleStorageContracts`.
4. Use `sfStore(index, number)` to store a number in a specific instance.
5. Call `sfGet(index)` to retrieve that number.

---

## 6️⃣ Why This Matters

* **Composability** lets you build *factories* that spawn many similar contracts—perfect for NFT collections, multi-tenant apps, or DeFi vaults.
* By importing code instead of copying:

  * ✅ Cleaner files
  * ✅ Easier maintenance (update `SimpleStorage.sol` once, and every dependent contract benefits)
  * ✅ Smaller deployment size if you only use named imports

---

### 🔑 Takeaways

* **new ContractName()** deploys a contract from within another contract.
* Use **named imports**: `import { Contract } from "./File.sol";`
* Keep compiler versions **consistent** across all imported files.
* Arrays or mappings of deployed contract addresses let you manage many instances.

With this setup, you’ve built a **StorageFactory** that programmatically deploys and manages multiple `SimpleStorage` contracts—an essential pattern for scalable, modular decentralized applications.
