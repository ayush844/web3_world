

# ⚙️ **Making the `withdraw()` Function More Gas-Efficient**

---

## 💡 The Core Problem: Storage is Expensive

From the previous lesson, you learned that **storage operations (`SLOAD` and `SSTORE`)** are the **most expensive operations** in the Ethereum Virtual Machine (EVM).

Let’s remind ourselves of the relative costs:

| Opcode   | Operation         | Type    | Min Gas Cost                     |
| -------- | ----------------- | ------- | -------------------------------- |
| `MLOAD`  | Read from memory  | Memory  | ~3 gas                           |
| `MSTORE` | Write to memory   | Memory  | ~3 gas                           |
| `SLOAD`  | Read from storage | Storage | ~100 gas                         |
| `SSTORE` | Write to storage  | Storage | ~20,000 gas (if zero → non-zero) |

So reading or writing from **storage** is roughly **33x to 6,000x more expensive** than using **memory**.

---

### 🔍 Why Does This Matter?

In Solidity, **state variables** (declared outside functions) live in **storage**.
Local variables (inside functions) live in **memory** or **stack** — both are cheap.

So whenever you repeatedly read a state variable inside a loop,
you’re doing **multiple `SLOAD`s**, which cost a lot of gas.

---

## 🧱 The Original `withdraw()` Problem

The original `withdraw()` function in your `FundMe.sol` looked something like this:

```solidity
function withdraw() public onlyOwner {
    for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
        address funder = s_funders[funderIndex];
        s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address ;

    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
}
```

Looks fine, right?

But notice the **loop condition**:

```solidity
funderIndex < s_funders.length
```

Each time the loop runs, the EVM executes an `SLOAD` to fetch `s_funders.length` from storage.

If there are **1000 funders**, we’ll perform **1000 `SLOAD` operations** just to read the same length — wasting gas unnecessarily.

---

## 🧠 The Optimization: Cache in Memory

The fix is simple but powerful — **cache storage reads in a local variable**.

```solidity
function cheaperWithdraw() public onlyOwner {
    uint256 fundersLength = s_funders.length; // Cached in memory
    for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
        address funder = s_funders[funderIndex];
        s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address ;

    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
}
```

---

### 🧩 What We Did

| Operation                             | Storage vs Memory                            | Description                          |
| ------------------------------------- | -------------------------------------------- | ------------------------------------ |
| `s_funders.length`                    | **Read once from storage → store in memory** | Saves one `SLOAD` per loop iteration |
| `funder = s_funders[funderIndex]`     | Still a storage read (unavoidable)           | We must read each address            |
| `s_addressToAmountFunded[funder] = 0` | Still a storage write (unavoidable)          | We must reset mappings               |
| `s_funders = new address `            | Storage write                                | Resets the array                     |
| ETH transfer                          | External call                                | Necessary operation                  |

The only change — **one line of caching** —
but it prevents **N redundant storage reads** where **N = number of funders**.

---

## 🔬 Understanding Why It Works

The EVM works at a very low level:

* Every time you read `s_funders.length`, it executes an `SLOAD` from storage.
* Each `SLOAD` can cost ~2,100–2,600 gas depending on context.

By doing:

```solidity
uint256 fundersLength = s_funders.length;
```

We read it once (1 × `SLOAD`),
store it in **memory** (cheap),
and reuse it **N times for free**.

If `N = 1000`, that’s roughly **1000 × 2,100 = 2.1 million gas saved** in large loops.

Even though your test shows smaller differences (since test data is small),
in real contracts with large user bases, **this optimization scales dramatically**.

---

## 🧮 Running Gas Comparison Tests

We now want to measure exactly how much we saved.

---

### 🧱 Add `cheaperWithdraw()` to FundMe.sol

```solidity
function cheaperWithdraw() public onlyOwner {
    uint256 fundersLength = s_funders.length;
    for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
        address funder = s_funders[funderIndex];
        s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address ;

    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
}
```

---

### 🧪 Add Test in FundMe.t.sol

Copy your old test for `withdraw()` and modify it:

```solidity
function testWithdrawFromMultipleFundersCheaper() public funded {
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
        // Foundry's `hoax` gives ETH and pranks an address
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }

    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.getOwner().balance;

    vm.startPrank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
}
```

---

### 🧾 Run Snapshot Command

```bash
forge snapshot
```

---

### 📊 Output (Example)

```
FundMeTest:testWithdrawFromMultipleFunders() (gas: 535148)
FundMeTest:testWithdrawFromMultipleFundersCheaper() (gas: 534219)
```

✅ **Saved 929 gas** just by caching one variable.

That might seem small here, but remember:

* We only tested 10 funders.
* Real protocols may have thousands → savings scale linearly.

---

## 🧠 Why This Optimization Matters

