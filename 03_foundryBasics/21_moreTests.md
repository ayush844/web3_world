

# ⚙️ **Let’s Keep Testing — FoundMe Withdraw Function & Advanced Test Design**

---

## 🎯 **Objective**

In the last lesson, we verified that `s_addressToAmountFunded` updates correctly when someone funds our contract.

Now we’ll:

* ✅ Verify that **`s_funders` array** updates correctly
* ✅ Ensure **only the owner** can withdraw
* ✅ Confirm **the owner can withdraw** from one or multiple funders
* ✅ Learn **modifiers in tests** to make testing reusable and clean
* ✅ Apply the **Arrange-Act-Assert** (AAA) methodology for structured testing

By the end, you’ll understand professional-grade test design for Solidity using Foundry.

---

## 🧩 **Step 1: Test that Funders Array Updates**

### 📜 Add the Test

In `FundMe.t.sol`, add this function:

```solidity
function testAddsFunderToArrayOfFunders() public {
    vm.startPrank(alice);
    fundMe.fund{value: SEND_VALUE}();
    vm.stopPrank();

    address funder = fundMe.getFunder(0);
    assertEq(funder, alice);
}
```

### 🧠 What’s Happening

1. `vm.startPrank(alice)` → Every transaction that follows will use `msg.sender = alice`.
2. `fundMe.fund{value: SEND_VALUE}()` → Alice funds the contract.
3. `vm.stopPrank()` → Ends the prank (returns `msg.sender` to normal).
4. `fundMe.getFunder(0)` → Gets the first entry in the `s_funders` array.
5. `assertEq(funder, alice)` → Checks if the stored address equals Alice’s address.

✅ Run it:

```bash
forge test --mt testAddsFunderToArrayOfFunders
```

It should **pass**.

---

## 🧠 **Note:**

Each test uses a **fresh setup**, so calls made in one test (like `fund()`) don’t persist into another.

That’s why we can reuse the same test data without interference.

---

## 🧩 **Step 2: Test That Only the Owner Can Withdraw**

Let’s now ensure that **non-owners (like Alice)** can’t withdraw funds.

### 📜 Add the Test

```solidity
function testOnlyOwnerCanWithdraw() public {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();

    vm.expectRevert();      // Expect next tx to revert
    vm.prank(alice);
    fundMe.withdraw();      // Non-owner tries to withdraw
}
```

### 🧠 Explanation

* Alice funds the contract normally.
* Then we **expect a revert**, because she’s not the contract owner.
* The `withdraw()` function should fail the `require(msg.sender == i_owner)` condition.

✅ Run:

```bash
forge test --mt testOnlyOwnerCanWithdraw
```

It **passes!**

---

### ⚠️ Important: Cheatcode Ordering

When multiple cheatcodes appear together, remember:
They apply to **transactions**, not to other cheatcodes.

Example:

```solidity
vm.expectRevert();
vm.prank(alice);
fundMe.withdraw();
```

Here, `expectRevert` affects the **withdraw** call — not the prank.
If reversed:

```solidity
vm.prank(alice);
vm.expectRevert();
fundMe.withdraw();
```

It would still behave the same. The revert check always applies to the next **transaction**, not the next cheatcode.

---

## 🧩 **Step 3: Reuse Common Logic with Modifiers**

You’ll often need to start tests from a “funded” state. Instead of repeating code, define a **modifier** to reuse this setup.

### 📜 Add Modifier to `FundMeTest`

```solidity
modifier funded() {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();
    assert(address(fundMe).balance > 0);
    _;
}
```

### 🧠 Explanation

* Pranks `alice` to simulate funding.
* Sends `SEND_VALUE` ETH to contract.
* Asserts that contract now holds ETH.
* The `_` means “run the rest of the test after this setup.”

Now any test using `funded` automatically starts with a funded contract.

---

### ✅ Refactor `testOnlyOwnerCanWithdraw` Using the Modifier

```solidity
function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    fundMe.withdraw();
}
```

Much cleaner and shorter.
Every test that depends on a funded state can now reuse this modifier.

---

## 🧩 **Step 4: Allow Owner to Withdraw**

Let’s confirm that the **owner** can successfully withdraw funds.

First, we’ll need a getter for the owner in `FundMe.sol`.

### 📜 Add Getter Function

```solidity
function getOwner() public view returns (address) {
    return i_owner;
}
```

Also make sure `i_owner` is declared **private** for gas efficiency:

```solidity
address private immutable i_owner;
```

---

## 🧩 **Step 5: Write Owner Withdraw Test (AAA Method)**

Now, let’s structure this test using the **Arrange-Act-Assert** methodology.

### 📜 Add the Test

