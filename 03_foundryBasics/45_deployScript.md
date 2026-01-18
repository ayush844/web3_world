

# 🚀 Deploying the Raffle Contract (Scripts + Config)

This section explains:

* How to create a **deployment script**
* How to manage **network-specific configuration**
* How to use **Chainlink VRF mocks** for local testing

---

## 1️⃣ Creating the Deployment Script

### 📁 File

Create a new file inside `/script`:

```
DeployRaffle.s.sol
```

### 📌 Basic Setup

```solidity
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
```

### 🧠 Important Note: Imports

There are **two ways** to import files in Solidity:

1. **Direct path**
2. **Relative path** (used here)

```solidity
../src/Raffle.sol
```

* `..` → go **one directory up**
* `src/` → enter source folder

---

## 2️⃣ DeployRaffle Contract Structure

We separate **execution** from **deployment logic**.

```solidity
contract DeployRaffle is Script {
    function run() external {
        deployContract();
    }

    function deployContract() internal returns (Raffle, HelperConfig) {
        // Implementation will go here
    }
}
```

### 🧠 Why this pattern?

* `run()` → entry point for Foundry
* `deployContract()` → reusable, test-friendly deployment logic

---

## 3️⃣ Why We Need HelperConfig

The `Raffle` constructor needs:

* `entranceFee`
* `interval`
* `vrfCoordinator`
* `gasLane`
* `subscriptionId`
* `callbackGasLimit`

⚠️ These values **change per network** (Sepolia vs Local).

➡️ Solution: **HelperConfig contract**

---

## 4️⃣ Creating `HelperConfig.s.sol`

### 📁 File

```
/script/HelperConfig.s.sol
```

### 📌 NetworkConfig Struct

```solidity
contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        uint256 subscriptionId;
    }
}
```

This struct groups **all deployment parameters** together.

---

## 5️⃣ Network-Specific Configurations

### 🔹 Sepolia Configuration

```solidity
function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    return NetworkConfig({
        entranceFee: 0.01 ether,
        interval: 30,
        vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
        gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
        callbackGasLimit: 500000,
        subscriptionId: 0
    });
}
```

---

### 🔹 Local (Anvil) Configuration

```solidity
function getLocalConfig() public pure returns (NetworkConfig memory) {
    return NetworkConfig({
        entranceFee: 0.01 ether,
        interval: 30,
        vrfCoordinator: address(0),
        gasLane: "",
        callbackGasLimit: 500000,
        subscriptionId: 0
    });
}
```

📌 Local network initially has **no VRF coordinator**.

---

## 6️⃣ Defining Chain IDs with Constants

### ❗ Why constants?

Avoid **magic numbers** → cleaner, safer, readable code.

```solidity
abstract contract CodeConstants {
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}
```

---

## 7️⃣ Initializing Network Configs

```solidity
constructor() {
    networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
}
```

This maps **chain ID → configuration**.

---

## 8️⃣ Selecting Config by Chain ID

```solidity
function getConfigByChainId(uint256 chainId)
    public
    view
    returns (NetworkConfig memory)
{
    if (networkConfigs[chainId].vrfCoordinator != address(0)) {
        return networkConfigs[chainId];
    } else if (chainId == LOCAL_CHAIN_ID) {
        return getOrCreateAnvilEthConfig();
    } else {
        revert HelperConfig__InvalidChainId();
    }
}
```

### 🧠 Logic

* If config exists → return it
* If local → create or reuse mock
* Else → revert (unsupported chain)

---

## 9️⃣ Handling Local Network (Anvil)

### 🧪 Why Mocks?

* No real Chainlink VRF locally
* Faster than testnets
* Fully controlled environment

---

## 1️⃣0️⃣ Chainlink VRF Mock

### 📁 Location

```
lib/chainlink/contracts/src/v0.8/vrf/mocks/
```

### 📌 Import the Mock

```solidity
import {VRFCoordinatorV2_5Mock} 
from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
```

---

## 1️⃣1️⃣ Completing `getOrCreateAnvilEthConfig`

### 🔹 Check if Already Created

```solidity
if (localNetworkConfig.vrfCoordinator != address(0)) {
    return localNetworkConfig;
}
```

---

### 🔹 Mock Constructor Parameters

```solidity
uint96 public constant MOCK_BASE_FEE = 0.25 ether;
uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;
```

| Variable  | Meaning              |
| --------- | -------------------- |
| base fee  | Flat VRF fee         |
| gas price | Gas used by VRF node |
| wei/link  | LINK price in ETH    |

---

### 🔹 Deploy the Mock

```solidity
vm.startBroadcast();

VRFCoordinatorV2_5Mock vrfCoordinatorMock =
    new VRFCoordinatorV2_5Mock(
        MOCK_BASE_FEE,
        MOCK_GAS_PRICE_LINK,
        MOCK_WEI_PER_UNIT_LINK
    );

vm.stopBroadcast();
```

---

### 🔹 Return Local Network Config

