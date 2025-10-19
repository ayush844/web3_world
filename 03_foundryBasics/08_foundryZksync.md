

# ⚙️ Deploying Smart Contracts on zkSync (Layer 2) using Foundry

In this lesson, we’ll explore **Layer 2 deployment on zkSync**, which uses a **different compilation method** compared to Ethereum.

This difference arises because **zkSync uses its own set of opcodes**, which means that while Solidity code looks and behaves similarly, the **low-level bytecode output** (found in the `/out` folder) from regular Foundry is **not fully compatible** with the zkSync VM.

---

## 🧩 Why zkSync Needs a Special Foundry Version

zkSync has its own **modified Foundry toolchain** called **foundry-zksync** — a fork of the official Foundry project.
It includes special compilers and configurations tailored for **zkEVM** deployment.

So to work with zkSync, we’ll use this specialized version temporarily.

---

## 🚀 Steps to Get Started with zkSync in Foundry

### 🧱 Step 1: Install Foundry zkSync

In older versions, we had to **clone** the `foundry-zksync` repository manually.
Now, installation is much easier — we can install it directly using **curl**.

Run this command in your terminal:

```bash
# Install foundry-zksync directly
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

### ⚠️ Important

Installing **foundry-zksync** will **override** your existing Foundry binaries (`forge`, `cast`, etc.).
Don’t worry — we can easily switch back later.

Once installed, verify it by checking the version:

```bash
forge --version
```

If you see a **different version number** (specific to zkSync), that means **foundry-zksync** is installed successfully.

> 🧠 Note:
> This installation requires a **Unix-like environment**, such as:
>
> * macOS
> * Linux
> * Windows with **WSL (Windows Subsystem for Linux)**

---

### 💻 Step 2: Compile Contracts for zkSync

To compile Solidity contracts for zkSync, use the special `--zksync` flag with Forge:

```bash
forge build --zksync
```

This command compiles your contracts in a way that’s **compatible with the zkSync VM**.

> Without this flag, your contracts will compile for **Ethereum (L1)** and won’t work correctly on **zkSync (L2)**.

---

### 🔁 Step 3: Switch Back to Vanilla Foundry (Optional)

Once you’re done deploying on zkSync, you can **switch back** to the normal (Ethereum) Foundry environment.

To toggle between versions:

```bash
# Switch to Foundry zkSync
foundryup-zksync

# Switch back to Vanilla Foundry
foundryup
```

This flexibility allows you to:

* Use **zkSync-compatible Foundry** for Layer 2 work.
* Return to **standard Foundry** for Ethereum or testnet deployments.

---

## 📘 Summary

| Step | Action                         | Command                                                                                                    |
| ---- | ------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| 1    | Install foundry-zksync         | `curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync \| bash` |
| 2    | Compile Solidity for zkSync    | `forge build --zksync`                                                                                     |
| 3    | Switch to zkSync Foundry       | `foundryup-zksync`                                                                                         |
| 4    | Switch back to Vanilla Foundry | `foundryup`                                                                                                |
| 5    | Verify version                 | `forge --version`                                                                                          |

---

### ⚠️ Key Takeaways

* zkSync uses **custom opcodes** → requires **foundry-zksync**.
* Foundry-zksync **temporarily overrides** regular Foundry.
* Always use `--zksync` when building for zkSync.
* You can **easily switch** between zkSync Foundry and Vanilla Foundry anytime.

---
---
---


# ⚙️ Compiling and Deploying Smart Contracts on zkSync (with Foundry)

## 🧠 Compilation Overview

When you run the regular **Foundry build command**:

```bash
forge build
```

Foundry creates an **`/out`** folder in your project root.
This folder contains the **compiled EVM bytecode and metadata** — used for standard Ethereum deployments (Vanilla Foundry).

However, **zkSync uses a different virtual machine (zkEVM)** with **its own opcodes**, so standard EVM builds are not compatible.

---

## 🧩 Compiling for zkSync

To compile your Solidity contracts for the **zkSync Era chain**, use:

```bash
forge build --zksync
```

This command creates a **`/zkout`** folder in your project root, which contains:

* Bytecode and artifacts **compatible with the zkSync VM**
* Proper metadata for zkSync deployments

In short:

| Command                | Output Folder | Compatible With    |
| ---------------------- | ------------- | ------------------ |
| `forge build`          | `/out`        | Ethereum (EVM)     |
| `forge build --zksync` | `/zkout`      | zkSync Era (zkEVM) |

---

## 🔁 Switching Back to Vanilla Foundry

If you need to deploy back on the **Ethereum network**, just revert to the standard Foundry setup:

```bash
foundryup
forge build
```

This resets your environment to use **EVM-compatible binaries**.
Unless otherwise required, it’s best to continue using the **vanilla setup** for Ethereum deployments.

---

# 🧱 Anvil zkSync Update

## 🧩 What is Anvil zkSync?

**Anvil zkSync** is a **local zkSync node**, similar to the regular Anvil chain, but built for zkSync Era.
It lets you deploy and test contracts in a **local zkEVM environment**, without connecting to real testnets.

Recent updates make this setup **much simpler** — now you can run it with **a single command**, provided you have the **latest version of Foundry zkSync** installed.

---

## ⚙️ Installing / Updating Foundry zkSync

If you have an older installation, reinstall the latest version using:

```bash
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

