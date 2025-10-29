

# ⚙️ Introduction

There are notable differences between the **Ethereum Virtual Machine (EVM)** and the **ZKsync Era Virtual Machine (ZKsync VM)**, as detailed in the official ZKsync documentation.

In this lesson, we’ll explore some **DevOps tools** designed to help developers run and manage **tests and functions across both VMs** efficiently.

---

# 🧰 foundry-devops Tools

In the `FundMeTest.t.sol` file, certain tests that run on **Vanilla Foundry (EVM)** may not work on **ZKsync Foundry**, and vice versa.

To handle these differences, we use two packages from the **foundry-devops** repository:

```solidity
import { ZkSyncChainChecker } from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import { FoundryZkSyncChecker } from "lib/foundry-devops/src/FoundryZkSyncChecker.sol";
```

These packages help you **conditionally run tests or functions** based on whether the code is being executed on the **ZKsync VM** or **standard Foundry (EVM)**.

---

# ⚙️ Setting Up ZkSyncDevOps

### 📄 File Setup

Create a new test file:

```
test/unit/ZkSyncDevOps.t.sol
```

This file will demonstrate how certain tests:

* May **fail on ZKsync VM** but **pass on EVM**, or
* **Pass on both** depending on modifiers used.

You can copy the content from the official **foundry-devops GitHub repository** into your project’s `test/unit` directory.

---

### 🧩 Installing Dependencies

Run the following command to install the **foundry-devops** package:

```bash
forge install cyfrin/foundry-devops@0.2.2 --no-commit
```

---

### 🔄 Reset Your Modules

If you encounter issues with your Git submodules, you can reset them using either of the following methods:

#### Option 1 — Manual reset:

```bash
rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"
```

#### Option 2 — Using Makefile:

```bash
make rm
```

---

### 🧾 Update `.gitignore`

Add the following entries to your `.gitignore` file:

```
.DS_store
zkout/
```

---

# 🧠 VM Environment Modifiers

You can **switch environments** between:

* `foundryup` → for **Vanilla Foundry (EVM)**
* `foundryup-zksync` → for **ZKsync Foundry (ZK VM)**

to observe different test behaviors in the same codebase.

---

### 🧪 Example Command

```bash
forge test --mt testZkSyncChainFails -vvv
```

This test will **pass** in both environments, but if you **remove the `skipZkSync` modifier**, it will **fail on ZKsync** because that specific function is not supported on the ZKsync chain.

---

### ⚙️ Modifiers Overview

| Modifier     | Behavior                            |
| ------------ | ----------------------------------- |
| `skipZkSync` | Skips test execution on ZKsync VM   |
| `onlyZkSync` | Runs the test **only** on ZKsync VM |

📖 For more details, refer to the **foundry-devops** repository.

---

# 🧩 Foundry Version Modifiers

Some tests may behave differently depending on the **Foundry version** you are using.
The `FoundryZkSyncChecker` package helps manage such cases by providing version-based modifiers.

### 🔸 Common Modifiers

| Modifier             | Description                                                                   |
| -------------------- | ----------------------------------------------------------------------------- |
| `onlyFoundryZkSync`  | Runs only if the **ZKsync version** of Foundry (`foundryup-zksync`) is active |
| `onlyVanillaFoundry` | Runs only if the **standard EVM version** of Foundry (`foundryup`) is active  |

---

# ⚠️ Important Note

🗒️ **Ensure FFI is enabled** in your `foundry.toml` file.
This allows Foundry to interact with the system for specific operations.

```toml
ffi = true
```

---

# ✅ Summary

| Concept                                    | Description                                          |
| ------------------------------------------ | ---------------------------------------------------- |
| **ZkSyncChainChecker**                     | Helps determine if the test is running on ZKsync     |
| **FoundryZkSyncChecker**                   | Manages version-based conditions for Foundry         |
| **skipZkSync / onlyZkSync**                | Modifiers to control test execution per environment  |
| **onlyFoundryZkSync / onlyVanillaFoundry** | Modifiers to control tests per Foundry version       |
| **ffi = true**                             | Must be enabled for foundry-devops tools to function |

---

> 💡 **Tip:**
> Switch between environments (`foundryup` and `foundryup-zksync`) often while testing to understand which parts of your smart contract behave differently on the ZKsync VM vs. the standard EVM.

---
