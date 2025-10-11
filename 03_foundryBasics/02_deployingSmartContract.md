
# ⚡ **Anvil — Local Ethereum Testnet in Foundry**

## 🔹 **What is Anvil?**

**Anvil** is a **local Ethereum testnet node** that comes bundled with **Foundry**.
It allows you to **deploy, test, and interact** with smart contracts locally — perfect for development and debugging.

You can connect your **frontend** or use **RPC calls** to interact with Anvil, just like you would with a real blockchain network.

---

## 🧩 **Starting Anvil**

To launch Anvil, simply open a terminal and run:

```bash
anvil
```

Once started, Anvil will:

* Spin up a **local Ethereum node** running on `127.0.0.1:8545`
* Generate **10 test accounts**
* Fund each with **10,000 ETH**
* Display **addresses and private keys** for all test accounts

Example (simplified):

```
Accounts
========
(0) 0x1234...abcd (10,000 ETH)
(1) 0x5678...efgh (10,000 ETH)
...
Private Keys
============
0xabc123...
0xdef456...
```

---

## 🌐 **Anvil RPC Details**

| Parameter    | Value                                                 |
| ------------ | ----------------------------------------------------- |
| **RPC URL**  | `http://127.0.0.1:8545`                               |
| **Chain ID** | `31337` (default)                                     |
| **Accounts** | 10 test accounts (each funded with 10,000 ETH)        |
| **Purpose**  | Local testing, deployments, and contract interactions |

> 💡 The **RPC URL** (`127.0.0.1:8545`) will be used as your `RPC_URL` parameter when deploying contracts locally.

---

## 🧠 **When to Use Anvil**

Use Anvil whenever you want to:

* Test contract deployment scripts locally.
* Run automated tests via `forge test`.
* Connect your frontend (React/Next.js) to a simulated blockchain.
* Experiment with transactions before deploying to a real testnet (e.g., Sepolia).

---

## 🛑 **Stopping Anvil**

When you’re done testing:

* Press **`Ctrl + C` (Windows/Linux)**
  or
* Press **`Cmd + C` (Mac)**

This cleanly shuts down the Anvil node.

---

## 🔗 **Connecting to MetaMask (Optional Setup)**

To interact with your Anvil node through **MetaMask**:

1. Open **MetaMask → Settings → Networks**

2. Click **Add a Network manually**

3. Enter the following details:

   | Field                  | Value                   |
   | ---------------------- | ----------------------- |
   | **Network Name**       | Localhost (Anvil)       |
   | **New RPC URL**        | `http://127.0.0.1:8545` |
   | **Chain ID**           | `31337`                 |
   | **Currency Symbol**    | ETH                     |
   | **Block Explorer URL** | *(Leave empty)*         |

4. Add a test account from Anvil:

   * Click **Account Selector → Import Account**
   * Paste one of the **private keys** from the Anvil terminal output
   * Click **Import**

> ⚠️ **Security Note:**
> These private keys are public and only for **local testing**.
> Never use them on **mainnet** or any live blockchain.

---

✅ **Summary**

| Feature             | Description                                     |
| ------------------- | ----------------------------------------------- |
| **Purpose**         | Local Ethereum testnet for development          |
| **Default RPC URL** | `http://127.0.0.1:8545`                         |
| **Chain ID**        | `31337`                                         |
| **Accounts**        | 10 test accounts (10,000 ETH each)              |
| **Stop Command**    | `Ctrl/Cmd + C`                                  |
| **Main Use**        | Testing, deploying, debugging contracts locally |

---
---

### RPC URL:
An **RPC URL** is the **endpoint address** your app or wallet uses to **communicate with a blockchain** — it lets you send transactions and fetch data from a specific network (like Anvil, Sepolia, or Mainnet).


---
---
---


---

# 🚀 **1 Deploying to a Local Blockchain (Foundry)**

## ⚙️ **1. Understanding Deployment**

When you deploy a smart contract using Foundry, you must tell it:

1. **Where to deploy** (the blockchain network via its **RPC URL**)
2. **Who is deploying** (the wallet address that signs and pays gas fees)

---

## 🧩 **2. Checking Forge Commands**

To explore Forge’s commands:

```bash
forge --help
```

The one we’ll use for deployment is:

```bash
forge create
```

For its options:

```bash
forge create --help
```

