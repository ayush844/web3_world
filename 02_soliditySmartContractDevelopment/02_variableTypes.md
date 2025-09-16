
## **Solidity Data Types**

Solidity provides **elementary types** (basic building blocks) that you can combine into more complex types such as arrays, mappings, and structs.

### 🟢 1. Boolean (`bool`)

* Holds `true` or `false`.
* Default value: `false`.

```solidity
bool hasFavoriteNumber = true;
```

---

### 🟢 2. Unsigned Integer (`uint`)

* Whole numbers **≥ 0** (no negatives).
* `uint` is shorthand for `uint256` (256-bit).
* You can specify size: `uint8`, `uint16`, … up to `uint256`.
* Default value: `0`.

```solidity
uint256 favoriteNumber = 88;
```

---

### 🟢 3. Signed Integer (`int`)

* Whole numbers that can be **positive or negative**.
* Similar sizing options: `int8` … `int256` (default is `int256`).
* Default value: `0`.

```solidity
int256 favoriteInt = -88;
```

---

### 🟢 4. Address (`address`)

* Stores a **20-byte Ethereum address** (e.g. a wallet or contract).
* Used to send/receive Ether or interact with other contracts.

```solidity
address myAddress = 0xaB1B7206AA6840C795aB7A6AE8b15417b7E63a8d;
```

* Two forms:

  * `address` – basic
  * `address payable` – can receive Ether via `.transfer()` or `.send()`.

---

### 🟢 5. Bytes

* **Raw binary data**.
* Fixed-size: `bytes1` … `bytes32`
* Dynamic: `bytes` (resizable)

```solidity
bytes32 favoriteBytes32 = "cat"; // fixed 32 bytes
bytes dynamicBytes = "hello";    // dynamic array of bytes
```

* Use **fixed bytes** for cheaper storage if size is known.

---

### 🟢 6. String (`string`)

* Text data; internally a dynamic `bytes` array, but with string-specific operations.

```solidity
string favoriteNumberInText = "eighty-eight";
```

* Convert to bytes if you need low-level manipulation.

---

## Variables & Defaults

* A **variable** is a named storage location for a value.
* Each variable type has a **default**:

  * `uint`/`int` → `0`
  * `bool` → `false`
  * `address` → `0x000...0`
  * `string`/`bytes` → empty
* End every statement with a semicolon `;`.

---

### Example Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    bool hasFavoriteNumber = true;
    uint256 favoriteNumber = 88;
    string favoriteNumberInText = "eighty-eight";
    int256 favoriteInt = -88;
    address myAddress = 0xaB1B7206AA6840C795aB7A6AE8b15417b7E63a8d;
    bytes32 favoriteBytes32 = "cat";
}
```

---

## Extra Tips

* **Be explicit**: Always specify bit sizes (`uint256` instead of `uint`) for clarity and consistency.
* **Gas Efficiency**: Smaller integer sizes (e.g., `uint8`) don’t always save gas unless tightly packed in a struct.
* **Storage vs. Memory**:

  * `storage` → permanent on blockchain (default for state variables).
  * `memory` → temporary, exists only during a function call.

---

### **Key Takeaways**

* **Bool, uint/int, address, bytes, string** are the core building blocks.
* Explicit sizes improve readability and help avoid unexpected compiler defaults.
* Strings are dynamic bytes, but bytes can also be fixed for efficiency.
* Understanding defaults prevents unexpected zero values in uninitialized variables.

---
