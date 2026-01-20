
# 📦 Deploying & Testing the Raffle (Lottery) Contract

*(Foundry + Solidity)*

---

## 1️⃣ Deploying the Raffle Contract

### Goal

Deploy the `Raffle` contract using **network-specific configuration** (local, testnet, mainnet) via `HelperConfig`.

---

### 📁 File: `DeployRaffle.s.sol`

#### Step 1: Import HelperConfig

```solidity
import {HelperConfig} from "./HelperConfig.s.sol";
```

👉 `HelperConfig` provides network-specific values like:

* entrance fee
* VRF coordinator
* gas lane
* subscription ID

---

#### Step 2: Update `run()` Function

```solidity
function run() external returns (Raffle, HelperConfig) {
    HelperConfig helperConfig = new HelperConfig(); // includes mocks for local testing
```

---

#### Step 3: Deconstruct Network Config

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

📌 **Why this matters**

* Different networks need different values
* `HelperConfig` abstracts this complexity away

---

#### Step 4: Deploy the Raffle Contract

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

📌 **Important Concepts**

* `vm.startBroadcast()` → tells Foundry “this is a real transaction”
* Deployment itself is a transaction
* Returning both contracts helps testing later

---

### ✅ Summary of Deployment Flow

```
DeployRaffle
   └── creates HelperConfig
        └── provides network values
             └── deploys Raffle with those values
```

---

## 2️⃣ Setting Up Testing Structure

### Folder Structure

```
test/
 ├── unit/
 │    └── RaffleTest.t.sol
 └── integration/
```

* **Unit tests** → test Raffle logic in isolation
* **Integration tests** → test how contracts interact together

---

## 3️⃣ Writing the Unit Test Contract

### 📁 File: `RaffleTest.t.sol`

#### Imports

```solidity
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
```

📌 These allow:

* Deploying contracts
* Accessing cheatcodes (`vm`)
* Running assertions

---

### Test Contract Skeleton

```solidity
contract RaffleTest is Test {
}
```

---

## 4️⃣ State Variables & Setup

### State Variables

```solidity
Raffle public raffle;
HelperConfig public helperConfig;

uint256 entranceFee;
uint256 interval;
address vrfCoordinator;
bytes32 gasLane;
uint256 subscriptionId;
uint32 callbackGasLimit;
```

---

### Test Player Setup

```solidity
address public PLAYER = makeAddr("player");
uint256 public constant STARTING_USER_BALANCE = 10 ether;
```

---

### `setUp()` Function (Runs Before Every Test)

```solidity
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
```

📌 **What happens here**

1. Deploy contracts
2. Give test user ETH
3. Load config values for tests

---

## 5️⃣ First Test: Initial State

### Add Getter in `Raffle.sol`

```solidity
function getRaffleState() public view returns (RaffleState) {
    return s_raffleState;
}
```

---

### Test: Raffle Starts OPEN

```solidity
function testRaffleInitializesInOpenState() public view {
    assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
}
```

📌 **Why this works**

* `RaffleState` is an enum
* Accessed as `Raffle.RaffleState.OPEN`

---

### Run Test

```bash
forge test --mt testRaffleInitializesInOpenState -vv
```

✅ Test passes → contract starts correctly

---

## 6️⃣ Testing Reverts (Negative Testing)

### Test: Revert If Not Enough ETH Sent

```solidity
function testRaffleRevertsWhenYouDontPayEnough() public {
    vm.prank(PLAYER);

    vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);
    raffle.enterRaffle();
}
```

📌 **Key Ideas**

* `vm.prank()` → pretend to be PLAYER
* `vm.expectRevert()` → assert failure
* `.selector` → identifies exact custom error

---

## 7️⃣ Testing State Changes (Player Entry)

### Test: Player Is Recorded

```solidity
function testRaffleRecordsPlayersWhenTheyEnter() public {
    vm.prank(PLAYER);

    raffle.enterRaffle{value: entranceFee}();

    address playerRecorded = raffle.getPlayer(0);
    assert(playerRecorded == PLAYER);
}
```

---

### Missing Getter → Add in `Raffle.sol`

```solidity
function getPlayer(uint256 index) external view returns (address) {
    return s_players[index];
}
```

---

### Common Bug: Out Of Funds ❌

💥 Error occurs because PLAYER has no ETH.

✅ Fix (already in `setUp()`):

```solidity
vm.deal(PLAYER, STARTING_USER_BALANCE);
```

---

### Run Test Verbosely

```bash
forge test --mt testRaffleRecordsPlayersWhenTheyEnter -vvvv
```

✅ Passes!

---

## 🧠 Big Picture Mental Model

```
DeployRaffle
   └── HelperConfig
        └── Network Values
             └── Raffle Deployment
                   └── Unit Tests
                         ├── Initial State
                         ├── Revert Conditions
                         └── State Updates
```

---

## 🚀 What You’ve Achieved So Far

✔ Network-aware deployment
✔ Proper Foundry setup
✔ Unit testing with cheatcodes
✔ Testing reverts & state updates
✔ Writing production-grade Solidity tests

---
