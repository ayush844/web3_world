
# ⚙️ **An Introduction to Chisel**

---

## 🧩 **What Is Chisel?**

**Chisel** is one of the **four core tools** in the **Foundry toolchain**, alongside:

| Tool          | Purpose                                                                         |
| ------------- | ------------------------------------------------------------------------------- |
| 🧱 **Forge**  | For building, testing, and deploying Solidity contracts                         |
| 🔮 **Cast**   | For interacting with deployed contracts and performing on-chain operations      |
| 🧪 **Anvil**  | A local Ethereum testnet for fast testing and simulation                        |
| 🧰 **Chisel** | A Solidity **REPL (Read-Eval-Print Loop)** for instant Solidity experimentation |

---

### 💡 In Simple Words:

**Chisel is a live Solidity playground in your terminal.**

Just like Python’s `python` shell or JavaScript’s `node` REPL,
you can write Solidity code directly in your terminal, **execute it instantly**, and see the results — **no need for Remix or Hardhat scripts**.

It’s **lightning-fast**, **on-chain accurate**, and works **locally** or with **forked testnets** like Sepolia or mainnet.

---

## ⚡ **Why Use Chisel Instead of Remix?**

| Feature                            | Remix         | Chisel           |
| ---------------------------------- | ------------- | ---------------- |
| Web-based                          | ✅             | ❌ (terminal)     |
| Requires manual setup              | ✅             | ❌                |
| Forks live chain easily            | ❌             | ✅                |
| Integration with local environment | ❌             | ✅                |
| Script automation                  | ❌             | ✅                |
| Speed                              | 🚫 Slower     | ⚡ Extremely fast |
| Privacy                            | ❌ Cloud-based | ✅ Local-only     |

So, instead of switching to Remix to test small Solidity snippets, you can just stay in your Foundry project folder and use `chisel`.

---

## 🧰 **How to Open Chisel**

In your terminal, inside any Foundry project, type:

```bash
chisel
```

This launches an **interactive Solidity shell**.

You’ll see a prompt like:

```
➜
```

This means Chisel is now waiting for Solidity input.

---

## 🧠 **Available Commands**

To list all commands and controls, type:

```bash
!help
```

You’ll see a guide to all commands starting with `!` (these are **meta commands**, like `!exit`, `!reset`, `!help`, `!load`, etc.)

Some useful ones:

| Command        | Description                                              |
| -------------- | -------------------------------------------------------- |
| `!help`        | Lists all available commands                             |
| `!exit`        | Exit Chisel                                              |
| `!reset`       | Clear the REPL session                                   |
| `!load <file>` | Load a Solidity file                                     |
| `!edit`        | Open an inline code editor to paste longer Solidity code |
| `!fork <rpc>`  | Start a forked session of a real network                 |
| `!gas`         | Measure gas usage of a given function                    |

---

## 🧪 **Your First Chisel Session**

### Example 1: Declaring and Checking Variables

```bash
➜ uint256 cat = 1;
```

This declares a variable `cat`.

Now type just `cat` and press Enter:

```
➜ cat
Type: uint256
├ Hex: 0x...01
├ Hex (full word): 0x0000...0001
└ Decimal: 1
```

Chisel shows you:

* Type of variable (`uint256`)
* Value in hexadecimal
* Value in full 32-byte word form
* Value in decimal form

✅ **Instant Solidity feedback — no compiling needed!**

---

### Example 2: Doing Arithmetic

```bash
uint256 dog = 2;
cat + dog;
```

Output:

```
Type: uint256
├ Hex: 0x...03
└ Decimal: 3
```

It automatically performs the operation and prints the result in multiple formats.

---

### Example 3: Testing a Condition

```bash
uint256 frog = 10;
require(frog > cat);
```

✅ Nothing happens — it passed.

Now reverse it:

```bash
require(cat > frog);
```

You’ll get:

```
Traces:
  [197] 0xBd770416a3345F91E4B34576cb804a576fa48EB1::run()
    └─ ← [Revert] EvmError: Revert

⚒️ Chisel Error: Failed to execute REPL contract!
```

💥 It reverted!
You just simulated a Solidity revert inside your terminal — no deploy required.

---

### 🧹 Exit Chisel

To exit, press:

```
Ctrl + C (twice)
```

You’ll return to your normal terminal prompt.

---

## 🧩 **Chisel Architecture: How It Works**

When you run `chisel`, Foundry:

1. Spins up a **temporary in-memory contract** behind the scenes.
2. Compiles your Solidity expressions on-the-fly.
3. Executes them instantly on an **Anvil-like EVM instance** (in memory).
4. Displays results interactively — without any deployment.

This makes it extremely powerful for **debugging, testing logic, or exploring Solidity syntax** quickly.

---

## 🧠 **Advanced Features**

Chisel is not just a playground — it supports **real EVM-level behavior** and **network forking**.

Here are some advanced features you’ll love:

---

### ⚙️ 1. Forking Real Networks

You can fork a live blockchain (like Sepolia, Mainnet, Arbitrum) and experiment on **real state data**!

```bash
!fork https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
```

Then you can:

```bash
address dai = 0x...;
IERC20(dai).balanceOf(0xAliceAddress);
```

✅ Instantly check real token balances, contract storage, etc., on a forked EVM.
No manual deployment required.

