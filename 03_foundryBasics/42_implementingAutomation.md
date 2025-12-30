

## 🔗 Implementing Chainlink Automation (Without UI)

![Image](https://miro.medium.com/0%2A4l4TnvtTHGQ3l6Eg.gif)

![Image](https://docs.chain.link/images/automation/automation_2_diagram_v3.png)

---

## 1️⃣ Why Do We Need `checkUpkeep` & `performUpkeep`?

Earlier, we used **Chainlink’s UI** to automate function calls.
But **real engineers don’t depend on front-ends** ❌

👉 If we want **Chainlink nodes to call our contract directly**, we must:

* Implement **`checkUpkeep()`**
* Implement **`performUpkeep()`**
* Inherit **AutomationCompatibleInterface**

---

## 2️⃣ Big Picture Flow (Very Important)

📌 **How Chainlink Automation works internally**

1. Chainlink node calls `checkUpkeep()`
2. If `upkeepNeeded == true`
3. Chainlink node calls `performUpkeep()`
4. Our contract executes logic (pick winner)

👉 No UI involved
👉 Fully on-chain + decentralized

---

## 3️⃣ Purpose of `checkUpkeep()`

### ❓ What does `checkUpkeep` do?

* It **checks conditions**
* It **does NOT change blockchain state**
* It only returns **true or false**

📌 Chainlink nodes repeatedly call this function

---

## 4️⃣ `checkUpkeep()` Code Explained

```solidity
function checkUpkeep(
    bytes memory /* checkData */
)
    public
    view
    returns (bool upkeepNeeded, bytes memory /* performData */)
{
    bool isOpen = RaffleState.OPEN == s_raffleState;
    bool timePassed = ((block.timestamp - s_lastTimeStamp) >= i_interval);
    bool hasPlayers = s_players.length > 0;
    bool hasBalance = address(this).balance > 0;

    upkeepNeeded = (timePassed && isOpen && hasBalance && hasPlayers);
    return (upkeepNeeded, "0x0");
}
```

---

## 5️⃣ Conditions Checked (Easy to Remember)

The winner should be picked **ONLY IF**:

1️⃣ Enough **time has passed**
2️⃣ Raffle is **OPEN**
3️⃣ There are **players registered**
4️⃣ Contract has **ETH balance**
5️⃣ Chainlink subscription has LINK (implicit)

👉 All must be **true** ✅

---

## 6️⃣ Why `checkData` and `performData` Are Commented

```solidity
bytes memory /* checkData */
bytes memory /* performData */
```

📌 These are optional inputs:

* Used for complex off-chain calculations
* **We don’t need them here**

👉 Solidity allows unused parameters to be commented

---

## 7️⃣ Why `checkUpkeep` is `view`

* It **must not modify state**
* Chainlink nodes call it frequently
* View functions are **cheap & safe**

---

## 8️⃣ What Happens If `upkeepNeeded == true`?

➡️ Chainlink node calls `performUpkeep()`

---

## 9️⃣ Purpose of `performUpkeep()`

### ❓ What does `performUpkeep` do?

* Executes **actual logic**
* Changes contract state
* Picks winner
* Requests randomness

📌 This is where **gas is spent**

---

## 🔟 Refactored `performUpkeep()` Code

```solidity
function performUpkeep(
    bytes calldata /* performData */
) external override {
    (bool upkeepNeeded, ) = checkUpkeep("");

    if (!upkeepNeeded) {
        revert Raffle__UpkeepNotNeeded(
            address(this).balance,
            s_players.length,
            uint256(s_raffleState)
        );
    }

    s_raffleState = RaffleState.CALCULATING;

    uint256 requestId = i_vrfCoordinator.requestRandomWords(
        i_gasLane,
        i_subscriptionId,
        REQUEST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDS
    );
}
```

---

## 1️⃣1️⃣ Why We Call `checkUpkeep()` Again Inside `performUpkeep`

🚨 Important security point!

### Two ways `performUpkeep()` can be called:

1️⃣ By Chainlink node (safe)
2️⃣ By **any random user** (dangerous)

👉 Random users **won’t call `checkUpkeep()` first**

### Solution:

✔️ Call `checkUpkeep()` inside `performUpkeep()`
✔️ Revert if conditions are not met

---

## 1️⃣2️⃣ Custom Error for Gas Efficiency

```solidity
error Raffle__UpkeepNotNeeded(
    uint256 currentBalance,
    uint256 numPlayers,
    uint256 raffleState
);
```

### Why custom errors?

* Cheaper than `require(string)`
* Gives **debug info**
* Best practice in Solidity

---

## 1️⃣3️⃣ Why `performUpkeep` is `external`

* Chainlink nodes are **external callers**
* Required by Automation interface

---

## 1️⃣4️⃣ Required Interface & Inheritance

### Import:

```solidity
import {AutomationCompatibleInterface} 
from "chainlink/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
```

### Inherit:

```solidity
contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
```

📌 Without this:

* Contract won’t compile
* Chainlink Automation won’t work

---

## 1️⃣5️⃣ Final Step

Run:

```bash
forge build
```

✔️ Confirms:

* Interface implemented correctly
* No syntax errors
* Automation logic valid

---

## 🧠 Exam-Ready Summary

* `checkUpkeep()` → **checks conditions**
* `performUpkeep()` → **executes logic**
* Chainlink nodes:

  * Call `checkUpkeep`
  * If true → call `performUpkeep`
* Always re-check conditions inside `performUpkeep`
* Use **custom errors** for efficiency
* Contract must inherit `AutomationCompatibleInterface`

---

## 🔑 One-Line Definition (Very Important)

> **Chainlink Automation allows smart contracts to autonomously execute functions by implementing `checkUpkeep` and `performUpkeep`.**

---
---
---

Below is a **short, clean, and exam-friendly note** explaining **custom errors vs revert()** in **very simple terms**.

---

## 🚫 Why `revert()` Alone Is Not Enough

### ❌ Basic `revert()` problem

```solidity
revert();
```

* Transaction fails ✔️
* **No reason why it failed** ❌
* Hard to debug
* Not informative for users or developers

👉 You only know **something went wrong**, not **what went wrong**

---

## ✅ Better Approach: Custom Errors

### 🔹 What are Custom Errors?

Custom errors are **named errors** defined in a contract that:

* Clearly describe **why a transaction failed**
* Use **less gas** than `require(string)`
* Can carry **extra data** for debugging

---

## 🧱 Naming Convention (Important for Exams)

📌 Best practice:

```
ContractName__ErrorDescription
```

Example:

```
Raffle__UpkeepNotNeeded
```

This immediately tells:

* Contract name → `Raffle`
* Error reason → `UpkeepNotNeeded`

---

## 🧩 Defining a Custom Error (With Parameters)

```solidity
error Raffle__UpkeepNotNeeded(
    uint256 currentBalance,
    uint256 numPlayers,
    uint256 raffleState
);
```

### 🔍 What do these parameters mean?

* `currentBalance` → ETH available in contract
* `numPlayers` → number of players registered
* `raffleState` → current raffle state (OPEN / CALCULATING)

👉 These act like **debugging information**

---

## 🔁 Using the Custom Error

```solidity
if (!upkeepNeeded) {
    revert Raffle__UpkeepNotNeeded(
        address(this).balance,
        s_players.length,
        uint256(s_raffleState)
    );
}
```

### What happens here?

* If upkeep is not required ❌
* Transaction reverts
* Error tells **exactly why it failed**

---

## ⚡ Why Custom Errors Are Better (Comparison)

| Feature       | `revert()`         | Custom Error |
| ------------- | ------------------ | ------------ |
| Error message | ❌ None             | ✅ Clear      |
| Debugging     | ❌ Hard             | ✅ Easy       |
| Gas usage     | ❌ Higher (strings) | ✅ Lower      |
| Best practice | ❌ No               | ✅ Yes        |

---

## 🧠 Easy Way to Remember (Exam Trick)

> **Custom errors = cheaper + clearer + professional Solidity**

---

## 📝 Exam-Ready Definition

> **Custom errors in Solidity provide a gas-efficient and descriptive way to handle transaction failures by clearly indicating the cause of the error.**

---

## 🔑 One-Line Summary

> Instead of using a plain `revert()`, defining custom errors like `Raffle__UpkeepNotNeeded()` gives meaningful failure reasons and improves debugging while saving gas.

---
