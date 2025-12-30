
# 🔄 Resetting the Player Array & CEI Pattern 

This lesson finishes **one full raffle cycle** and introduces a **critical Solidity security pattern**.

---

## PART 1: Resetting the Player Array

### ❓ The Problem

We already:

* Picked a winner
* Paid the prize
* Re-opened the raffle

But…
👉 **The old players are still in the array**

That’s wrong because:

* They already participated
* They shouldn’t be considered again
* Each raffle round must be **independent**

---

## ✅ Solution: Reset the Players Array

```solidity
s_players = new address payable;
```

### What this line actually does

* Creates a **brand new empty array**
* Replaces the old array
* Old players are **discarded**
* Gas-efficient and clean

🧠 Think of it as:

> “Throw away the old raffle ticket box and bring a new empty one.”

---

## 🕒 Reset the Raffle Timer

Since a **new raffle round** is starting, we must reset the timestamp:

```solidity
s_lastTimeStamp = block.timestamp;
```

Why?

* The interval logic depends on this timestamp
* Without resetting it, the next raffle timing would be broken

---

## 📢 Emitting the Winner Event

### Why emit an event?

* Frontend needs to know who won
* Indexers & explorers rely on events
* Events are the **official on-chain record**

### Define the event

```solidity
event PickedWinner(address winner);
```

### Emit it after everything succeeds

```solidity
emit PickedWinner(winner);
```

📌 Emitting it **last** guarantees:

* Winner was selected
* ETH was sent
* State was reset

---

## 🧩 Final `fulfillRandomWords` (Conceptual Flow)

Inside `fulfillRandomWords` we now do:

1. Pick winner using modulo
2. Store winner
3. Reset raffle state to OPEN
4. Reset players array
5. Reset timestamp
6. Send ETH prize
7. Emit `PickedWinner`

➡️ **One complete raffle lifecycle**

---

# 🔐 PART 2: Checks–Effects–Interactions (CEI) Pattern

This is one of the **most important security patterns in Solidity**.

---

## ❓ What Is the CEI Pattern?

CEI means structuring functions in this order:

1. **Checks** – validate conditions
2. **Effects** – update internal state
3. **Interactions** – external calls

This pattern:

* Prevents reentrancy attacks
* Saves gas
* Makes code predictable and safe

---

## 🚫 Bad Example (No CEI)

```solidity
function coolFunction() public {
    sendA();
    callB();
    checkX();
    checkY();
    updateM();
}
```

### What’s wrong here?

* External calls happen **before checks**
* If `checkX()` fails:

  * `sendA()` and `callB()` already ran
  * Everything must be reverted
  * Gas is wasted
  * Risk of reentrancy

---

## ✅ Correct CEI Example

```solidity
function coolFunction() public {
    // Checks
    checkX();
    checkY();

    // Effects
    updateStateM();

    // Interactions
    sendA();
    callB();
}
```

### Why this is better

* Fail early → save gas
* State is updated **before** external calls
* External calls can’t exploit stale state

---

## 🧠 How CEI Applies to Your Raffle

In `fulfillRandomWords`, you effectively follow CEI:

### ✅ Checks

* (Implicit) VRF validation already done by base contract

### ✅ Effects

* Set `s_recentWinner`
* Set `s_raffleState = OPEN`
* Reset `s_players`
* Update `s_lastTimeStamp`

### ✅ Interactions

* Send ETH to winner using `.call`

📌 This order is **intentional and critical**

---

## 🔐 Why CEI Prevents Reentrancy

If you sent ETH **before** resetting state:

* A malicious contract could re-enter
* Players array might still exist
* Funds could be drained

CEI ensures:

> “By the time ETH is sent, the contract is already safe.”

---

## 🏁 Key Takeaways (Revision Gold ✨)

* Reset players after each raffle
* Reset timestamp for new interval
* Emit events for transparency
* Follow CEI pattern religiously
* Checks first → fail fast
* Effects second → lock state
* Interactions last → safe external calls

---

## 🧠 Mental Model

> **Finish everything internally before touching the outside world**

That’s CEI.

---

