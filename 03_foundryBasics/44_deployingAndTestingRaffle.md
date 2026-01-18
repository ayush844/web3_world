
# 🚀 Deploying and Testing the Raffle (Lottery)

This section covers **deploying the Raffle contract** and **writing unit tests** for it using **Foundry**.

---

## 1️⃣ Deploying the Raffle Contract

### 🔹 Goal

Deploy the `Raffle` contract using values provided by a helper contract (`HelperConfig`) so that:

* Deployment works across different networks
* Mock contracts are used locally
* Configuration is reusable

---

## 2️⃣ Updating `DeployRaffle.s.sol`

### 📌 Step 1: Import `HelperConfig`

```solidity
import {HelperConfig} from "./HelperConfig.s.sol";
```

This helper contract provides **network-specific configuration**, including mocks when running locally.

---

### 📌 Step 2: Modify the `run()` Function

```solidity
function run() external returns (Raffle, HelperConfig) {
    HelperConfig helperConfig = new HelperConfig(); // Includes mocks
```

---

### 📌 Step 3: Destructure the Network Config

```solidity
(
    uint256 entranceFee,
    uint256 interval,
    address vrfCoordinator,
    bytes32 gasLane,
    uint256 subscriptionId,
    uint32 callbackGasLimit
) = helperConfig.getConfig();
```

✅ Now we have **all values required to deploy the Raffle**.

---

### 📌 Step 4: Deploy the Contract

```solidity
vm.startBroadcast();

Raffle raffle = new Raffle(
    entranceFee,
    interval,
    vrfCoordinator,
    gasLane,
    subscriptionId,
    callbackGasLimit
);

vm.stopBroadcast();

return (raffle, helperConfig);
```

### 🧠 Explanation

* `vm.startBroadcast()` → start sending transactions
* `new Raffle(...)` → deploys the contract
* `vm.stopBroadcast()` → stops broadcasting
* We return **both** `raffle` and `helperConfig` for testing

⚠️ **Note:**
`subscriptionId` is currently hardcoded or mocked. Later, we’ll automate its creation/refactoring.

---

## 3️⃣ Setting Up Tests

### 📁 Folder Structure

Inside `test/`:

```
test/
├── integration/
└── unit/
    └── RaffleTest.t.sol
```

---

## 4️⃣ Writing the Unit Test (`RaffleTest.t.sol`)

### 📌 Boilerplate Setup

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {

}
```

### 🧠 What’s happening?

* `DeployRaffle` → deploys contracts for testing
* `Raffle` → contract under test
* `Test` → Foundry testing utilities

---

## 5️⃣ State Variables & `setUp()` Function

### 📌 Full Setup Code

```solidity
contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();

        vm.deal(PLAYER, STARTING_USER_BALANCE);

        (
            entranceFee,
            interval,
            vrfCoordinator,
            gasLane,
            subscriptionId,
            callbackGasLimit
        ) = helperConfig.getConfig();
    }
}
```

---

### 🧠 Breakdown (Important for Exams)

#### ✔️ `Test` Inheritance

Enables:

* `vm.deal`
* `vm.prank`
* Assertions

#### ✔️ Contract References

```solidity
Raffle public raffle;
HelperConfig public helperConfig;
```

Stores deployed contracts for reuse.

#### ✔️ Player Setup

```solidity
address public PLAYER = makeAddr("player");
vm.deal(PLAYER, 10 ether);
```

Creates a fake user with ETH balance.

#### ✔️ `setUp()` Function

Runs **before every test**:

* Deploys contracts
* Assigns ETH
* Loads config values

---

## 6️⃣ Adding a Getter in `Raffle.sol`

To test internal state, add:

```solidity
function getRaffleState() public view returns (RaffleState) {
    return s_raffleState;
}
```

📌 This exposes the raffle’s current state.

---

## 7️⃣ Writing the First Unit Test

### 🧪 Test: Initial State Should Be `OPEN`

```solidity
function testRaffleInitializesInOpenState() public view {
    assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
}
```

### 🧠 Why `Raffle.RaffleState.OPEN`?

* `RaffleState` is an `enum`
* Enums are **types**
* We access them via the contract namespace

---

## 8️⃣ Running the Test

```bash
forge test --mt testRaffleInitializesInOpenState -vv
```

### ✅ Output

```
[PASS] testRaffleInitializesInOpenState()
```

✔️ Confirms:

* Deployment works
* Initial raffle state is correct

---

## 🎯 Key Takeaways (Quick Revision)

* `HelperConfig` centralizes network settings
* `vm.startBroadcast()` → real transaction
* `setUp()` runs before **every test**
* Unit tests validate **contract behavior**
* Enums are accessed via `Contract.Enum.VALUE`

---
