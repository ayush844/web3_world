
# 🧱 **Foundry Fundamentals — Notes**

## 🔹 Introduction

**Foundry** is a modern, fast, and modular framework for **smart contract development**.
It allows developers to **build, test, deploy, and interact with smart contracts** directly from the command line or via Solidity scripts.

> 💡 **Quote from the Foundry Book:**
> “Foundry manages your dependencies, compiles your project, runs tests, deploys, and lets you interact with the chain from the command line and via Solidity scripts.”

---

## ⚙️ **What is Foundry?**

### ✅ **Key Features**

* **Fast Compilation:**
  Foundry leverages **Rust** for compilation — much faster than Hardhat or Brownie.
* **Solidity-Based:**
  Entirely built around **Solidity**, so no need to learn another language.
* **Comprehensive Documentation:**
  The **Foundry Book** serves as a complete guide for all Foundry-related topics.

📚 **Bookmark:** [Foundry Book](https://book.getfoundry.sh) — your go-to resource for commands, troubleshooting, and references.

---

## 💻 **Installing Foundry**

### 🔸 **Step 1: Run Installation Command**

In your terminal, execute:

```bash
curl -L https://foundry.paradigm.xyz | bash
```

> ⚠️ Ensure you have an **active Internet connection** — this downloads Foundry from its official source.

---

### 🔸 **Step 2: Verify Installation**

After running the command, you’ll see an output like:

```
Detected your preferred shell is bashrc and added Foundry to Path
Run: source /home/user/.bashrc
Start a new terminal session to use Foundry
```

This means Foundry has been added to your system path.

---

### 🔸 **Step 3: Install and Update Foundry**

Run:

```bash
foundryup
```

This installs and updates Foundry to the latest version.

---

## 🧩 **Core Components Installed**

| Component  | Description                                                                                |
| ---------- | ------------------------------------------------------------------------------------------ |
| **Forge**  | The main tool for building, testing, and deploying smart contracts.                        |
| **Cast**   | Used for interacting with blockchains (e.g., sending transactions, querying data).         |
| **Anvil**  | A local Ethereum node for development and testing (similar to Hardhat Network or Ganache). |
| **Chisel** | A Solidity REPL (interactive coding environment) for quick experimentation.                |

✅ Verify installation:

```bash
forge --version
```

Expected output:

```
Forge version x.x.x
```

---

## 🧠 **Troubleshooting Installation Issues**

### ❌ **Case 1: “foundryup not running”**

* Possible reason: Foundry isn’t properly added to your PATH.
* Solution: Manually **add Foundry to PATH** or re-run the **source** command provided during installation.

Example:

```bash
source /home/user/.bashrc
```

---

### ❌ **Case 2: “Forge command not found”**

If you see:

```
Forge command not found
```

It means your terminal hasn’t loaded the Foundry environment variables.

**Fix:**

1. Re-run:

   ```bash
   source /home/user/.bashrc
   ```
2. If that doesn’t work, ensure your bash profile loads `bashrc` automatically:

   ```bash
   cd ~
   echo 'source /home/user/.bashrc' >> ~/.bash_profile
   ```
3. Restart the terminal and try again:

   ```bash
   forge --version
   ```

---

## 🗒️ **Additional Tips**

* **To update Foundry anytime:**

  ```bash
  foundryup
  ```
* **To remove or hide terminal in VS Code:**

  * 🗑️ **Trash icon** → permanently removes terminal session.
  * ❌ **X icon** → just hides the terminal window.
* **Always refer to the official documentation** for OS-specific instructions and troubleshooting.

---

## 🧩 **Quick Summary**

| Concept             | Description                                                           |       |
| ------------------- | --------------------------------------------------------------------- | ----- |
| **Purpose**         | Framework for smart contract development                              |       |
| **Language**        | 100% Solidity                                                         |       |
| **Core Tools**      | Forge, Cast, Anvil, Chisel                                            |       |
| **Performance**     | Faster builds via Rust                                                |       |
| **Docs**            | [Foundry Book](https://book.getfoundry.sh)                            |       |
| **Install Command** | `curl -L [https://foundry.paradigm.xyz](https://foundry.paradigm.xyz) | bash` |
| **Update Command**  | `foundryup`                                                           |       |

---

## 💬 **Common Interview / Exam Questions**

1. **Q:** What is Foundry used for?
   **A:** Foundry is a framework for developing, testing, and deploying smart contracts using Solidity.

2. **Q:** What makes Foundry faster than Hardhat?
   **A:** Foundry is built in **Rust**, providing faster compilation times.

3. **Q:** Name the four main tools included in Foundry.
   **A:** **Forge**, **Cast**, **Anvil**, and **Chisel**.

4. **Q:** How do you install Foundry on your system?
   **A:** Run `curl -L https://foundry.paradigm.xyz | bash` in the terminal.

5. **Q:** What should you do if `forge --version` doesn’t work after installation?
   **A:** Run `source ~/.bashrc` or add the command to `.bash_profile`.

---
---
---
---

# ⚙️ **Foundry Setup (Part 2)**

## 📁 **Setting Up the Project Directory**

Before proceeding, ensure you’re inside the folder you created in the previous lesson.

### 🪜 **Commands Recap**

```bash
mkdir foundry-f23
cd foundry-f23
```

Now, let’s create a new folder for our Foundry project:

```bash
mkdir foundry-simple-storage-f23
cd foundry-simple-storage-f23
```

### 💡 **Pro Tip: Command Autocomplete**

You can **speed up navigation** in your terminal by pressing the **Tab** key after typing the first few letters of a command or directory name.
It autocompletes commands and paths automatically.

---

## 🧰 **Opening the Project in VS Code**

Type the following command inside your terminal:

```bash
code .
```

This opens **Visual Studio Code** in the current directory — in this case,
`foundry-simple-storage-f23` will be your workspace folder.

You’ll now see your folder contents in the **VS Code sidebar**.

---

## 🗂️ **Basic File Commands**

### ➕ Create a File

```bash
touch randomFile.txt
```

This creates a new empty file named `randomFile.txt`.

### ❌ Delete a File

```bash
rm randomFile.txt
```

This command deletes the file you just created.

> ⚡ The terminal is extremely powerful for navigating, creating, and managing files and directories.
> If you’re new to it, consider going through a quick **terminal basics tutorial** to improve your workflow speed.

---

## 🚀 **Creating a New Foundry Project**

To initialize a new Foundry project, use:

```bash
forge init
```

This sets up a **new Foundry project** inside your current directory.

### 📦 **Creating a Project in a New Folder**

If you want Foundry to create the project inside a new directory, run:

```bash
forge init nameOfNewFolder
```

> ⚠️ **Note:**
> `forge init` only works inside an **empty folder** by default.
> If the folder already contains files, use the `--force` flag:
>
> ```bash
> forge init --force
> ```

---

## 🔑 **Git Configuration (Optional but Recommended)**

If you encounter errors related to Git while running `forge init`, configure your Git identity as follows:

```bash
git config --global user.email "yourEmail@provider.com"
git config --global user.name "yourUsername"
```

Once complete, your project directory will be automatically set up with the following structure 👇

---

## 🗃️ **Project Folder Structure Overview**

![structure](https://updraft.cyfrin.io/foundry-simply-storage/7-create-a-new-foundry-project/Image1.PNG)

| Folder/File      | Description                                                                                                                                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **lib/**         | Stores dependencies installed via Foundry. Common libraries include: <br> - `forge-std`: standard Forge library for testing and scripting <br> - `openzeppelin-contracts`: widely used smart contract library |
| **scripts/**     | Contains all **deployment and interaction scripts** for your contracts                                                                                                                                        |
| **src/**         | Main source folder for your **Solidity smart contracts**                                                                                                                                                      |
| **test/**        | Houses your **unit tests** written in Solidity                                                                                                                                                                |
| **foundry.toml** | Configuration file defining settings for compilation, testing, and dependencies                                                                                                                               |

> 🧠 Each of these folders serves a specific purpose and helps organize your project efficiently.

---

## 🧩 **Creating Your First Contract**

1. In VS Code, **right-click** the `src` folder.
2. Select **“New File”** and name it:

   ```
   SimpleStorage.sol
   ```
3. Paste the Solidity code for the `SimpleStorage` contract (as provided in the lesson or repo).

---

## 🧹 **Cleaning Up Default Files**

When a new Foundry project is initialized, it automatically creates a few example files:

* `Counter.s.sol`
* `Counter.sol`
* `Counter.t.sol`

You can safely **delete** these default files as they are only placeholders.

```bash
rm src/Counter.sol
rm script/Counter.s.sol
rm test/Counter.t.sol
```

This ensures your project folder remains clean and focused on your custom contract (`SimpleStorage.sol`).

---

✅ **At this point, your Foundry project is ready for coding and testing your first smart contract!**

---
---
---



# ⚙️ **Compiling Smart Contracts — Foundry Console Guide**

## 🧩 **Compilation Command**

To compile smart contracts in your Foundry project:

```bash
forge build
```

or

```bash
forge compile
```

✅ This compiles all contracts inside your `src` folder.

---

## 📁 **New Folders Created After Compilation**

| Folder     | Description                                                                                   |
| ---------- | --------------------------------------------------------------------------------------------- |
| **out/**   | Contains compiled output files — includes **ABI**, **Bytecode**, and other contract metadata. |
| **cache/** | Stores temporary system files used during compilation (can be ignored for now).               |

You can view these folders in the **VS Code Explorer tab** after running the compile command.

---

## 🧙 **Terminal Efficiency Tips**

During development or auditing, you’ll run many commands like:

```bash
forge build
forge test
forge script
```

Typing them repeatedly can be slow.

### 💡 Use Arrow Keys:

Example:

```bash
echo "I like Foundry"
echo "I love Cyfrin"
echo "Auditing is great"
```

Press **↑ (up)** or **↓ (down)** arrows to cycle through previous commands — a quick way to reuse them.

---

