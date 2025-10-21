

# 🧪 **Testing in Foundry — Fund Me Project**

---

## 🧠 **Introduction**

Testing is a **crucial part of smart contract development**.
Without proper tests, your contract might fail during:

* Deployment 🚫
* Audits 🔍
* Or real-world usage ⚠️

Comprehensive tests separate **great developers from average ones** — so in this section, you’ll learn how to **write, run, and understand Foundry tests**.

---

## 🧱 **1. Creating the Test File**

Inside the `test` folder, create a new file:

```
FundMeTest.t.sol
```

> 🧩 The `.t.sol` suffix is a **naming convention** used by Foundry for test contracts.

Start with a basic structure:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMeTest {

}
```

---

## 🧰 **2. Importing Foundry’s Test Library**

To use Foundry’s built-in testing utilities, import `Test.sol`:

```solidity
import {Test} from "forge-std/Test.sol";
```

Now make your contract **inherit** from `Test`:

```solidity
contract FundMeTest is Test {

}
```

The `Test` contract gives you access to:

* Assertion functions (`assertEq`, `assertTrue`, etc.)
* Cheatcodes (for manipulating blockchain state in tests)
* `console.log` for debugging

---

## ⚙️ **3. Understanding the `setUp()` Function**

The `setUp()` function runs **before every test**.
It’s used to:

* Deploy contracts
* Assign test addresses
* Set balances
* Prepare initial state

Create a simple test structure to see how Foundry works:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

contract FundMeTest is Test {

    function setUp() external { }

    function testDemo() public { }

}
```

Run your test:

```bash
forge test
```

✅ Output:

```
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testDemo() (gas: XXXX)
```

Even though it’s empty, the test passes successfully!

---

## 🔍 **4. How Testing Works Internally**

When you run `forge test`, Foundry:

1. Compiles your contracts.
2. Executes the `setUp()` function first.
3. Runs every **public/external function** whose name starts with `test`.
4. Evaluates all **assertions** inside each test:

   * ✅ If all assertions pass → the test passes
   * ❌ If any assertion fails → the test fails

---

## 🧩 **5. Example: Testing Flow**

Update your contract to the following:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

contract FundMeTest is Test {

    uint256 favNumber = 0;
    bool greatCourse = false;

    function setUp() external { 
        favNumber = 1337;
        greatCourse = true;
    }

    function testDemo() public { 
        assertEq(favNumber, 1337);
        assertEq(greatCourse, true);
    }
}
```

Run:

```bash
forge test
```

✅ Output:

```
All tests passed successfully!
```

### 🧠 What Happened:

1. Variables were initialized.
2. `setUp()` ran first.
3. Then `testDemo()` executed and validated both assertions.

---

## 🪄 **6. Debugging with `console.log`**

Foundry includes a **console** library for printing logs.
It helps with debugging and verifying values during test execution.

Import it alongside `Test`:

```solidity
import {Test, console} from "forge-std/Test.sol";
```

Example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test {

    uint256 favNumber = 0;
    bool greatCourse = false;

    function setUp() external { 
        favNumber = 1337;
        greatCourse = true;
        console.log("This will get printed first!");
    }

    function testDemo() public { 
        assertEq(favNumber, 1337);
        assertEq(greatCourse, true);
        console.log("This will get printed second!");
        console.log("Updraft is changing lives!");
        console.log("Multiple variables example:", favNumber, greatCourse);
    }
}
```

---

## 🧾 **7. Using Verbosity Levels**

The `forge test` command supports **verbosity levels** to control output details.
By default, verbosity = 1 (minimal logs).

### Verbosity Levels:

| Level    | Description                                                   |
| -------- | ------------------------------------------------------------- |
| `-v`     | Default (minimal output)                                      |
| `-vv`    | Print logs for all tests                                      |
| `-vvv`   | Execution traces for failing tests                            |
| `-vvvv`  | Execution traces for all tests + setup traces for failed ones |
| `-vvvvv` | Execution & setup traces for all tests                        |

Run with verbosity level 2 to see console logs:

```bash
forge test -vv
```

✅ Example Output:

```
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testDemo() (gas: 9482)
Logs:
  This will get printed first!
  This will get printed second!
  Updraft is changing lives!
  Multiple variables example: 1337 true

Suite result: ok. 1 passed; 0 failed
```

