
# 🎟️ Implementing the `entranceFee` (Raffle Contract)

## 🎯 Goal of This Step

Ensure that:

* A user **must pay enough ETH** to enter the raffle
* The contract **reverts safely and efficiently** if they don’t

---

## 🧠 Key Concept: `msg.value`

* `msg.value` = amount of ETH (in wei) sent with the transaction
* Since users must pay to enter, the function **must be `payable`**

---

## 🧩 Initial Implementation (Using `require`)

```solidity
function enterRaffle() external payable {
    require(msg.value >= i_entranceFee, "Not enough ETH sent");
}
```

### Why This Works

* Checks if user sent enough ETH
* Reverts transaction if condition fails
* Refunds gas (minus base cost)
* Undoes all state changes

---

## 🔍 Why `external` Instead of `public`

| Visibility | Reason                                        |
| ---------- | --------------------------------------------- |
| `external` | More gas efficient when not called internally |
| `public`   | Allows internal calls (not needed here)       |

📌 Best practice:

> Use `external` when the function is only called from outside the contract.

---

## ⚠️ Problem With `require` + String

* Strings are:

  * Expensive to deploy
  * Expensive at runtime
* Poor for large protocols

---

## 🚀 Solidity 0.8.4+ Improvement: Custom Errors

### What Are Custom Errors?

Custom errors are:

* Typed revert reasons
* ABI-encoded
* Much cheaper than strings

```solidity
error Raffle__NotEnoughEthSent();
```

---

## 🧱 Contract Layout (Applied Correctly)

Custom errors go **before the contract declaration**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error Raffle__NotEnoughEthSent();

contract Raffle {
    ...
}
```

📌 This respects Solidity’s recommended layout.

---

## 🔄 Refactored `enterRaffle` (Best Practice)

```solidity
function enterRaffle() external payable {
    if (msg.value < i_entranceFee) {
        revert Raffle__NotEnoughEthSent();
    }
}
```

### Or (Single-Line Style)

```solidity
function enterRaffle() external payable {
    if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
}
```

✔️ Both versions are **functionally identical**
✔️ Choice is purely stylistic

---

## 🏷️ Why Prefix Errors With `Raffle__`

### Problem Without Prefix

In large protocols:

* 20+ contracts
* Many custom errors
* Debugging becomes painful

### Solution

```solidity
error Raffle__NotEnoughEthSent();
```

📌 Benefits:

* Immediately know **which contract failed**
* Faster debugging
* Professional-grade practice

---

## ⚖️ `require` vs Custom Errors (VERY IMPORTANT)

| Method                      | Gas       | Recommended |
| --------------------------- | --------- | ----------- |
| `require(cond, "string")`   | ❌ High    | ❌ No        |
| `require(cond)`             | ⚠️ Medium | ⚠️ Rare     |
| `if + revert CustomError()` | ✅ Lowest  | ✅ YES       |

---

## 🧠 Mental Model (Remember This)

> **Use `require` for quick demos and learning**
> **Use custom errors for production contracts**

---

## 📌 Final Clean Version (Production-Ready)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error Raffle__NotEnoughEthSent();

contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
    }
}
```

---

## 🏁 Key Takeaways (Revision Gold ✨)

* `msg.value` checks ETH sent
* `external` is gas-efficient for user-only calls
* `require` with strings is costly
* Custom errors are cheaper and cleaner
* Prefixing errors avoids debugging hell
* Single-line `if` is a style choice

---
