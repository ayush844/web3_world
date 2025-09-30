
## 🏗 What is a Constructor?

* A **constructor** is a **special function** in Solidity that runs **once** when the contract is deployed.
* It **doesn’t use** the `function` keyword and **cannot be called again**.
* Perfect for setting **initial state**, such as the contract’s **owner**.

### Syntax

```solidity
constructor() {
    // initialization logic
}
```

---

## 🧑‍💼 Assigning the Owner

We store the deployer’s address (the account that deploys the contract) in a state variable:

```solidity
address public owner;

constructor() {
    owner = msg.sender; // msg.sender is the deployer at deployment time
}
```

* `owner` is marked **public** so anyone can read it.
* `msg.sender` inside the constructor equals the **deployer’s address**, captured once at deployment.

---

## 🔒 Securing `withdraw`

Without restrictions, **anyone** could call `withdraw` and empty the contract.
Add a check:

```solidity
function withdraw() public {
    require(msg.sender == owner, "must be owner");
    // code to transfer funds
}
```

* `require` ensures that only the `owner` can proceed.
* If `msg.sender` is not the owner, the call **reverts** with `"must be owner"`.

---

## 📝 Full Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundMe {
    address public owner;

    constructor() {
        owner = msg.sender; // set owner once at deployment
    }

    function withdraw() public {
        require(msg.sender == owner, "must be owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {} // allow contract to receive ETH
}
```

---

## ⚡ Key Points

* **One Transaction:** Setting the owner in the constructor happens during deployment—no extra transaction needed.
* **Immutable Ownership:** The `owner` address stays fixed unless you explicitly add a function to change it.
* **Security:** Prevents unauthorized withdrawals.

---

✅ **Summary:**
Use a **constructor** to set `owner = msg.sender` when deploying the contract, and add `require(msg.sender == owner)` inside `withdraw`. This guarantees that **only the deployer** can withdraw funds, protecting the contract from unauthorized access.
