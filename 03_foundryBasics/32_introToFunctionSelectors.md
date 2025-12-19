
# 🔢 Intro to Function Selectors (Systematic Explanation)

## 🧠 Why This Topic Matters

When you click **Fund** in a Web3 frontend:

* MetaMask shows **raw hex data**
* This data determines **exactly which function** is called on the contract
* Understanding this lets you **verify transactions**, detect **malicious calls**, and trust what you’re signing

---

## 🔁 What Happens When You Call `fund()`

1. You click **Fund** on the website
2. Frontend sends a transaction to MetaMask
3. MetaMask shows transaction details
4. Under the **Hex** tab → you see **raw calldata**

📌 This calldata contains:

* Function selector
* Encoded arguments (if any)

---

## 🧩 What Is a Function Selector?

### Definition

A **function selector** is:

> The **first 4 bytes** of the Keccak-256 hash of a Solidity function signature.

### Example

```solidity
function fund() public payable {}
```

**Function signature**

```
fund()
```

**Hash**

```
keccak256("fund()")
```

**Function selector**

```
0xb60d4288
```

📌 Solidity converts **human-readable functions** into **low-level bytecode** so the EVM can understand them.

---

## 🛠️ Verifying Function Selectors with Foundry

### Command

```bash
cast sig "fund()"
```

### Output

```
0xb60d4288
```

✔️ Matches the Hex data shown in MetaMask
✔️ Confirms **fund()** is being called

---

## 🚨 Security Insight (VERY IMPORTANT)

### What if the function was malicious?

```solidity
function stealMoney() public {}
```

```bash
cast sig "stealMoney()"
```

Output:

```
0xa7ea5e4e
```

📌 Completely different selector
📌 Meaning **every function has a unique selector**

👉 You can **verify exactly what you’re signing** by checking this selector.

---

## 🧪 Verifying Browser Wallet Transactions

### How to Verify Safety

1. Copy **Hex data** from MetaMask
2. Extract first 4 bytes
3. Compute expected selector using `cast sig`
4. Compare

✔️ Match = safe
❌ Mismatch = 🚨 red flag

---

## 🧬 Function Selectors + Arguments (Calldata)

### Function with Parameters

```solidity
function fund(uint256 amount) public payable {}
```

**Function signature**

```
fund(uint256)
```

---

## 🧾 What MetaMask Shows Now

* Function selector (first 4 bytes)
* Encoded arguments (rest of calldata)

Example calldata:

```
0xca1d209d
000000000000000000000000000000000000000000000000016345785d8a0000
```

---

## 🔍 Decoding Calldata Using Foundry

### Command

```bash
cast --calldata-decode "fund(uint256)" 0xca1d209d000000000000000000000000000000000000000000000000016345785d8a0000
```

### Output

```
100000000000000000
```

### Interpretation

```
100000000000000000 wei
= 0.1 ETH
```

✔️ Exactly what was entered in the frontend
✔️ Confirms function + argument correctness
✔️ Transaction is safe

---

## 🧠 Calldata Structure (Very Important)

```
| 4 bytes | 32 bytes | 32 bytes | ...
| selector| arg1     | arg2     |
```

* Selector → function name
* Arguments → ABI-encoded values
* Always deterministic

---

## 🔐 Why This Is Powerful

* You can audit transactions **before signing**
* Wallet UIs may be vague, but calldata never lies
* Used by:

  * Security researchers
  * Auditors
  * Advanced DeFi users

---

## 🧪 Experiments to Try (Hands-On Practice)

1. Fund and withdraw using same account
2. Fund with Account A, withdraw with Account B
   → Observe **revert / access control**
3. Verify selectors of:

   * `withdraw()`
   * `getBalance()`
4. Decode calldata for functions with multiple arguments

---

## 📌 Final Wrap-Up (Revision Points)

* Solidity functions → function selectors
* Selector = first 4 bytes of keccak hash
* MetaMask shows raw calldata
* `cast sig` → verify function selector
* `cast --calldata-decode` → decode arguments
* Calldata = truth source of a transaction
* Function selectors prevent hidden/malicious calls

