# Functions

## ✅ Introduction

Functions are reusable blocks of code inside a smart contract that perform specific tasks.

* They can **read**, **write**, or **return** values.
* Functions define how external users and other contracts interact with your contract.

In the previous lesson, we stored a variable (`favoriteNumber`) on-chain. Now we’ll see how to **update**, **retrieve**, and manage it with functions—while learning about **visibility**, **transactions**, **gas**, and **variable scope**.

---

## 🛠️ Declaring a Function

Basic syntax:

```solidity
function functionName(type param1, type param2, ...) visibility stateMutability returns(type) {
    // code
}
```

* **functionName**: custom identifier (e.g. `store` or `retrieve`).
* **parameters**: inputs passed when calling the function.
* **visibility**: who can call it (`public`, `private`, `internal`, `external`).
* **stateMutability**: optional keywords (`view`, `pure`, `payable`) describing how the function interacts with blockchain state.

---

## 🏗 Example: Storing a Value

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint256 favoriteNumber;

    // Updates the state variable favoriteNumber
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
}
```

Key points:

* `store` is a **public** function: can be called from outside or inside the contract.
* `_favoriteNumber` is a **local parameter** (function scope).
* Writing to `favoriteNumber` changes blockchain **state**, so calling this function **costs gas**.

---

## 🔍 Reading the Value – View & Pure

If we only want to *read* data without changing state, we use **view** or **pure**.

```solidity
function retrieve() public view returns (uint256) {
    return favoriteNumber;
}
```

* `view`: reads from the blockchain but doesn’t modify it.
* `pure`: neither reads nor writes (e.g. returns a calculation only).

Example:

```solidity
function doubleNumber(uint256 x) public pure returns (uint256) {
    return x * 2;
}
```

💡 **Gas tip**:

* Calling `view` or `pure` functions *directly from an external account* is **free**.
* But if a state-changing function calls them internally, they **consume gas** as part of that transaction.

---

## 🌐 Visibility Specifiers

Determine where a function can be accessed.

| Specifier    | Meaning                                                                    | Use Case                                        |
| ------------ | -------------------------------------------------------------------------- | ----------------------------------------------- |
| **public**   | Callable internally and externally.                                        | Most common for user-facing methods.            |
| **private**  | Only callable inside the same contract.                                    | Helper functions not meant for external access. |
| **internal** | Accessible inside the contract and derived (child) contracts.              | Useful in inheritance.                          |
| **external** | Callable only from outside (other contracts or externally owned accounts). | Gas-efficient for read-only external calls.     |

If omitted, **internal** is default.

---

## 💸 Transactions & Gas

* **Deploying a contract**: Sends a transaction with compiled bytecode in the `data` field.
* **Calling a state-changing function**: Sends a transaction that updates storage.
* Both consume gas.
* Simple ETH transfers cost gas, but **contract calls cost more**, depending on code complexity.

---

## 📦 Variable Scope

Scope = where a variable can be accessed.

```solidity
function store(uint256 _favoriteNumber) public {
    favoriteNumber = _favoriteNumber;
    uint256 tempVar = 5; // local variable
}

function anotherFunc() public {
    // tempVar = 6; // ❌ Error: tempVar only exists in store()
    favoriteNumber = 7;   // ✅ State variable accessible everywhere in contract
}
```

* **State variables**: Declared at contract level, stored on-chain, accessible throughout the contract.
* **Local variables**: Declared inside functions, exist only during function execution.

---

## ⚡ Example with Different Functions

```solidity
pragma solidity ^0.8.19;

contract FunctionExamples {
    uint256 private secretNumber = 42;

    // 1️⃣ view function, internal (child contracts can use it)
    function getSecret() internal view returns (uint256) {
        return secretNumber;
    }

    // 2️⃣ pure function, external (cannot be called internally without 'this')
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }

    // 3️⃣ public view function accessible everywhere
    function readSecret() public view returns (uint256) {
        return getSecret();
    }
}
```

---

## 🏷️ Additional Tips & Best Practices

* **Explicit Data Types**: Always specify full types (e.g. `uint256` not just `uint`).
* **Naming**: Use `camelCase` for functions and variables.
* **Gas Optimization**:

  * Minimize state changes.
  * Use `memory` for temporary data like strings/arrays inside functions.
* **Events**: Emit events in functions that change state to help front-ends track activity.

  ```solidity
  event NumberStored(uint256 newNumber);
  ```

---

## 🧑‍💻 Test Yourself

1. List the four visibility specifiers and explain when to use each.
2. What’s the difference between `view` and `pure`?
3. When might a pure function still cost gas?
4. Explain variable scope with an example of a compilation error.
5. Contrast a transaction that deploys a contract with one that transfers ETH.

---

### ✨ Quick Recap

* **Functions** are the heart of smart contract logic.
* Use **view/pure** for read-only tasks to save gas.
* Correct **visibility** ensures proper access control.
* Understand **scope** to avoid variable errors and manage state effectively.

