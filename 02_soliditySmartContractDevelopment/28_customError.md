

## 🚀 Goal

Further **reduce gas costs** by replacing `require` statements that use expensive string messages.

---

## 🔴 Problem with `require` + String

```solidity
require(msg.sender == i_owner, "Sender is not owner");
```

* Every character of `"Sender is not owner"` is stored on-chain.
* Storing and processing long strings **costs extra gas**.

---

## ✅ Solution: Custom Errors (Solidity ≥ 0.8.4)

### 1️⃣ Declare a Custom Error

Place at the top of the contract (outside functions):

```solidity
error NotOwner();
```

* Acts like a lightweight error “type.”
* No need to store a long message.

### 2️⃣ Use `if` + `revert`

Replace `require` with:

```solidity
if (msg.sender != i_owner) {
    revert NotOwner();
}
```

* `revert` stops execution and refunds remaining gas.
* The EVM logs the error identifier, which is cheaper than a full string.

---

## 🟢 Example: Optimized Withdraw Function

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error NotOwner();

contract FundMe {
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function withdraw() public {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

---

## 💡 Advantages

| Feature                | `require` + string     | Custom Error     |
| ---------------------- | ---------------------- | ---------------- |
| Gas usage              | Higher (stores string) | Lower            |
| Message flexibility    | Custom text            | Encoded selector |
| Introduced in Solidity | Always available       | v0.8.4 and later |

---

## 🧩 Optional: Parameters in Custom Errors

Custom errors can carry data:

```solidity
error NotEnoughFunds(uint256 sent, uint256 required);

if (msg.value < min) {
    revert NotEnoughFunds(msg.value, min);
}
```

* Saves gas compared to concatenating numbers in a string.

---

### 🏁 Summary

* **Why**: Strings in `require` increase deployment & execution cost.
* **What**: Use `error Name()` + `revert Name()` instead.
* **Result**: Cleaner code and cheaper gas, while still giving clear error info to off-chain tools.
