
# 🚀 **Writing Deploy Scripts & Forking Tests in Foundry**

---

## 🧠 **Why Deploy Scripts Are Important**

Until now, we’ve been running tests directly — but we skipped a critical step:
👉 **Deployment scripts**.

Hardcoding addresses (like price feed or aggregator addresses) directly inside contracts is **inflexible**.

For example, in **FundMe.sol** and **PriceConverter.sol**, the following address is hardcoded:

```
0x694AA1769357215DE4FAC081bf1f309aDC325306
```

This address points to **Chainlink’s AggregatorV3** on **Sepolia** — but:

* ❌ It won’t work on **Anvil (local)**
* ❌ It won’t work on **mainnet** or **Arbitrum**

So, how do we make our deployment flexible for **any network**?
➡️ By writing a **Deploy Script**.

---

## ⚙️ **1. Creating the Deploy Script**

Create a new file inside the `script` folder named:

```
DeployFundMe.s.sol
```

> 🧩 The `.s.sol` naming convention stands for **Script Solidity**, used by Foundry to identify deploy scripts.

---

### 📜 **2. Script Boilerplate**

Start your script with the license and pragma:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
```

Then, import the required libraries and contracts:

```solidity
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
```

---

### 🧱 **3. Writing the Deployment Script**

Here’s the basic deployment structure:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    }
}
```

* `vm.startBroadcast()` — starts sending transactions to the network
* `new FundMe()` — deploys the contract
* `vm.stopBroadcast()` — stops broadcasting transactions

---

### ▶️ **4. Running the Script**

Run the deploy script using:

```bash
forge script script/DeployFundMe.s.sol
```

✅ Output: Everything runs smoothly — deployment successful!

---

## 🧩 **5. Types of Tests in Foundry**

As we move forward, it’s important to understand the **four types of tests** used in Foundry.

| Test Type             | Description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| **Unit Tests**        | Test **individual functions** or isolated pieces of logic.                 |
| **Integration Tests** | Test **interactions** between multiple contracts or external systems.      |
| **Forking Tests**     | Run tests on a **forked blockchain** (e.g., a copy of Sepolia or Mainnet). |
| **Staging Tests**     | Run tests on a **staging deployment** before deploying to mainnet.         |

---

## ⚡ **6. The Problem: Version Mismatch in Tests**

We’ll now test our **`getVersion()`** function in the **FundMe** contract.

Add this test in your `FundMeTest.t.sol` file:

```solidity
function testPriceFeedVersionIsAccurate() public {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
}
```

Now, run the test:

```bash
forge test --mt testPriceFeedVersionIsAccurate
```

❌ **It fails!**

---

### 🧾 **Why It Fails**

Our contract references this address:

```
0x694AA1769357215DE4FAC081bf1f309aDC325306
```

That address exists **on Sepolia**, but we’re testing locally on **Anvil** —
so the Aggregator contract doesn’t exist there.

Hence, the call to `getVersion()` **reverts**.

---

## 🧠 **7. The Solution: Forking Tests**

To test against **real contract data**, we can **fork** Sepolia’s blockchain state.

Forking means:

> “Creating a local copy of a live blockchain at a specific block number, so we can test using real data.”

---

### 🧾 **Step-by-Step Forking Setup**

#### 🪶 Step 1 — Create a `.env` file

In your project root:

```
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY_HERE
```

> 🧠 Always ensure `.env` is listed inside your `.gitignore` file (to keep it private).

---

#### ⚙️ Step 2 — Load Environment Variables

In your terminal, run:

```bash
source .env
```

---

#### 🧪 Step 3 — Run Forked Test

Now run your test with a fork of the Sepolia network:

```bash
forge test --mt testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL
```

✅ Output:

```
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testPriceFeedVersionIsAccurate() (gas: 14118)
Suite result: ok. 1 passed; 0 failed
```

🎉 Test passes because we’re now using **Sepolia’s real state**, where the Aggregator contract exists.

---

### ⚠️ **Forking Best Practices**

* Forking uses **Alchemy’s API** (or similar node providers).
* Don’t run all tests on a fork — it’s **slow and expensive**.
* Only fork when necessary (e.g., for Chainlink, Uniswap, oracles, etc.).
* Use `--mt` to **run specific tests** instead of all.

Example:

```bash
forge test --mt testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL
```

---

## 🧮 **8. Coverage — Measuring Test Effectiveness**

Once tests are in place, we need to know **how much of our code is covered** by tests.

Foundry provides **coverage analysis** to help with that.

Run:

```bash
forge coverage --fork-url $SEPOLIA_RPC_URL
```

✅ Output Example:

```
Ran 3 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive()
[PASS] testOwnerIsMsgSender()
[PASS] testPriceFeedVersionIsAccurate()

| File                      | % Lines | % Statements | % Branches | % Funcs |
| ------------------------- | -------- | ------------- | ----------- | ------- |
| script/DeployFundMe.s.sol | 0.00%    | 0.00%         | 100.00%     | 0.00%   |
| src/FundMe.sol            | 21.43%   | 25.00%        | 0.00%       | 33.33%  |
| src/PriceConverter.sol    | 0.00%    | 0.00%         | 100.00%     | 0.00%   |
| **Total**                 | 13.04%   | 14.71%        | 0.00%       | 22.22%  |
```

---

## 📊 **9. Understanding Coverage Results**

| Metric           | Description                                 |
| ---------------- | ------------------------------------------- |
| **% Lines**      | Percentage of code lines executed by tests  |
| **% Statements** | Number of Solidity statements tested        |
| **% Branches**   | Conditional branches (e.g., if/else) tested |
| **% Funcs**      | Percentage of functions covered by tests    |

📉 In our example:

* **Total Coverage:** ~13%
* This is **low** — we need to write more tests for better reliability.

🧩 Ideal target: **70–90%+ coverage**

---

## 🧠 **10. Summary of Commands**

| Action                   | Command                                                |
| ------------------------ | ------------------------------------------------------ |
| Create Deploy Script     | `touch script/DeployFundMe.s.sol`                      |
| Run Deploy Script        | `forge script script/DeployFundMe.s.sol`               |
| Run Specific Test        | `forge test --mt testName`                             |
| Run Forked Test          | `forge test --fork-url $SEPOLIA_RPC_URL`               |
| Run Forked Specific Test | `forge test --mt testName --fork-url $SEPOLIA_RPC_URL` |
| View Coverage            | `forge coverage --fork-url $SEPOLIA_RPC_URL`           |

---

## ✅ **11. Key Takeaways**

* **Deploy scripts** make contract deployment **flexible across networks**.
* **Hardcoded addresses** should always be replaced with dynamic parameters or deployment logic.
* **Forking tests** simulate real network conditions using **Alchemy or Infura RPCs**.
* Use **`.env`** files to store private API keys and RPC URLs.
* **Test coverage** reveals how well your contracts are tested — aim for higher coverage.
* **Efficient testing** means focusing on relevant tests, not running everything every time.

---

## 🎯 **Final Thoughts**

You’ve now learned:

* How to write a **deployment script** with Foundry
* How to run **forked tests** using Sepolia’s real blockchain data
* How to analyze your **test coverage** and improve test reliability

These are essential skills for building, testing, and deploying production-grade smart contracts.

Next up → you’ll learn how to **increase coverage**, test complex interactions, and make your **deployment scripts dynamic** across multiple networks.

---
