

# ⚙️ Transaction Types in EVM and zkSync VM

## 🧠 Introduction

In this lesson, we’ll explore the **different transaction types** supported by the **Ethereum Virtual Machine (EVM)** and the **zkSync Virtual Machine (zkVM)**.

Each blockchain transaction type defines **how data is structured and processed** — and new types are introduced through **Ethereum Improvement Proposals (EIPs)** as the ecosystem evolves.

---

## 🗂️ The `/broadcast` Folder

Whenever you **deploy a contract** (using Foundry), a **`/broadcast`** folder is created in your project directory.
This folder stores **deployment data** and **transaction metadata** — making it easier to inspect what happened during deployment.

### Inside the `/broadcast` Folder:

* Each **subfolder** is named after the **chain ID** you deployed to.
  For example:

  * `260` → zkSync local chain
  * `31337` → Anvil (local EVM chain)
* Each of these contains a file named:

  ```
  run-latest.json
  ```

  which records **detailed transaction data** such as:

  * Transaction hash
  * Gas used
  * Nonce
  * Transaction **type** (e.g., `0x0`, `0x2`, `0x71`)

---

## 🔍 Example: Comparing EVM and zkSync Transaction Types

When you inspect the **`run-latest.json`** files for both chains, you’ll notice:

| Environment                      | Transaction Type | Description                   |
| -------------------------------- | ---------------- | ----------------------------- |
| **Anvil (EVM)**                  | `0x2`            | Default EIP-1559 transaction  |
| **zkSync**                       | `0x0`            | Legacy-style transaction      |
| **zkSync (Account Abstraction)** | `0x71`           | zkSync’s own transaction type |

### 💡 Why the Difference?

* In **EVM (Anvil)**, the **default transaction type** is **`0x2`** (EIP-1559).
* In **zkSync**, the **default** is **`0x0`** (legacy) unless otherwise specified.
* If you add the `--legacy` flag during deployment in Foundry, your transactions will use **type 0x0** even on EVM chains.

Example:

```bash
forge create src/SimpleStorage.sol:SimpleStorage \
--rpc-url <RPC_URL> \
--private-key <PRIVATE_KEY> \
--zksync \
--legacy
```

→ Forces the transaction to use **type 0x0**.

Without `--legacy`, Foundry will default to **type 0x2** (EIP-1559 style).

---

## 🧩 Ethereum Transaction Types (EVM Overview)

Ethereum has evolved through several **transaction formats**, each introduced by an **EIP** to improve functionality and efficiency.

| Type       | Hex   | EIP                                                 | Name                    | Description                                                                                                                                    |
| ---------- | ----- | --------------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Type 0** | `0x0` | —                                                   | Legacy Transaction      | The original transaction format (pre-EIP-2718). Uses fixed gas price (no base/priority fee separation).                                        |
| **Type 1** | `0x1` | [EIP-2930](https://eips.ethereum.org/EIPS/eip-2930) | Access List Transaction | Introduced the **access list** for better gas efficiency when accessing multiple storage slots.                                                |
| **Type 2** | `0x2` | [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559) | Dynamic Fee Transaction | Introduced **base fee + priority fee**, making gas fees more predictable. This is the **current default type** in Ethereum.                    |
| **Type 3** | `0x3` | [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) | Blob Transaction        | Used in **Proto-Danksharding** (a.k.a. **“blob” transactions**) to reduce L2 data costs. It’s the foundation for **Danksharding** scalability. |

---

## 🔮 zkSync-Specific Transaction Types

zkSync introduces **its own unique transaction types**, optimized for zkEVM and account abstraction.

| Type                         | Hex    | Description                                                                                      |
| ---------------------------- | ------ | ------------------------------------------------------------------------------------------------ |
| **Legacy (Type 0)**          | `0x0`  | Default transaction type for simple contract deployments.                                        |
| **zkSync Custom (Type 113)** | `0x71` | Used for advanced zkSync transactions, such as **account abstraction** and **batch operations**. |

zkSync’s **type 113 (0x71)** transactions enable **native account abstraction**, allowing features like:

* Smart contract wallets with built-in logic
* Custom transaction validation
* Meta-transactions (gasless transactions)

---

## ⚠️ Important Notes

* 🧩 **Default EVM transaction type:** `0x2` (EIP-1559)
* ⚙️ **Default zkSync transaction type:** `0x0` (Legacy)
* 🧠 zkSync’s **custom type 0x71** is for **advanced features** like account abstraction
* 🧰 The **`--legacy` flag** forces Foundry to use transaction type `0x0`

---

## 💡 Tip: Foundry Scripting & zkSync

While you can use:

```bash
forge script
```

for EVM deployments,
it’s **not fully supported** on zkSync yet.

For zkSync, prefer:

```bash
forge create
```

The `forge script` command may work in some cases but can fail unexpectedly — so for consistency, assume scripting is **not supported** when working with zkSync.

---

## 📚 References

* [zkSync Documentation – Transaction Types](https://docs.zksync.io/)
* [Cyfrin Blog – EIP-4844 and Blob Transactions](https://cyfrin.io/)
* [Ethereum EIPs Overview](https://eips.ethereum.org/)

---

## 🧾 Summary

| Chain                          | Default Tx Type  | Flag to Change     | Example Command           |
| ------------------------------ | ---------------- | ------------------ | ------------------------- |
| **Anvil (EVM)**                | `0x2` (EIP-1559) | `--legacy` → `0x0` | `forge create --legacy`   |
| **zkSync Local**               | `0x0` (Legacy)   | N/A                | `forge create --zksync`   |
| **zkSync Account Abstraction** | `0x71`           | Auto-applied       | Used internally by zkSync |

---

## ✅ Key Takeaways

* Transactions differ between **EVM** and **zkSync VM**.
* **/broadcast folder** logs each deployment with detailed transaction data.
* **Transaction type = 0x2** → default for modern EVM (EIP-1559).
* **Transaction type = 0x0** → legacy format (used by zkSync by default).
* **Transaction type = 0x71** → zkSync-specific, used for account abstraction.
* Always use `forge create --legacy --zksync` for stable zkSync deployments.
* `forge script` is **not fully reliable** on zkSync yet.

---

