
# 👥 Tracking Participants in the Raffle Contract

## 🎯 Goal

After a user pays the entrance fee, we must:

* **Record their participation**
* Maintain a list of participants
* Later **select a winner fairly**

---

## 🧠 Choosing the Right Data Structure

### Options Considered

| Option                     | Why it’s NOT ideal        |
| -------------------------- | ------------------------- |
| `mapping(address => bool)` | ❌ Cannot be iterated over |
| Multiple address variables | ❌ Not scalable            |
| **Dynamic Array**          | ✅ Best solution           |

### ✅ Final Choice

> **Dynamic array of addresses**

---

## 🧱 Why an Array Is the Correct Choice

* We need to:

  * Loop through participants
  * Randomly pick a winner
* Arrays:

  * Are iterable
  * Grow dynamically
  * Preserve order

---

## 📦 Declaring the Players Array

```solidity
address payable[] private s_players;
```

### Why `address payable`?

* The winner will receive ETH
* Only `payable` addresses can receive ETH via `.call`

📌 **Design foresight** → fewer refactors later

---

## 🔄 Updating State in `enterRaffle`

### Updated Function

```solidity
function enterRaffle() external payable {
    if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
    s_players.push(payable(msg.sender));
}
```

### What Happens Here

* ETH is sent → validated
* Sender’s address added to array
* Contract state is modified

---

## 🧠 `.push()` Explained

```solidity
s_players.push(payable(msg.sender));
```

* Appends element to the array
* Increases array length by 1
* Writes to contract storage

---

## 📢 Why Events Are Needed

### Problem

Smart contracts:

* Can’t “notify” frontends directly
* Don’t push updates

### Solution

👉 **Events**

---

## 🔔 Events Explained (VERY IMPORTANT)

### What Are Events?

* Logs emitted by smart contracts
* Stored in **blockchain logs**
* Easily read by:

  * Frontends
  * Indexers
  * Off-chain services

📌 Events are:

* Cheap
* Searchable
* Immutable

---

## 🔍 Indexed vs Non-Indexed Event Parameters

### Example

```solidity
event BTCUSDCupdated(
    uint256 indexed oldER,
    uint256 indexed newER,
    uint256 timestamp,
    address sender
);
```

### Key Insight

| Parameter Type | Purpose                    |
| -------------- | -------------------------- |
| `indexed`      | Easy filtering & searching |
| non-indexed    | Extra data, not searchable |

📌 Up to **3 indexed fields** per event

---

## 🧱 Defining the Raffle Event

### Event Declaration (Correct Layout)

```solidity
event EnteredRaffle(address indexed player);
```

📌 Goes under **Events** section in contract layout

---

## 🚀 Emitting the Event

### Final `enterRaffle` Implementation

```solidity
function enterRaffle() external payable {
    if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
    s_players.push(payable(msg.sender));
    emit EnteredRaffle(msg.sender);
}
```

### What This Achieves

* Player added to storage
* Event logged
* Frontend can:

  * Listen for `EnteredRaffle`
  * Update UI instantly

---

## 🧠 When Should You Emit Events?

✅ Always emit events when:

* State changes
* Funds move
* Users interact
* Important actions occur

❌ Do NOT emit events for:

* Pure/view functions
* Internal-only logic

---

## 🏗️ Clean Contract Section (So Far)

```solidity
error Raffle__NotEnoughEthSent();

contract Raffle {
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }
}
```

---

## 🏁 Key Takeaways (Revision Gold ✨)

* Dynamic arrays are ideal for participant tracking
* Mappings can’t be looped over
* Use `address payable` when ETH transfer is required
* Emit events on every meaningful state change
* Indexed event fields allow efficient searching
* Events are essential for frontend syncing

---
