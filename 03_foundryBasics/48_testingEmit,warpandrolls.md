
# 🧪 Testing Events & Time-Dependent Logic in Raffle

---

## 1️⃣ Testing Events in Foundry

### Goal

Ensure that **`enterRaffle()` emits the `EnteredRaffle` event** when a player enters successfully.

---

## 2️⃣ Understanding `vm.expectEmit`

Foundry does **not automatically track events**.
You must explicitly tell it:

> “I expect this exact event to be emitted next.”

This is done using the cheatcode:

```solidity
vm.expectEmit(...)
```

---

### 🔹 Step 1: Declare the Event in the Test Contract

Inside `RaffleTest.t.sol`:

```solidity
event EnteredRaffle(address indexed player);
```

📌 **Why do we redeclare the event?**

* Tests do not automatically know about contract events
* Foundry compares emitted events against the event you define here

---

## 3️⃣ Writing the Event Test

```solidity
function testEmitsEventOnEntrance() public {
    // Arrange
    vm.prank(PLAYER);

    // Act / Assert
    vm.expectEmit(true, false, false, false, address(raffle));
    emit EnteredRaffle(PLAYER);
    raffle.enterRaffle{value: entranceFee}();
}
```

---

## 4️⃣ Breaking Down `vm.expectEmit`

Signature:

```solidity
function expectEmit(
  bool checkTopic1,
  bool checkTopic2,
  bool checkTopic3,
  bool checkData,
  address emitter
) external;
```

### 🔹 What are Topics?

* **Indexed event parameters → topics**
* **Non-indexed parameters → data**

Your event:

```solidity
event EnteredRaffle(address indexed player);
```

So:

* 1 indexed parameter → `topic1`
* No other indexed params → `topic2`, `topic3`
* No unindexed params → `data`

### ✅ Correct Configuration

```solidity
vm.expectEmit(true, false, false, false, address(raffle));
```

| Argument          | Meaning                     |
| ----------------- | --------------------------- |
| `true`            | Check indexed `player`      |
| `false`           | No second indexed param     |
| `false`           | No third indexed param      |
| `false`           | No unindexed data           |
| `address(raffle)` | Event must come from Raffle |

---

## 5️⃣ Why Do We `emit` Manually in the Test?

```solidity
emit EnteredRaffle(PLAYER);
```

📌 **This does NOT emit on-chain**

Instead, it tells Foundry:

> “This is the exact event shape and values I expect next.”

Foundry then compares:

* Event name
* Indexed values
* Emitting contract

against what actually happens when:

```solidity
raffle.enterRaffle{value: entranceFee}();
```

---

### 🧠 Mental Model

```
expectEmit → define expectations
emit       → define expected event
function   → actual event emission
```

---

## 6️⃣ Testing Raffle State Restrictions (CALCULATING)

### Goal

Ensure **players cannot enter while the raffle is CALCULATING**

---

## 7️⃣ The Test Case

```solidity
function testDontAllowPlayersToEnterWhileRaffleIsCalculating() public {
    // Arrange
    vm.prank(PLAYER);
    raffle.enterRaffle{value: entranceFee}();

    vm.warp(block.timestamp + interval + 1);
    vm.roll(block.number + 1);
    raffle.performUpkeep("");

    // Act / Assert
    vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
    vm.prank(PLAYER);
    raffle.enterRaffle{value: entranceFee}();
}
```

---

## 8️⃣ Understanding `vm.warp` & `vm.roll`

### 🔹 `vm.warp`

```solidity
vm.warp(newTimestamp);
```

* Sets `block.timestamp`
* Used for **time-based logic**

### 🔹 `vm.roll`

```solidity
vm.roll(newBlockNumber);
```

* Sets `block.number`
* Needed because some logic checks block progression

📌 **Why both?**

* Chainlink Keepers (and many protocols) rely on **time + block movement**

---

### Other Time Cheatcodes (FYI)

| Cheatcode   | Purpose                          |
| ----------- | -------------------------------- |
| `skip(x)`   | Move time forward by `x` seconds |
| `rewind(x)` | Move time backward               |

---

## 9️⃣ What This Test Is Doing (Step-by-Step)

1. PLAYER enters raffle ✅
2. Time moves forward beyond interval ⏳
3. Block number advances ⛓
4. `performUpkeep()` runs → raffle enters `CALCULATING`
5. PLAYER tries to enter again ❌
6. Test expects revert: `Raffle__RaffleNotOpen`

---

## 🔥 Why the Test Fails (Important!)

Error:

```
[FAIL. Reason: InvalidConsumer()]
```

📌 **Key Insight**

* `performUpkeep()` internally calls **Chainlink VRF**
* Your test environment **is not yet properly configured as a valid VRF consumer**
* This failure is **expected at this stage**

👉 **This will be fixed later** when:

* VRF mocks are wired correctly
* Subscription & consumer setup is completed

---

## 🧠 One-Line Interview Notes

* **`expectEmit`**: Used to assert that a specific event is emitted
* **Manual `emit` in tests**: Defines the expected event signature
* **`vm.warp`**: Manipulates block timestamp
* **`vm.roll`**: Manipulates block number
* **CALCULATING state**: Prevents new raffle entries
* **InvalidConsumer error**: VRF mock not fully configured yet

---

## ✅ What You’ve Learned Here

✔ How Foundry validates events
✔ Why indexed params matter
✔ Time & block manipulation in tests
✔ Testing state-dependent reverts
✔ Why some failures are **expected** during staged development

---

