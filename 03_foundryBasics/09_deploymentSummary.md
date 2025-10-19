
# ⚡ zkSync Deployment Cheatsheet (Foundry Edition)

### 🧠 Overview

zkSync is a **Layer 2 (L2) rollup** that uses **Zero-Knowledge Proofs (ZKPs)** to offer **faster and cheaper** Ethereum-compatible transactions.
Deploying on zkSync requires a **modified Foundry** toolchain: `foundry-zksync`.

---

## 🧱 1. Installation & Setup

### 🛠️ Install Foundry zkSync

```bash
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

### ⚙️ Verify Installation

```bash
forge --version
```

> If version shows **0.2** → You’re on **Foundry zkSync**.

---

## 🧩 2. Building Contracts

### 🧱 Build for Ethereum (EVM)

```bash
forge build
```

Creates `/out` folder → standard EVM output.

### ⚡ Build for zkSync

```bash
forge build --zksync
```

Creates `/zkout` folder → zkSync-compatible bytecode.

---

## 🔁 3. Switching Environments

| Action                         | Command            |
| ------------------------------ | ------------------ |
| Switch to zkSync Foundry       | `foundryup-zksync` |
| Switch back to Vanilla Foundry | `foundryup`        |

---

## 🧰 4. Local zkSync Node (Anvil zkSync)

### ▶️ Start Local zkSync Node

```bash
anvil-zksync
```

Displays:

* Pre-funded test accounts
* Private keys
* Local RPC (e.g., `http://127.0.0.1:8011`)

### ✅ Update to Latest Foundry zkSync (if needed)

```bash
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

---

## 🐳 5. Manual Local Setup (Optional)

If `anvil-zksync` doesn’t run, you can create a local zkSync node manually.

### Install Requirements:

```bash
# Check Docker
docker --version

# Check Node.js and npm
node --version
npm --version
```

### Install zkSync CLI:

```bash
npx zksync-cli dev config
```

Choose:

* **In-memory node** (for quick testing)
* Skip portal/explorer (optional)

### Start zkSync Node:

```bash
npx zksync-cli dev start
```

Verify it’s running:

```bash
docker ps
```

---

## 🚀 6. Deploying to zkSync

### 🧩 Deploy `SimpleStorage.sol`

```bash
forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url http://127.0.0.1:8011 \
--private-key <PRIVATE_KEY> \
--legacy \
--zksync
```

> ⚠️ **Never include private keys directly.**
> Instead, store in `.env`:

```bash
PRIVATE_KEY=your_private_key
source .env
forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url http://127.0.0.1:8011 \
--private-key $PRIVATE_KEY \
--legacy \
--zksync
```

---

## 🪄 7. Common Flags & Notes

| Flag            | Meaning                                                         |
| --------------- | --------------------------------------------------------------- |
| `--zksync`      | Compiles & deploys for zkSync VM                                |
| `--legacy`      | Uses legacy transaction type (recommended for simple contracts) |
| `--rpc-url`     | RPC endpoint (local or testnet)                                 |
| `--private-key` | Account used for deployment                                     |
| `--broadcast`   | (for scripts) Sends transaction to network                      |

---

## 🧹 8. Cleanup & Switch Back

After testing on zkSync:

```bash
foundryup
```

Reverts your environment to **Vanilla Foundry** for Ethereum or testnet deployments.

---

## 🧾 9. Quick Command Summary

| Action                         | Command                                                                                                    |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| Install Foundry zkSync         | `curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync \| bash` |
| Build for zkSync               | `forge build --zksync`                                                                                     |
| Start zkSync Node              | `anvil-zksync`                                                                                             |
| Deploy Contract                | `forge create ... --legacy --zksync`                                                                       |
| Switch to zkSync Foundry       | `foundryup-zksync`                                                                                         |
| Switch back to Vanilla Foundry | `foundryup`                                                                                                |

---

## ✅ Tips & Best Practices

* 💡 Always **verify version** before building or deploying.
* 🔐 Keep private keys in **.env files**, never in plain commands.
* ⚙️ For complex contracts, you may need **custom compiler flags** (covered later).
* 🧾 Use **`--legacy`** for stable deployments on zkSync Era.
* 🧱 Test on **Anvil zkSync** before deploying to main/testnet.

---

### 📘 Example Workflow Summary

```bash
# 1. Install zkSync Foundry
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash

# 2. Verify version
forge --version

# 3. Build zkSync contract
forge build --zksync

# 4. Start local zkSync node
anvil-zksync

# 5. Deploy contract
source .env
forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url http://127.0.0.1:8011 \
--private-key $PRIVATE_KEY \
--legacy \
--zksync

# 6. Revert to Vanilla Foundry
foundryup
```

---