| Concept                               | Explanation                                                |
| ------------------------------------- | ---------------------------------------------------------- |
| **Storage reads are slow and costly** | Each `SLOAD` pulls data from disk-level persistent storage |
| **Memory is cheap**                   | RAM-like structure used only during execution              |
| **Caching**                           | Store storage data once into memory and reuse it           |
| **Gas savings scale with usage**      | The more iterations, the more gas saved                    |

This optimization technique is called **“caching storage reads”** — it’s one of the simplest yet most effective Solidity performance tricks.

---

## 🧩 What You Can’t Avoid

Not all storage access can be eliminated. For example:

* Reading each funder’s address (`s_funders[i]`)
* Resetting each funder’s contribution mapping (`s_addressToAmountFunded[funder]`)
* Clearing the array and transferring ETH

These are **necessary SLOAD/SSTORE operations**.
But any **repeated or constant reads** (like `.length`, `.owner`, `.balance`)
should be **cached** locally whenever possible.

---

## 🧠 Additional Techniques for Cheaper Withdrawals

Here are more ways to optimize gas consumption in such functions:

| Technique                             | Description                                                                                                     |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Use `memory` for temporary arrays** | Copy storage array to memory before looping to reduce repeated `SLOAD`s.                                        |
| **Batch processing**                  | Split large loops into multiple smaller transactions (useful for huge funder lists).                            |
| **Unchecked increments**              | Use `unchecked { funderIndex++; }` inside loop if you know overflow is impossible.                              |
| **Avoid redundant state updates**     | Don’t zero out mappings/arrays if you’re redeploying anyway.                                                    |
| **Use `delete` keyword**              | Instead of reassigning a new empty array (`new address `), `delete s_funders` resets storage slots efficiently. |

---

### 🧩 Example of Using Memory Array (Even Cheaper)

```solidity
function evenCheaperWithdraw() public onlyOwner {
    address[] memory funders = s_funders; // Copy to memory
    uint256 fundersLength = funders.length;
    for (uint256 i = 0; i < fundersLength; i++) {
        s_addressToAmountFunded[funders[i]] = 0;
    }
    delete s_funders; // Equivalent to resetting array
    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Call failed");
}
```

Here we:

* Copy the entire `s_funders` array to memory once.
* Loop through the memory array (cheap reads).
* Write only once per funder to mapping (storage write, unavoidable).
* Use `delete` instead of `new address ` (slightly cheaper reset).

This version will likely save **more gas** when funders count grows large.

---

## 🧾 Style Guide & Naming Conventions

The `s_`, `i_`, and constant naming style isn’t just aesthetic —
it helps you **visually separate storage, immutable, and constant variables**:

| Prefix     | Type      | Lifetime               | Example                    |
| ---------- | --------- | ---------------------- | -------------------------- |
| `s_`       | Storage   | Persistent             | `s_funders`, `s_priceFeed` |
| `i_`       | Immutable | Set once (constructor) | `i_owner`                  |
| `ALL_CAPS` | Constant  | Compile-time fixed     | `MINIMUM_USD`              |

This naming scheme lets you instantly spot where optimizations are possible:

* `s_` → slow, storage read/write → expensive.
* `memory` or local → cheap, reuse freely.
* `constant` → zero gas (baked in bytecode).

---

## 🧠 Summary

| Concept                  | Explanation                                                              |
| ------------------------ | ------------------------------------------------------------------------ |
| **Problem**              | Reading storage repeatedly in a loop (`s_funders.length`) costs high gas |
| **Solution**             | Cache storage reads in memory variables (`fundersLength`)                |
| **Result**               | Saved 929 gas (with small test case), scales with number of funders      |
| **Why It Works**         | Memory reads (`MLOAD`) are ~33x cheaper than storage reads (`SLOAD`)     |
| **Best Practice**        | Always cache storage reads used in loops or multiple times               |
| **Naming Trick**         | Use `s_` for storage vars → easier to spot optimizations                 |
| **Further Optimization** | Copy storage arrays to memory, use `delete`, apply `unchecked`           |

---

## 🧩 Quick Visual: Gas Comparison

| Function            | Gas (Tested with 10 funders) | Improvement         |
| ------------------- | ---------------------------- | ------------------- |
| `withdraw()`        | 535,148                      | —                   |
| `cheaperWithdraw()` | 534,219                      | ↓ **929 gas saved** |

If scaled to 1000 funders, that’s **~92,900 gas saved** or more.

---

## 🧠 Key Takeaways

* Every `SLOAD` and `SSTORE` hits disk-level storage — expensive.
* Always **cache** repeated reads into **memory variables**.
* Use **naming conventions** to keep track of data locations.
* Small tweaks (like caching `.length`) lead to **massive savings** in large loops.
* Use `forge snapshot` or `forge test --gas-report` to **quantify** your savings.

---

## 🚀 **Next Steps**

Now that you’ve learned to make `withdraw()` cheaper,
the next lesson explores **gas reports** and **profiling techniques** in Foundry —
so you can compare every function’s cost automatically and visualize where the gas goes.