This ensures you have the newest binaries, including **Anvil zkSync**.

---

## 🚀 Starting a Local zkSync Node

Once updated, you can start a local zkSync instance with:

```bash
anvil-zksync
```

This launches a local zkSync node and displays:

* **Pre-funded test accounts** with their private keys
* **L1 and L2 gas prices**
* **Local RPC URL (port number)**

You can use this RPC URL to broadcast transactions to your **local zkSync environment** — just like using `anvil` for Ethereum.

---

### 👀 Important

> This section is **optional**.
> If you face difficulties installing these tools, you can continue testing locally using **Anvil (EVM)** instead.

---

# 🧰 Setting Up a Local zkSync Node (Manually)

If you want to create a **custom local zkSync environment**, you’ll need:

| Tool              | Purpose                            |
| ----------------- | ---------------------------------- |
| **Docker**        | Runs zkSync services locally       |
| **Node.js + npm** | Manages zkSync CLI dependencies    |
| **zksync-cli**    | Controls and launches zkSync nodes |

---

## 🪄 Installation Steps

### 1️⃣ Install & Start Docker

* **macOS** → Open Docker Desktop
* **Linux** →

  ```bash
  sudo systemctl start docker
  ```
* Verify installation:

  ```bash
  docker --version
  docker ps
  ```

---

### 2️⃣ Install Node.js and npm

Follow the official Node.js docs for your OS.
Verify installation:

```bash
node --version
npm --version
```

---

### 3️⃣ Install zkSync CLI

Once Docker and Node.js are ready, install the zkSync CLI:

```bash
npx zksync-cli dev config
```

When prompted:

* Choose **in-memory node** (for quick, temporary setup)
* Skip optional features like portal or explorer (optional)

---

### 4️⃣ Start the Local zkSync Node

```bash
npx zksync-cli dev start
```

This spins up a **Docker-based zkSync node** in the background.
Verify it’s running with:

```bash
docker ps
```

> 🗒️ **Note:**
> If Docker isn’t running, the above command will fail.
> Ensure Docker is active before trying again.

---

## 🧱 Deploying to zkSync Locally

Deployment works similarly to standard Anvil, but with a few changes:

* Use the `--zksync` and `--legacy` flags.
* Avoid `forge script` (not fully supported yet); use `forge create` instead.

Example:

```bash
forge create src/MyContract.sol:MyContract \
--rpc-url http://localhost:8011 \
--zksync \
--legacy \
--private-key <your_private_key>
```

This deploys your contract to the **local zkSync node**.

---

## 🧹 Conclusion

Setting up a **local zkSync node** helps ensure your contracts:

* Compile and run correctly on zkEVM
* Behave the same as they will on testnet or mainnet zkSync

