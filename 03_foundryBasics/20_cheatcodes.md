

# ⚡ **Foundry Magic: Cheatcodes**

---

## 🎯 **Goal of this Lesson**

We’ve now:

* Refactored our contracts to be blockchain-agnostic.
* Deployed mock contracts to test locally.

Now it’s time to **increase test coverage** and dive deep into **Foundry Cheatcodes** — the hidden power tools of Foundry that make smart contract testing fast, flexible, and incredibly powerful.

---

## 🧮 **Quick Recap: Code Coverage**

Run this command anytime to see how much of your contract logic your tests actually cover:

```bash
forge coverage
```

Coverage is expressed as a percentage of lines executed by your tests.
While **100%** coverage is ideal, it’s not always realistic — but **12–13%** is a joke 😅.
Let’s fix that by writing smarter tests.

---

## 🧠 **What Does the `fund()` Function Do?**

Let’s recall the core functionality of the `fund()` function in **FundMe.sol**.

```solidity
function fund() public payable {
    require(
        msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
        "You need to spend more ETH!"
    );
    s_addressToAmountFunded[msg.sender] += msg.value;
    s_funders.push(msg.sender);
}
```

We need to test **three key behaviors**:

1. **Reverts if insufficient ETH sent**
   → i.e., the `require()` statement triggers when less than `MINIMUM_USD`.

2. **Mapping is updated correctly**
   → `s_addressToAmountFunded[msg.sender]` should store the funded value.

3. **Funder list is updated**
   → `s_funders` should record each unique funder.

To test all these properly, we’ll use one of Foundry’s most powerful tools: **Cheatcodes**.

---

## 🔮 **What Are Cheatcodes?**

Cheatcodes are **special low-level functions** built into Foundry that give you “superpowers” when testing.

They let you:

* Mock blockchain data
* Simulate user interactions
* Modify state variables
* Control the EVM
* Expect specific outcomes (like reverts)

💬 Official definition (from Foundry Book):

> “Cheatcodes give you powerful assertions, the ability to alter the state of the EVM, mock data, and more.”

---

## 🧩 **Cheatcode 1: `expectRevert`**

### 🔍 Purpose

Tell Foundry that the **next call** should fail (revert).
If it doesn’t — your test fails.

### 🧪 Example Test

Add this in `FundMe.t.sol`:

```solidity
function testFundFailsWithoutEnoughETH() public {
    vm.expectRevert(); // Next call MUST revert
    fundMe.fund();     // Sending 0 ETH should trigger require() revert
}
```

✅ **Expected Behavior:**
The call reverts (as it should), so the test passes.

---

## 🔧 **Refactor Storage Variables**

To follow Solidity conventions and improve gas efficiency:

* Prefix private storage variables with `s_`.
* Change visibility to `private`.

### Update in `FundMe.sol`:

```solidity
mapping(address => uint256) private s_addressToAmountFunded;
address[] private s_funders;
```

Then, add **getter functions** so we can read these values in tests.

---

### 📜 Add Getters to `FundMe.sol`

```solidity
/** Getter Functions */
function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
    return s_addressToAmountFunded[fundingAddress];
}

function getFunder(uint256 index) public view returns (address) {
    return s_funders[index];
}
```

Run `forge test` to confirm everything still works.

---

## 🧩 **Cheatcode 2: `prank`**

### 🔍 Purpose

Temporarily **changes `msg.sender`** for the **next transaction**.

### 🧪 Example

Let’s test whether the mapping is updated correctly.

Add this test:

```solidity
function testFundUpdatesFundDataStructure() public {
    fundMe.fund{value: 10 ether}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(msg.sender);
    assertEq(amountFunded, 10 ether);
}
```

But it fails ❌
Why?

Because `msg.sender` inside the test = `address(this)` (the test contract).
If we want to simulate a **real user**, we must create one.

---

## 🧩 **Cheatcode 3: `makeAddr`**

### 🔍 Purpose

Creates a **new wallet address** deterministically based on a string name.

Add this to the top of your test contract:

```solidity
address alice = makeAddr("alice");
```

Now you have a test user called “Alice”.

---

## 🧩 **Cheatcode 4: `startPrank` / `stopPrank`**

### 🔍 Purpose

Temporarily change `msg.sender` for **multiple consecutive calls**.

It works just like `vm.startBroadcast()` and `vm.stopBroadcast()` in deployment scripts.

```solidity
vm.startPrank(alice);
fundMe.fund{value: SEND_VALUE}();
fundMe.withdraw();
vm.stopPrank();
```

Between these calls, `msg.sender = alice`.

---

## 💸 **Cheatcode 5: `deal`**

### 🔍 Purpose

