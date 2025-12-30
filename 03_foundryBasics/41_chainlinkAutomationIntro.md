

## 🔗 Chainlink Automation — Simple Notes

![Image](https://docs.chain.link/images/automation/auto-ui-home.png)

![Image](https://cdn.prod.website-files.com/5f6b7190899f41fb70882d08/6519f511437a1b792537e5cf_Automation%202.0%20Diagram_V3.webp)

![Image](https://blog.chain.link/wp-content/uploads/2022/06/unnamed-2-2.png)

---

## 1️⃣ Why Do We Need Chainlink Automation?

### ❌ Problem

* A smart contract function like `pickWinner()` or `count()` **needs someone to call it**
* Calling it **manually every day or every few minutes is not practical**
* Smart contracts **cannot run by themselves**

### ✅ Solution

👉 **Chainlink Automation** automatically calls smart contract functions **for us**, without trust and without manual work.

---

## 2️⃣ What is Chainlink Automation?

**Chainlink Automation** is a **decentralized service** that:

* Automatically executes smart contract functions
* Works based on **time** or **conditions**
* Is **trustless**, **reliable**, and **secure**
* Replaces manual calling or centralized bots

📌 Earlier it was called **Chainlink Keepers**

---

## 3️⃣ What Are We Building in This Lesson?

* A **simple counter contract**
* Chainlink Automation will:

  * Call a function
  * **Every fixed time interval**
  * Without any human interaction

---

## 4️⃣ Smart Contract Used (Very Simple)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Counter {

    uint256 public counter;

    constructor() {
        counter = 0;
    }

    function count() external {
        counter = counter + 1;
    }
}
```

### 🔍 What This Contract Does

* `counter` → stores a number
* `count()` → increases the number by **1**
* No automation code needed inside the contract ❗

👉 Chainlink Automation will call `count()` externally

---

## 5️⃣ Deploying the Contract

* Deploy on **Sepolia Testnet**
  (or **Fuji Avalanche** if you’re confident)
* After deployment:

  * Click `counter` → should be **0**
  * Click `count()` → sign transaction
  * Click `counter` again → **1**

✔️ Contract works correctly

---

## 6️⃣ Registering Automation (Upkeep)

### Step-by-step:

1. Open **Chainlink Automation UI**
2. Click **Register New Upkeep**
3. Connect wallet
4. Choose **Time-based trigger**

---

## 7️⃣ Providing Contract Details

### 🔹 Contract Address

* Paste the deployed contract address

### 🔹 ABI (Important!)

* Go to **Remix**
* Open **Solidity Compiler**
* Click **ABI**
* Paste it into the Automation UI

📌 ABI tells Chainlink **how to call the contract**

---

## 8️⃣ Selecting the Function

* From dropdown, select:

  * `count()` ✅
* This is the function Chainlink will call automatically

---

## 9️⃣ Time Schedule (CRON Expression)

### 🔹 What is a CRON Expression?

A **short way to define time schedules**

Format:

```
* * * * *
│ │ │ │ │
│ │ │ │ └── Day of week (0–6)
│ │ │ │ └── Month (1–12)
│ │ │ └── Day (1–31)
│ │ └── Hour (0–23)
└── Minute (0–59)
```

### Example Used:

```
*/2 * * * *
```

📌 Means: **Every 2 minutes**

✔️ Chainlink will call `count()` every 2 minutes automatically

---

## 🔟 Upkeep Details

Fill in:

* **Name** → Anything you like
* **Admin Address** → Your wallet (default)
* **Starting Balance** → e.g. `10 LINK`
* **Gas Limit** → Default is fine

👉 No project name or email required

---

## 1️⃣1️⃣ Register & Confirm

* Click **Register Upkeep**
* Sign all transactions (usually 2–3)
* Click **View Upkeep**

---

## 1️⃣2️⃣ Monitoring Automation

### In Upkeep Dashboard:

* **History tab** shows:

  * Execution time
  * Transaction hash
* Ensure:

  * LINK balance stays **above minimum**

### In Remix:

* Click `counter`
* You’ll see the value increasing automatically 🎉

---

## 1️⃣3️⃣ Managing the Upkeep

Using **Actions** button, you can:

* Fund upkeep
* Change time interval
* Change gas limit
* Pause or cancel upkeep

📌 Always pause/cancel when done to save LINK

---

## 🔑 Key Points to Remember (Exam Ready)

* Smart contracts **cannot self-execute**
* **Chainlink Automation** triggers functions automatically
* Works on **time-based or condition-based logic**
* Uses **Upkeeps**
* Needs:

  * Contract address
  * ABI
  * Function name
  * Cron schedule
* Fully **decentralized** (no single point of failure)

---

## 🧠 One-Line Summary

> **Chainlink Automation automatically calls smart contract functions at fixed times or conditions without manual intervention.**