### ✅ Summary

| Step | Action                  | Command                                                                                                    |
| ---- | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| 1    | Update Foundry zkSync   | `curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync \| bash` |
| 2    | Start local zkSync node | `anvil-zksync`                                                                                             |
| 3    | Manual setup (optional) | `npx zksync-cli dev start`                                                                                 |
| 4    | Deploy to zkSync        | `forge create --zksync --legacy`                                                                           |
| 5    | Switch back to EVM      | `foundryup`                                                                                                |

---
---
---


# 🚀 Deploying `SimpleStorage.sol` on a Local zkSync Chain

In this lesson, we’ll deploy the **`SimpleStorage.sol`** smart contract to a **local zkSync chain** using **Foundry zkSync**.

---

## 🧩 Step 1: Verify the Foundry zkSync Version

Before deploying, ensure that you’re using the **correct Foundry zkSync edition**.

Run the following command:

```bash
forge --version
```

If the output shows a version like **`0.2`**, it confirms that you’re running **Foundry zkSync**, not the vanilla Foundry version.
This is essential since vanilla Foundry builds are not compatible with the zkSync VM.

---

## ⚙️ Step 2: Deploy the Contract

Now, deploy your contract using the `forge create` command:

```bash
forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url <RPC_URL> \
--private-key <PRIVATE_KEY> \
--legacy \
--zksync
```

### Parameter Details:

| Parameter                             | Description                                                                      |
| ------------------------------------- | -------------------------------------------------------------------------------- |
| `src/SimpleStorage.sol:SimpleStorage` | Path and contract name to deploy                                                 |
| `--rpc-url`                           | The zkSync node address (e.g. `http://127.0.0.1:8011`)                           |
| `--private-key`                       | The private key of the deploying account *(not recommended directly in command)* |
| `--legacy`                            | Ensures compatibility with simple contracts                                      |
| `--zksync`                            | Compiles and deploys specifically for the zkSync VM                              |

---

### ⚠️ Important Security Note

> 👀 **Never include private keys directly in commands.**
> Instead, store them securely in a `.env` file and reference them using environment variables.

Example:

```bash
PRIVATE_KEY=your_private_key_here
source .env

forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url http://127.0.0.1:8011 \
--private-key $PRIVATE_KEY \
--legacy \
--zksync
```

---

## 📜 Step 3: Deployment Output

After executing the command, Foundry will:

1. **Compile** the `SimpleStorage` contract.
2. **Deploy** it to the local zkSync node.
3. Display the deployment details, including:

   * Deployer address
   * Contract address
   * Transaction hash

✅ Example output:

```
Deployer: 0x1234...abcd
Deployed Contract: 0xabcd...5678
Transaction Hash: 0x9876...dcba
```

---

## ⚙️ Step 4: Using the `--legacy` Flag

* The `--legacy` flag ensures smooth deployment for **simple contracts** (like `SimpleStorage`).
* If you omit it, you may encounter errors such as:

```
failed to serialize transaction
address to address is null
```

These issues usually occur with newer transaction formats or more complex codebases.
Advanced deployment strategies for such contracts will be covered later.

---

## 🧹 Step 5: Wrap Up

Once deployment is complete:

* You can close **Docker Desktop** (if running a local zkSync node).
* Revert your environment to **Vanilla Foundry** for standard Ethereum projects by running:

```bash
foundryup
```

This switches your setup back to the regular Foundry binaries, ensuring compatibility with Ethereum (EVM) networks.

---

## ✅ Summary

| Step | Action                           | Command                                                                                                              |
| ---- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| 1    | Verify Foundry zkSync version    | `forge --version`                                                                                                    |
| 2    | Deploy contract                  | `forge create src/SimpleStorage.sol:SimpleStorage --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --legacy --zksync` |
| 3    | Check output                     | Confirm contract address & tx hash                                                                                   |
| 4    | Use `--legacy` for compatibility | Avoid serialization errors                                                                                           |
| 5    | Switch back to Vanilla Foundry   | `foundryup`                                                                                                          |

---