Sets the **ETH balance** of any address.

Without this, your fake users (like Alice) have 0 balance, so transactions requiring ETH fail.

---

### Add Balance to Alice

At the **end of `setUp()`**, add:

```solidity
vm.deal(alice, STARTING_BALANCE);
```

Declare this constant at the top:

```solidity
uint256 constant STARTING_BALANCE = 10 ether;
```

Now Alice has 10 ETH to use in tests.

---

## 💰 **Add a Constant for Send Value**

To avoid another magic number, define:

```solidity
uint256 public constant SEND_VALUE = 0.1 ether;
```

---

## 🧪 **Final Working Test: `testFundUpdatesFundDataStructure`**

Here’s the clean, full version:

```solidity
function testFundUpdatesFundDataStructure() public {
    vm.prank(alice); // Pretend Alice is calling
    fundMe.fund{value: SEND_VALUE}();

    uint256 amountFunded = fundMe.getAddressToAmountFunded(alice);
    assertEq(amountFunded, SEND_VALUE);
}
```

Run:

```bash
forge test --mt testFundUpdatesFundDataStructure
```

✅ **Test Passed!**

If it fails again, increase verbosity to see why:

```bash
forge test --mt testFundUpdatesFundDataStructure -vvv
```

If you see `EvmError: OutOfFunds`, it means you forgot `vm.deal()` —
Alice had no balance.

After adding `vm.deal()`, it passes.

---

## 🧰 **Cheatcodes Summary Table**

| Cheatcode                                   | Description                          | Example                                     |
| ------------------------------------------- | ------------------------------------ | ------------------------------------------- |
| `vm.expectRevert()`                         | Expect the next call to fail         | `vm.expectRevert(); fundMe.fund();`         |
| `vm.prank(address)`                         | Sets `msg.sender` for the next call  | `vm.prank(alice); fundMe.fund();`           |
| `vm.startPrank(address)` / `vm.stopPrank()` | Sets `msg.sender` for multiple calls | `vm.startPrank(alice); ... vm.stopPrank();` |
| `vm.deal(address, amount)`                  | Gives ETH balance to a wallet        | `vm.deal(alice, 10 ether);`                 |
| `makeAddr("name")`                          | Generates a test address             | `address alice = makeAddr("alice");`        |

---

## 🧩 **Cheatcodes Workflow Recap**

1. **Create users** using `makeAddr()`.
2. **Fund them** using `deal()`.
3. **Simulate them calling functions** using `prank()` or `startPrank()`.
4. **Expect reverts** where applicable using `expectRevert()`.
5. **Run tests** to confirm mappings, arrays, and balances update properly.

---

## ✅ **Final Setup Snapshot**

### At the top of `FundMeTest.t.sol`

```solidity
address alice = makeAddr("alice");
uint256 constant SEND_VALUE = 0.1 ether;
uint256 constant STARTING_BALANCE = 10 ether;
```

### Inside `setUp()`

```solidity
vm.deal(alice, STARTING_BALANCE);
```

### Tests

```solidity
function testFundFailsWithoutEnoughETH() public {
    vm.expectRevert();
    fundMe.fund();
}

function testFundUpdatesFundDataStructure() public {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(alice);
    assertEq(amountFunded, SEND_VALUE);
}
```

---

## 🧠 **Why Cheatcodes Are Essential**

Cheatcodes make Foundry **the most powerful testing framework** for Solidity because they give you:

* **Full control over the EVM**
* **Fast, local, reproducible tests**
* **Direct manipulation of blockchain state**

You can:

* Simulate any user
* Mock transactions or balances
* Predict failures before deployment

Once you master these, you’ll test like a pro Solidity developer or auditor.

---

## 🎯 **Key Takeaways**

| Concept                      | Summary                                                 |
| ---------------------------- | ------------------------------------------------------- |
| **Cheatcodes**               | Special tools for simulating and manipulating EVM state |
| **expectRevert()**           | Ensures reverts happen when they should                 |
| **prank()**                  | Changes `msg.sender` temporarily                        |
| **deal()**                   | Sets ETH balance of any test account                    |
| **startPrank()/stopPrank()** | Persist a sender context over multiple calls            |
| **makeAddr()**               | Quickly create named test users                         |
| **Constants**                | Eliminate magic numbers and improve readability         |
| **Tests now**                | ✅ Blockchain-agnostic, ✅ Reliable, ✅ Readable           |

---

## 🏁 **Final Thought**

> Testing isn’t just about making sure your code works —
> it’s about proving it **can’t break**.

Foundry’s cheatcodes give you the superpowers to simulate **any condition**, **any sender**, and **any balance** — all locally.

Your test coverage will now skyrocket 🚀

---