```solidity
return NetworkConfig({
    entranceFee: 0.01 ether,
    interval: 30,
    vrfCoordinator: address(vrfCoordinatorMock),
    gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
    subscriptionId: 0,
    callbackGasLimit: 500_000
});
```

📌 `gasLane` doesn’t matter locally.

---

## ✅ Final Outcome

✔ Automatic network detection
✔ Real VRF on Sepolia
✔ Mock VRF on Anvil
✔ Clean & reusable deployment logic

---

## 🧠 Quick Revision Summary

* `DeployRaffle` → deployment script
* `HelperConfig` → network-aware config
* Constants replace magic numbers
* Local chain uses **VRF mock**
* `vm.startBroadcast()` → deploys contracts


----
---
---


# 🧪 Testing Strategy for the Raffle Contract

Before jumping into writing tests, we **pause and plan**. This is exactly what good engineers do.

---

## 1️⃣ Testing Plan (Big Picture)

To **properly test** our Raffle contract, we need to think in layers:

### ✅ What we want to test

* Deployment correctness
* Network-specific behavior
* Chainlink VRF integration
* Contract logic (entering raffle, picking winners, etc.)

### 🧠 Where we want to test

1. **Local Chain (Anvil)**

   * Fast
   * Uses mocks
   * Best for unit tests

2. **Forked Testnet**

   * Real contract state
   * Still safe

3. **Forked Mainnet**

   * Production realism
   * No real money risk

4. **Optional: Sepolia Deployment**

   * End-to-end real-world testing

---

## 2️⃣ Overall Plan

```
✔ Write deploy scripts
✔ Write tests
✔ Support multiple networks
✔ Make everything configurable
```

So first… **deployment scripts**.

---

## 3️⃣ Creating the Deployment Script

### 📁 File

```
script/DeployRaffle.s.sol
```

---

### 📌 Initial Version (Skeleton)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {

    function run() external returns (Raffle) {

    }
}
```

---

### 🧠 What’s happening here?

| Line   | Explanation                                  |
| ------ | -------------------------------------------- |
| SPDX   | License declaration (required best practice) |
| pragma | Solidity compiler version                    |
| Script | Foundry base class for scripts               |
| Raffle | Contract we want to deploy                   |
| run()  | Entry point for `forge script`               |

📌 **Rule:** Foundry always calls `run()` when executing a script.

---

## 4️⃣ Why We Pause Deployment Here

Looking back at the plan:

> We must deploy on **multiple chains**

Each chain needs:

* Different VRF coordinator
* Different gas lane
* Possibly mocks

➡️ **Hardcoding values = bad design**

So we stop and build **HelperConfig** first.

---

## 5️⃣ Creating `HelperConfig.s.sol`

### 📁 File

```
script/HelperConfig.s.sol
```

---

### 📌 Contract Setup

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
```

---

## 6️⃣ NetworkConfig Struct

To deploy `Raffle`, we must match its constructor:

```solidity
constructor(
    uint256 entranceFee,
    uint256 interval,
    address vrfCoordinator,
    bytes32 gasLane,
    uint256 subscriptionId,
    uint32 callbackGasLimit
)
```

So we define:

```solidity
struct NetworkConfig {
    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;
}
```

### 🧠 Key Idea

👉 **Struct mirrors constructor inputs**
👉 Makes deployment clean and reusable

---

## 7️⃣ Sepolia Network Configuration

```solidity
function getSepoliaEthConfig()
    public
    pure
    returns (NetworkConfig memory)
{
    return NetworkConfig({
        entranceFee: 0.01 ether,
        interval: 30, // 30 seconds
        vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
        gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
        subscriptionId: 0, // script will create one if 0
        callbackGasLimit: 500000
    });
}
```

### 🧠 Notes

* Values come from Chainlink docs
* `subscriptionId = 0` → create later in scripts
* Gas values chosen intentionally

---

## 8️⃣ Detecting the Current Chain

We need **automatic network detection**.

### 📌 State Variable

```solidity
NetworkConfig public localNetworkConfig;
```

---

### 📌 Constructor Logic

```solidity
constructor() {
    if (block.chainid == 11155111) {
        localNetworkConfig = getSepoliaEthConfig();
    } else {
        localNetworkConfig = getOrCreateAnvilEthConfig();
    }
}
```

### 🧠 Why this is powerful

* Same code works everywhere
* No manual switching
* Safer deployments

---

## 9️⃣ Local Chain Configuration (Partial)

For now, we only handle the **already-initialized case**.

```solidity
function getOrCreateAnvilEthConfig()
    public
    returns (NetworkConfig memory anvilNetworkConfig)
{
    // Check to see if we set an active network localNetworkConfig
    if (localNetworkConfig.vrfCoordinator != address(0)) {
        return localNetworkConfig;
    }
}
```

### 🧠 Meaning

* If mocks already exist → reuse them
* If not → deploy mocks (next lesson)

---

## 🔑 Key Concepts to Remember (Exam Gold)

* **Plan before testing**
* Deployment scripts ≠ tests
* Structs mirror constructor inputs
* `block.chainid` enables multi-chain logic
* Never hardcode network values
* Local chains require **mocks**

---

