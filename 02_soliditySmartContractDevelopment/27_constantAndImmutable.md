
## ⚡ Why Optimize Gas?

* **Gas** = fee paid for every transaction or contract deployment.
* Reducing gas lowers **deployment cost** and **function execution cost**.
* In the `FundMe` contract, variables like:

  * `owner` – set only once at deployment
  * `minimumUSD` – set once at compile time
    never change, so they can be optimized.

---

## 🔍 Baseline

* Original deployment cost: **~859,000 gas** (observed when deploying).
* Goal: Reduce cost by optimizing variables that don’t change.

---

## ✅ `constant`

* **Use when:** Value is **known at compile time** and never changes.
* **Effect:**

  * Stored directly in the contract bytecode (not in storage).
  * Cheaper & faster to read (no storage slot).
  * Saves ~**19,000 gas** on deployment.

### Syntax & Convention

```solidity
uint256 public constant MINIMUM_USD = 5;
```

* **Naming:** ALL_CAPS with underscores.

---

## 🕒 `immutable`

* **Use when:** Value is **known only at deployment time** (not at compile time) but still never changes.
* **Effect:** Similar gas savings to `constant`.

### Syntax & Convention

```solidity
address public immutable i_owner;

constructor() {
    i_owner = msg.sender;  // set once at deployment
}
```

* **Naming:** Prefix with `i_` to indicate immutable.

---

## 🧮 Example: Optimized FundMe

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    uint256 public constant MINIMUM_USD = 5;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == i_owner, "Not owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

---

## 💡 Key Takeaways

| Keyword       | Set When?       | Gas Savings | Storage Slot? | Naming   |
| ------------- | --------------- | ----------- | ------------- | -------- |
| **constant**  | Compile time    | High        | ❌ No          | ALL_CAPS |
| **immutable** | Deployment time | High        | ❌ No          | i_prefix |

---

### ⚠️ Notes

* If ETH = $3000, saving 19,000 gas ≈ **$9** at current gas prices.
* **Don’t over-optimize early**—clarity and correctness matter more in beginner projects.

---

**🚀 Summary:**
Use **`constant`** for compile-time fixed values and **`immutable`** for deployment-time fixed values. Both reduce gas by avoiding storage writes and reads, making your contracts cheaper and more efficient.