---

### ⚙️ 2. Deploying and Calling Custom Contracts

You can paste full contract code inline and test it interactively.

Example:

```solidity
contract Counter {
    uint256 public count;
    function increment() public { count++; }
}
```

Then call:

```bash
Counter c = new Counter();
c.increment();
c.count();
```

You’ll see:

```
Type: uint256
└ Decimal: 1
```

💡 This makes Chisel great for **prototype testing** of functions before writing full tests.

---

### ⚙️ 3. Measuring Gas Costs

Want to know how much gas a function consumes?

Chisel can measure it instantly:

```bash
!gas c.increment();
```

Output:

```
Gas used: 21523
```

You can compare multiple implementations and see which is more gas efficient in seconds.

---

### ⚙️ 4. Handling Imports

You can load local or library imports directly in Chisel:

```bash
!load src/FundMe.sol
```

Then use the loaded contract just like you would in code.

---

### ⚙️ 5. Inline Scripting and Variables

You can write multi-line code inline using `!edit`:

```
!edit
```

This opens a mini text editor inside the shell. Paste multiple lines of Solidity code, save (Ctrl+O, Enter), and exit (Ctrl+X).
Then execute immediately.

Perfect for testing multi-step interactions.

---

### ⚙️ 6. Resetting the Environment

If you mess up the REPL state or want a fresh start:

```bash
!reset
```

This clears all variables, contracts, and storage — like restarting Anvil.

---

## 💡 **Practical Use Cases of Chisel**

| Use Case                  | Description                                                        |
| ------------------------- | ------------------------------------------------------------------ |
| 🧪 **Quick Logic Tests**  | Check small code snippets before writing full tests                |
| 🔍 **Debugging**          | Simulate a transaction to see where it reverts                     |
| 🧮 **Gas Estimation**     | Compare gas usage of multiple approaches                           |
| 🧰 **EVM Learning**       | Experiment with low-level opcodes or behavior                      |
| 🔗 **Fork Testing**       | Interact with mainnet contracts safely on a fork                   |
| ⚙️ **Prototyping**        | Build small logic quickly before integrating into bigger contracts |
| 🧠 **Interview Practice** | Perfect for practicing Solidity live in a terminal setting         |

---

## ⚖️ **Chisel vs Forge vs Remix**

| Feature             | **Chisel**        | **Forge Tests**     | **Remix**       |
| ------------------- | ----------------- | ------------------- | --------------- |
| Type                | REPL shell        | Full test framework | Web IDE         |
| Needs project setup | ❌                 | ✅                   | ❌               |
| Fork support        | ✅                 | ✅                   | ⚠️ Limited      |
| Speed               | ⚡ Instant         | 🚀 Fast             | 🐢 Slow         |
| Deployment          | In-memory         | On local chain      | Manual          |
| Ideal for           | Logic experiments | Full testing        | Demos/tutorials |

---

## 🧠 **Tips and Tricks**

1. **Use `!fork` to interact with real contracts** — you can call Uniswap or Aave contracts instantly.
2. **Try `!gas`** to measure gas before committing optimizations.
3. **`!edit`** is great for testing complex functions directly.
4. **Combine with `cast`** for mainnet state queries in the same project.
5. **Use `!load`** to bring in your local project contracts for experimentation.
6. **Type `!help` often** — Chisel evolves rapidly with new commands.

---

## 🧠 **Behind the Scenes**

Technically, Chisel:

* Uses **an embedded Solidity compiler** via Foundry’s forge backend.
* Spins up a lightweight **EVM runtime** (via Anvil core).
* Executes expressions as **in-memory contracts**.
* Supports **imports, libraries, and structs** just like normal Solidity.

It’s **non-persistent** — everything resets when you exit.
Think of it as a **throwaway sandbox** for smart contract logic.

---

## 🏁 **Exit and Return to Normal**

To exit:

```
Ctrl + C (twice)
```

You’ll return to your terminal prompt.

---

## 🧩 **Summary**

| Concept           | Description                                                   |
| ----------------- | ------------------------------------------------------------- |
| **Chisel**        | Solidity REPL shell for quick experimentation                 |
| **Launch**        | `chisel` in terminal                                          |
| **Core Commands** | `!help`, `!load`, `!fork`, `!gas`, `!edit`, `!reset`, `!exit` |
| **Use Cases**     | Quick logic tests, gas measurement, fork testing              |
| **Network Modes** | Local (Anvil) or forked (Sepolia/Mainnet)                     |
| **Exit**          | Ctrl + C (twice)                                              |

---

## 🧠 **Example Workflow**

```bash
chisel
!fork https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY
uint256 x = 2;
uint256 y = 3;
x + y;
!gas x + y;
!exit
```

Instant Solidity experimentation — no deployment, no setup.

---

## 🚀 **Final Takeaway**

> **Chisel is to Solidity what a REPL is to Python or Node.js.**
> It’s the fastest, safest, and most powerful way to explore Solidity behavior live — directly from your Foundry environment.

With Chisel, you can:

* Prototype functions in seconds
* Test revert conditions instantly
* Measure gas costs interactively
* Fork and interact with mainnet safely

It’s the **ultimate Solidity playground for developers, auditors, and researchers** 🧠⚒️

---
