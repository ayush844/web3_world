
# 🟢 Arrays and Structs in Solidity

Up to now, the **SimpleStorage** contract could store and retrieve **one** favorite number.
To support **multiple users and numbers**, we introduce **arrays** (lists of values) and **structs** (custom data types).

---

## 1️⃣ Arrays

### What is an Array?

An **array** is an ordered collection of elements of the same type, stored at contiguous locations in blockchain storage.

* Solidity arrays can be **fixed-size** or **dynamic**.
* Elements are **zero-indexed** (first element at index `0`).

### Declaring an Array

```solidity
// Dynamic array (size can grow or shrink)
uint256[] public list_of_favorite_numbers;

// Fixed-size array (exactly 3 elements)
uint256[3] public fixedNumbers;
```

### Initializing

```solidity
uint256[] public nums = [0, 78, 90]; // dynamic with initial values
```

### Accessing Elements

```solidity
uint256 firstNum = nums[0]; // 0th index = 0
```

### Adding Elements

```solidity
nums.push(100);  // adds 100 to the end (dynamic arrays only)
```

### Key Points

* **Dynamic arrays** can grow using `.push()`.
* **Fixed-size arrays** cannot grow or shrink.
* Reading/writing array elements costs **gas** because they are stored on-chain.

---

## 2️⃣ Structs

### What is a Struct?

A **struct** is a **custom data type** that groups related variables of different types.
Think of it as a way to create your own object-like type.

Example:

```solidity
struct Person {
    uint256 favoriteNumber;
    string name;
}
```

* Here, `Person` is a **new type** with two properties:

  * `favoriteNumber` (a number)
  * `name` (a string)

> ⚠️ **Naming tip**: Avoid using the same name as existing variables to prevent clashes.

---

### Creating Struct Instances

```solidity
Person public myFriend = Person(7, "Pat");

// or using key-value style:
Person public anotherFriend = Person({
    favoriteNumber: 10,
    name: "Alice"
});
```

The `public` keyword **auto-generates a getter function** to read the struct from outside.

---

## 3️⃣ Combining Arrays and Structs

Managing individual `Person` variables for many users is repetitive.
➡️ Instead, use an **array of structs** to store **multiple people**.

### Dynamic Array of Structs

```solidity
Person[] public list_of_people; // dynamic array
```

### Fixed Array of Structs

```solidity
Person[3] public fixed_people; // exactly 3 Person objects
```

* **Dynamic arrays** can grow and shrink.
* **Fixed arrays** have a permanent size.

---

## 4️⃣ Adding Structs to the Array

To add a new person, create a function:

```solidity
function addPerson(string memory _name, uint256 _favoriteNumber) public {
    list_of_people.push(Person(_favoriteNumber, _name));
}
```

### How it Works:

1. **Inputs**: `_name` and `_favoriteNumber` are passed to the function.
2. `memory` is used for `_name` because strings are reference types and need a data location.
3. `Person(_favoriteNumber, _name)` creates a new struct object.
4. `.push()` adds it to the dynamic array.

---

### Reading from the Array

Since the array is `public`, Solidity automatically provides a getter:

```solidity
list_of_people(0)  // returns (favoriteNumber, name) of the first Person
```

---

## 5️⃣ Complete Example Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PeopleStorage {
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public list_of_people; // dynamic array

    // Add a new Person to the list
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        list_of_people.push(Person(_favoriteNumber, _name));
    }

    // Get person details by index
    function getPerson(uint256 index) public view returns (string memory, uint256) {
        Person memory person = list_of_people[index];
        return (person.name, person.favoriteNumber);
    }
}
```

---

## 6️⃣ Key Solidity Concepts Highlighted

| Concept               | Explanation                                                                                      |
| --------------------- | ------------------------------------------------------------------------------------------------ |
| **memory vs storage** | `memory` = temporary data (only during function execution). `storage` = permanent on blockchain. |
| **push()**            | Adds a new element to a dynamic array.                                                           |
| **public array**      | Auto-generates a getter that returns a single element by index.                                  |
| **Gas Costs**         | Adding to a dynamic array writes to storage → costs gas.                                         |
| **Indexing**          | Arrays start at index 0, so `list_of_people[0]` is the first entry.                              |

---

## 7️⃣ Best Practices

* **Explicit Types**: Always specify bit size for integers (e.g., `uint256`).
* **Avoid Large Loops**: Iterating over large arrays on-chain is gas-heavy.
* **Struct Packing**: Group smaller data types together to save storage.
* **Access Control**: Consider `onlyOwner` modifiers if you want to restrict who can add to the list.

---

## 🧑‍💻 Test Yourself

1. What is the difference between a **dynamic** and **fixed-size** array in Solidity?
2. Why must we use `memory` for the `_name` parameter in the `addPerson` function?
3. How does Solidity automatically provide a getter for `public` arrays and structs?
4. Write a function that returns the total number of people stored.
5. How does gas usage differ when adding vs reading from an array?

---

## ✨ Summary

* **Arrays** let you store ordered collections of a single type.
* **Structs** let you create your own complex types grouping multiple fields.
* Together, they enable mapping **multiple users to their own data** inside a single contract.
* `push()`, visibility (`public`), and `memory` keywords are crucial for dynamic operations.

With these tools, your contract evolves from a simple single-value storage to a **multi-user data registry**.


---
---
---

### Errors, Warnings & Debugging – Summary

* **Errors vs Warnings**

  * **Errors (red):** Stop compilation; must be fixed before deployment (e.g., missing semicolon).
  * **Warnings (yellow):** Code still compiles but highlight risky or poor practices (e.g., missing SPDX license). Fix them to keep code clean.

* **Debugging Workflow**

  * Read the compiler message carefully.
  * Correct the code (e.g., restore missing semicolon or add SPDX license).
  * Recompile until no red or yellow messages remain.

* **Using Resources**

  * **AI tools** (ChatGPT, Phind, Bard) can explain and suggest fixes.
  * **Developer forums** like GitHub Discussions, Stack Exchange Ethereum, and Peeranha provide community help.
  * Phind is an AI-powered search engine that parses results for quick, contextual answers.

* **Key Tip**

  * Great engineers know **where to find answers**, not just how to code.

This lesson teaches how to identify and resolve compiler messages and leverage AI and online communities to debug Solidity smart contracts effectively.