You can read more about console logging in the [Foundry Book](https://book.getfoundry.sh/cheatcodes/console-log).

---

## 🧩 **8. Cleaning Up**

Now that you understand how testing works:

* Delete `testDemo()`
* Remove unnecessary variables (`favNumber`, `greatCourse`)
* Keep the `console` import — you might need it later for debugging.

---

## 💰 **9. Testing the FundMe Contract**

Next, let’s write an actual test for the **FundMe** contract.

### Step 1 — Import and Declare FundMe

At the top of `FundMeTest.t.sol`:

```solidity
import {FundMe} from "../src/FundMe.sol";
```

Then declare it:

```solidity
FundMe fundMe;
```

### Step 2 — Deploy Inside setUp()

```solidity
function setUp() external {
    fundMe = new FundMe();
}
```

---

## ✅ **10. Example Test: Checking the Minimum Funding Value**

Add this test function:

```solidity
function testMinimumDollarIsFive() public {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
}
```

Now run:

```bash
forge test
```

✅ Output:

```
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
Suite result: ok. 1 passed; 0 failed
```

Your test passed! 🎉

Try changing `5e18` to a different value to see what a **failed test** looks like.

---

## ⚡ **11. Summary of What You Learned**

| Concept                 | Description                                                       |
| ----------------------- | ----------------------------------------------------------------- |
| **`setUp()` Function**  | Runs before every test; used for setup tasks                      |
| **`test` Functions**    | Must start with `test` keyword; run automatically                 |
| **Assertions**          | `assertEq`, `assertTrue`, `assertFalse` used to verify conditions |
| **Console Logging**     | Helps print and debug during testing                              |
| **Verbosity Levels**    | Control how much output `forge test` shows                        |
| **Importing Contracts** | Allows testing deployed instances                                 |
| **Clean Test Files**    | Keep tests modular, organized, and focused                        |

---

## 🧩 **12. Testing Workflow Summary**

1. 🏗️ Create test file → `FundMeTest.t.sol`
2. ⚙️ Import `Test.sol` & inherit from `Test`
3. 🧾 Write `setUp()` → deploy contracts, set state
4. 🧪 Write test functions → start with `test`
5. ✅ Use assertions to validate expected behavior
6. 🔍 Use `console.log` for debugging
7. 📊 Adjust verbosity with `forge test -vv`
8. 🚀 Run and refine tests until all pass

---

## 🎯 **Key Takeaways**

* Testing ensures your contracts are **reliable and audit-ready**.
* Foundry makes testing **fast, simple, and powerful**.
* Use **console logs** and **verbosity flags** to debug effectively.
* Always write **comprehensive tests** before deploying any contract.
* Whether you’re a **developer or auditor**, testing will be your most frequent task.

---
---
---

---

# ❌ **First Failed Test — Understanding Test Failures in Foundry**

---

## 🧠 **Objective**

In this lesson, we’ll continue writing tests for our **FundMe** contract and encounter our **first failing test**.
Through this, we’ll learn **why tests fail**, how to **debug using console.log**, and how **contract deployment** actually works during testing.

---

## 🧪 **1. Writing the Next Test**

We’ve already verified that the minimum USD value (`MINIMUM_USD`) equals `5e18`.
Now let’s test if the **contract owner** is correctly recorded when the `FundMe` contract is deployed.

Add this new test function inside your test file:

```solidity
function testOwnerIsMsgSender() public {
    assertEq(fundMe.i_owner(), msg.sender);
}
```

Run your tests with:

```bash
forge test
```

### OR

```bash
forge test --match-test testOwnerIsMsgSender -vvv   
```

---

## 🧾 **2. Test Output**

Output:

```
Ran 2 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 22521)

Suite result: FAILED. 1 passed; 1 failed; 0 skipped.
```

Uh oh — one of the tests **failed** ❌

---

## 🤔 **3. Why Did the Test Fail?**

Let’s think through what happened.

We deployed `FundMe` in the `setUp()` function like this:

```solidity
fundMe = new FundMe();
```

So naturally, we’d assume *we* (the tester) are the deployer — and therefore the owner (`i_owner`).
But the assertion says otherwise!

---

## 🧩 **4. Debugging with `console.log`**

Let’s inspect what’s going on behind the scenes.

Add these lines to your test function:

```solidity
function testOwnerIsMsgSender() public {
    console.log(fundMe.i_owner());
    console.log(msg.sender);
    assertEq(fundMe.i_owner(), msg.sender);
}
```

Now, run with **verbosity level 2** to print the logs:

```bash
forge test -vv
```

---

## 🧠 **5. Console Output**

```
Ran 2 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 26680)
Logs:
  0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
  0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
  Error: a == b not satisfied [address]
        Left:  0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        Right: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
```

So:

* `fundMe.i_owner()` → `0x7FA9...E1496`
* `msg.sender` → `0x1804...1f38`

They’re **not the same!**

---

## 🧩 **6. What’s Actually Happening**

Here’s the key insight 👇

When we call `forge test`, Foundry deploys the **test contract** (`FundMeTest`) first.
Then, inside `setUp()`, the test contract deploys `FundMe`:

```solidity
fundMe = new FundMe();
```

So, **the deployer of `FundMe`** is **the `FundMeTest` contract itself**, not *you* (the developer).

Therefore:

* `fundMe.i_owner()` → Address of `FundMeTest` (the contract that deployed it)
* `msg.sender` → The address running the test function (the test execution environment)

That’s why the two addresses are different!

---

## ✅ **7. Fixing the Test**

Now that we know who the real deployer is, let’s fix the test by comparing the owner to `address(this)` — which refers to the **current contract’s address** (`FundMeTest`):

```solidity
function testOwnerIsMsgSender() public {
    assertEq(fundMe.i_owner(), address(this));
}
```

Run the tests again:

```bash
forge test
```

✅ Output:

```
Ran 2 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
[PASS] testOwnerIsMsgSender() (gas: 22034)
Suite result: ok. 2 passed; 0 failed; 0 skipped
```

🎉 **Success! The test passes now.**

---

## 🔍 **8. Key Learning: Who is the Deployer?**

| Entity                   | Description                                             |
| ------------------------ | ------------------------------------------------------- |
| **You (Developer)**      | Initiates the tests via `forge test`                    |
| **FundMeTest Contract**  | The actual deployer of `FundMe`                         |
| **FundMe Contract**      | The contract being tested                               |
| **`msg.sender` in test** | Represents the test execution context, not the deployer |

So, within the test environment:

* The **test contract (`address(this)`)** deploys the FundMe contract.
* The **FundMe contract’s owner** becomes the **test contract**, not your external wallet.

---

## 🧠 **9. How to Debug Similar Issues in the Future**

Whenever an assertion fails:

1. Use `console.log()` to inspect both sides of the comparison.
2. Run tests with **`-vv` or `-vvvv`** for detailed logs and traces.
3. Understand the **context** — who’s calling and who’s deploying.

---

## 🧾 **10. Summary**

| Concept                | Explanation                                                                |
| ---------------------- | -------------------------------------------------------------------------- |
| **Reason for Failure** | The test contract deployed `FundMe`, not you — so `msg.sender` ≠ `i_owner` |
| **Fix**                | Compare `fundMe.i_owner()` with `address(this)`                            |
| **Debugging Tip**      | Use `console.log` to print and compare variable values                     |
| **Deployer Context**   | The contract that executes `new Contract()` becomes the deployer           |
| **Verification**       | Always confirm with `forge test -vv`                                       |

---

## ✅ **11. Updated Test Code**

Here’s the corrected and final version of your test file:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }
}
```

---

## 🧩 **12. Takeaways**

* ✅ **Tests simulate blockchain environments** — you’re not the deployer.
* 🧩 **Each test runs in isolation** with its own setup.
* ⚙️ **Deployments inside tests** are performed by the test contract.
* 🔍 **Use `console.log` and verbosity flags** for debugging failing tests.
* 🧪 **Testing is iterative** — failure is part of the learning process.

---

## 🎯 **In Summary**

| Step | Action                                             | Outcome                     |
| ---- | -------------------------------------------------- | --------------------------- |
| 1    | Write test comparing `i_owner()` with `msg.sender` | ❌ Fails                     |
| 2    | Use `console.log` to inspect values                | 🧩 Reveals address mismatch |
| 3    | Replace `msg.sender` with `address(this)`          | ✅ Passes                    |
| 4    | Understand why the test contract deploys FundMe    | 💡 Key concept learned      |

---

**Pro Tip 💡:**
Whenever you deploy contracts inside a test, **remember that the test contract is the deployer**, not your wallet.
This understanding is critical for accurate testing and debugging in Foundry.

---

