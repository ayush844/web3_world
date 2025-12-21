

# Verifiably Random Raffle Smart Contract

## 🎯 What This Section Is About

This section focuses on building a **fully automated, provably random lottery (raffle) smart contract** using **industry best practices**.

✔️ Portfolio-grade project
✔️ Professional code structure
✔️ Real-world tooling (Chainlink VRF & Automation)

> ⚠️ Note: This project is **not deployed on zkSync** due to current integration limitations.

---

## 🧠 Core Concepts Covered (VERY IMPORTANT)

### 🔑 Key Topics

* **Events** (logging on-chain actions)
* **True randomness** (via Chainlink VRF)
* **Automation** (Chainlink Automation)
* **Modular design**
* **Professional Solidity structure**
* **NATSpec documentation**

---

## 🧩 What the Raffle Contract Does

### Functional Requirements

1. Users can **enter the raffle** by paying a ticket fee
2. The **ticket fees accumulate** as the prize pool
3. A **winner is picked automatically**
4. Randomness is **provably fair**
5. No manual intervention needed

---

## 🔗 Chainlink Integrations (High-Level)

### Chainlink VRF v2.5

* Provides **verifiable randomness**
* Prevents manipulation
* Uses `fulfillRandomWords()` to:

  * Select winner
  * Reset raffle

### Chainlink Automation

* Uses:

  * `checkUpkeep`
  * `performUpkeep`
* Automatically triggers the draw at fixed intervals

---

## 🗂️ Project Structure

### Main Contract

```
src/
 └── Raffle.sol
```

### Scripts & Automation

* Advanced scripts inside **Makefile**
* Used to:

  * Create VRF subscriptions
  * Add consumers
  * Deploy contracts

---

## 🚀 Project Setup (Step-by-Step)

### 1️⃣ Create Project Folder

```bash
mkdir foundry-smart-contract-lottery-f23
cd foundry-smart-contract-lottery-f23
code .
```

### 2️⃣ Initialize Foundry

```bash
forge init
```

🧹 Delete all default `Counter` files.

---

## 📝 Project Blueprint (README.md)

```md
# Proveably Random Raffle Contracts

## About
This code creates a provably random smart contract lottery.

## What we want it to do?
1. Users enter by paying for a ticket
2. Winner is drawn automatically after a time interval
3. Chainlink VRF generates randomness
4. Chainlink Automation triggers execution
```

📌 This planning step is **critical** in real projects.

---

## 🧾 Starting the Contract

### Basic Contract Skeleton

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Raffle {}
```

---

## 🧠 NATSpec (Professional Documentation)

### Why NATSpec Matters

* Improves readability
* Helps auditors
* Improves portfolio quality

### Example

```solidity
/**
 * @title A sample Raffle Contract
 * @author Patrick Collins
 * @notice This contract creates a sample raffle
 * @dev Implements Chainlink VRF v2.5 and Chainlink Automation
 */
contract Raffle {}
```

---

## 🏗️ Core Raffle Functions

### Required Functionalities

* Enter raffle
* Pick winner

```solidity
contract Raffle {
    function enterRaffle() public {}
    function pickWinner() public {}
}
```

---

## 💰 Ticket Price Design (IMPORTANT DESIGN DECISION)

### Why `immutable`?

* Set once in constructor
* Cannot change after deployment
* Cheaper than storage variables
* Redeploy to change value

### Implementation

```solidity
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }
```

---

## 🔍 Getter Function (Read-Only Access)

Why?

* Variable is private
* Users still need to know the fee

```solidity
    /** Getter Function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
```

📌 Clean separation of concerns
📌 Read-only, gas-free call

---

## 🧹 Code Cleanliness Tip

```solidity
/** Getter Function */
```

This kind of commenting:

* Improves readability
* Makes contracts easier to audit
* Is considered **professional style**

---

## 📐 Solidity Contract Layout (VERY IMPORTANT)

### File Layout

```solidity
// version
// imports
// errors
// interfaces, libraries, contract
```

---

### Inside Contract

```solidity
// Type declarations
// State variables
// Events
// Modifiers
// Functions
```

---

### Function Order

```solidity
// constructor
// receive
// fallback
// external
// public
// internal
// private
// view & pure
```

📌 Following this layout:

* Improves maintainability
* Makes audits easier
* Is expected in real-world projects

---

## 🧠 Key Takeaways (Revision Gold ✨)

* This is a **real-world production-grade project**
* Chainlink VRF solves on-chain randomness
* Chainlink Automation removes human dependency
* `immutable` is ideal for configurable constants
* NATSpec is **not optional** in professional code
* Planning via README is a best practice
* Contract layout matters

---

## ✅ What Comes Next

In upcoming lessons you’ll:

* Add events
* Implement randomness
* Integrate automation
* Write deployment scripts
* Test edge cases
* Finalize a portfolio-ready contract

---