---

## 🧠 **3. Why the First Deployment Fails**

Running:

```bash
forge create SimpleStorage
```

fails because Forge doesn’t know:

* **Which network** to deploy to
* **Which private key** to use for signing

By default, Forge tries `http://localhost:8545`, but no blockchain is running there.

---

## 🌐 **4. Specifying a Network**

Each blockchain (Anvil, Ganache, Sepolia, etc.) has its own **RPC URL** — the endpoint for deployment.

Example with Ganache:

```bash
forge create SimpleStorage --rpc-url http://127.0.0.1:7545
```

This fails again because Forge also needs a **private key** to sign the transaction.

---

## 🔑 **5. Providing a Private Key**

Use the **interactive mode** to enter your key:

```bash
forge create SimpleStorage --rpc-url http://127.0.0.1:7545 --interactive --broadcast
```

Paste a test private key when prompted (you won’t see it as you type).
Forge then deploys the contract successfully 🎉

You can verify this in the **Blocks** or **Transactions** tab of your local blockchain (Ganache or Anvil).

---

## ⚡ **6. Deploying on Anvil**

Now, let’s use **Anvil** — Foundry’s built-in testnet.

### Steps:

1. Clear terminal:

   ```bash
   clear
   ```
2. Start Anvil:

   ```bash
   anvil
   ```
3. Open a new terminal tab
4. Copy one of the **private keys** shown in the Anvil terminal
5. Deploy:

   ```bash
   forge create SimpleStorage --interactive
   ```

   *(No need for `--rpc-url`, Forge auto-detects Anvil)*

Check your Anvil terminal for deployment details like:

```
Transaction: 0x40d2ca8f0d68...
Contract created: 0x5fbdb2315678...
Gas used: 357076
Block Number: 1
```

---

## 🧾 **7. Explicit Deployment Command**

You can also deploy directly without interactive input:

```bash
forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0xac0974be...
```

---

✅ **Summary**

| Step                 | Command                                                          | Purpose                        |
| -------------------- | ---------------------------------------------------------------- | ------------------------------ |
| Check Forge commands | `forge --help`                                                   | View available options         |
| Compile contract     | `forge build`                                                    | Prepare for deployment         |
| Deploy (interactive) | `forge create SimpleStorage --interactive`                       | Deploy locally with manual key |
| Deploy (explicit)    | `forge create SimpleStorage --rpc-url <url> --private-key <key>` | Deploy using given key and RPC |

---

---
---
---

# 🚀 2 Deploying a Smart Contract Locally via Scripts (Anvil + Foundry)

**Why use scripts?**
Scripts make deployment **repeatable, automated, and reliable**, perfect for testing and local development.

---

### 🧱 Step-by-Step

1. **Create a new script file:**
   `script/DeploySimpleStorage.s.sol`

2. **Write the script:**

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity 0.8.19;

   import {Script} from "forge-std/Script.sol";
   import {SimpleStorage} from "../src/SimpleStorage.sol";

   contract DeploySimpleStorage is Script {
       function run() external returns (SimpleStorage) {
           vm.startBroadcast(); // start sending txs to RPC
           SimpleStorage simpleStorage = new SimpleStorage(); // deploy contract
           vm.stopBroadcast(); // stop sending txs
           return simpleStorage;
       }
   }
   ```

---

### ⚙️ Run the Script

* Run without RPC (auto uses Anvil temporarily):

  ```bash
  forge script script/DeploySimpleStorage.s.sol
  ```

  ✅ Simulates deployment on a temporary local chain.

* Run on **your Anvil instance** (real local deployment):

  ```bash
  forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545
  ```

  ⚠️ This is still a **simulation**.

* To **actually deploy**:

  ```bash
  forge script script/DeploySimpleStorage.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key <your-private-key>
  ```

---

### 📁 Result

* Your contract is now **deployed on Anvil**.
* Check details (tx hash, gas, block number) in the **Anvil terminal**.
* Deployment info is stored in the new **`broadcast/`** folder.

---

### 💡 Key Points

* `vm.startBroadcast()` and `vm.stopBroadcast()` define the tx window.
* Without `--broadcast`, the script **simulates**, not deploys.
* Foundry scripts are written in Solidity (`.s.sol`).
* Default RPC = Anvil (`http://127.0.0.1:8545`).

---

