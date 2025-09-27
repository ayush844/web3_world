

## 🌐 1. Overview

In Solidity, a contract can send Ether to another address using:

| Method     | Auto-Reverts? | Gas Limit    | Return Value    | Recommended?          |
| ---------- | ------------- | ------------ | --------------- | --------------------- |
| `transfer` | ✅ Yes         | **2300**     | none            | ❌ (not preferred now) |
| `send`     | ❌ No          | **2300**     | `bool`          | ⚠️ Use carefully      |
| `call`     | ❌ No          | **No limit** | `(bool, bytes)` | ✅ **Preferred**       |

---

## 💸 2. `transfer`

**Simplest syntax**, automatically reverts if it fails.

```solidity
payable(msg.sender).transfer(amount);
```

* **Gas limit:** 2300 gas (enough only for a simple “receive” function).
* **Behaviour:** If the recipient’s fallback/receive function needs more gas, it **reverts** the whole transaction.
* **When to use:** Almost never recommended today because complex contracts or future gas-cost changes can break it.

---

## 💸 3. `send`

Same gas limit as `transfer`, but **doesn’t auto-revert**.
Returns a boolean to indicate success.

```solidity
bool success = payable(msg.sender).send(address(this).balance);
require(success, "Send failed");
```

* **Gas limit:** 2300 gas.
* **Behaviour:** Returns `true` or `false`. If `false`, you must handle it yourself (usually with `require`).
* **Use case:** Rare. Only when you deliberately want to handle failures without reverting the whole transaction.

---

## 💸 4. `call`  ✅ Recommended

Most flexible, no fixed gas limit.

```solidity
(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
require(success, "Call failed");
```

* **Gas:** You can forward all remaining gas or set a custom limit.
* **Return:** `(bool success, bytes memory data)`—`data` holds any returned bytes.
* **Why preferred:**

  * Works even if the recipient’s code needs more than 2300 gas.
  * Future-proof against gas-cost changes.
  * Can invoke functions on the recipient if needed.

---

## ⚠️ Security Tips

* Always use the **Checks-Effects-Interactions** pattern:

  1. **Check** conditions (`require`).
  2. **Effects**: update state variables.
  3. **Interactions**: send Ether last.
* Consider using [OpenZeppelin’s `ReentrancyGuard`](https://docs.openzeppelin.com/contracts) when sending funds to prevent re-entrancy attacks.

---

## 🔑 Quick Summary

| Feature        | `transfer`    | `send`  | `call` (recommended)     |
| -------------- | ------------- | ------- | ------------------------ |
| Gas forwarded  | 2300          | 2300    | All / custom             |
| Auto revert    | Yes           | No      | No                       |
| Return value   | None          | `bool`  | `(bool, bytes)`          |
| Best for today | ❌ Legacy only | ⚠️ Rare | ✅ Flexible, future-proof |

> **Rule of thumb:**
> **Use `.call{value: ...}("")` with proper checks for almost all modern ETH transfers.**

---

**Example: Full Withdraw Using `call`**

```solidity
function withdraw() public onlyOwner {
    uint256 amount = address(this).balance;
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require(success, "Withdrawal failed");
}
```

This ensures the owner receives all Ether safely and reliably.