```solidity
function testWithdrawFromASingleFunder() public funded {
    // --- ARRANGE ---
    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.getOwner().balance;

    // --- ACT ---
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();

    // --- ASSERT ---
    uint256 endingFundMeBalance = address(fundMe).balance;
    uint256 endingOwnerBalance = fundMe.getOwner().balance;

    assertEq(endingFundMeBalance, 0);
    assertEq(
        startingFundMeBalance + startingOwnerBalance,
        endingOwnerBalance
    );
}
```

---

### 🧠 Breakdown

#### 1️⃣ **Arrange**

Set up your test environment:

* Record initial balances for the contract and the owner.

#### 2️⃣ **Act**

Perform the action being tested:

* The owner (via `vm.startPrank`) calls `withdraw()`.

#### 3️⃣ **Assert**

Verify expected outcomes:

* Contract balance should now be **0**.
* Owner’s ending balance should equal starting owner balance + withdrawn funds.

✅ Run:

```bash
forge test --mt testWithdrawFromASingleFunder
```

It passes — perfect! 🎉

---

## 🧩 **Step 6: Withdraw from Multiple Funders**

Time to simulate multiple users funding before withdrawal.

### 📜 Add the Test

```solidity
function testWithdrawFromMultipleFunders() public funded {
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;

    for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
        // hoax = deal + prank
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }

    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.getOwner().balance;

    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
}
```

---

### 🧠 Explanation

#### 1️⃣ **Setup Multiple Funders**

* We declare `numberOfFunders = 10` and `startingFunderIndex = 1`.
* Use a `for` loop to simulate multiple addresses funding the contract.
* Type `uint160` is used because:

  * An **address** in Solidity = 20 bytes = 160 bits.
  * Using `uint160` allows easy conversion between integers and addresses:

    ```solidity
    address(uint160_var)
    ```
* The loop starts from `1` (not `0`) because `address(0)` is reserved and shouldn’t be used.

#### 2️⃣ **The Magic: `hoax()`**

* `hoax(address(i), SEND_VALUE)` is shorthand for:

  ```solidity
  vm.deal(address(i), SEND_VALUE);
  vm.prank(address(i));
  ```
* It gives the address some ETH and sets it as `msg.sender`.

Each iteration simulates a **new funder** contributing to the contract.

---

### 3️⃣ **Arrange**

We record:

```solidity
uint256 startingFundMeBalance = address(fundMe).balance;
uint256 startingOwnerBalance = fundMe.getOwner().balance;
```

---

### 4️⃣ **Act**

Owner withdraws all funds:

```solidity
vm.startPrank(fundMe.getOwner());
fundMe.withdraw();
vm.stopPrank();
```

---

### 5️⃣ **Assert**

Finally, we validate:

```solidity
assert(address(fundMe).balance == 0);
assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
```

✅ Explanation:

* Contract balance should be **0** after withdrawal.
* Owner’s balance should equal previous balance + all funds.
* `(numberOfFunders + 1)` accounts for **Alice**, added by our `funded` modifier.

✅ Run:

```bash
forge test --mt testWithdrawFromMultipleFunders
```

✅ Then:

```bash
forge test
```

All tests should now pass.

---

## 🧮 **Step 7: Check Coverage**

Run:

```bash
forge coverage
```

You’ll now see significantly higher coverage — your `FundMe.sol` is now **fully tested for all major functions**, including:

* `fund()`
* `withdraw()`
* Access control
* Storage correctness
* Multi-user funding logic

---

## 🧩 **Summary of Key Concepts**

| Concept                  | Description                                                |
| ------------------------ | ---------------------------------------------------------- |
| **Prank**                | Simulates a single transaction from another address        |
| **StartPrank/StopPrank** | Simulates multiple transactions in a row                   |
| **ExpectRevert**         | Asserts that the next call must fail                       |
| **Hoax**                 | Combines `deal + prank` to fund and impersonate an address |
| **Modifiers in Tests**   | Reusable test setups (e.g., `funded()`)                    |
| **AAA Pattern**          | Arrange (setup), Act (execute), Assert (verify results)    |

---

## 🧠 **Best Practices Learned**

✅ Always structure tests using the **AAA** method
✅ Use **modifiers** to eliminate repetitive setup code
✅ Replace loops and manual mocks with **cheatcodes** like `hoax()`
✅ Ensure every test is **independent** (uses a clean setup)
✅ Frequently run `forge coverage` to track test completeness
✅ Test **both failure and success** conditions

---

## 🏁 **Final Thoughts**

You’ve now achieved:

* ✅ Full testing of all FundMe core logic
* ✅ Use of all key Foundry cheatcodes
* ✅ Clean, modular test structure
* ✅ Solid understanding of multi-user simulations

You’re now testing at a **professional Solidity developer** level.

---
