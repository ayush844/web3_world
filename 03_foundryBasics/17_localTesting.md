

# 🧪 **Testing Locally in Foundry Using Mocks**

---

## 🎯 **Objective**

After refactoring our contracts to remove hardcoded addresses (like Sepolia’s Chainlink price feed), our project became more flexible — but we still relied on live networks for testing.

Now we’ll **remove that dependency** entirely and learn how to test everything **locally** using **mock contracts**.

---

## ⚙️ **Why Local Testing Matters**

Relying on live networks (like Sepolia) for every test:

* ❌ Slows down development
* ❌ Requires an internet connection & RPC keys
* ❌ Increases risk of breaking live contracts
* ❌ Makes testing expensive and inconsistent

By testing locally:

* ✅ You simulate real conditions without network calls
* ✅ You can run tests offline using **Anvil**
* ✅ You can test refactorings without affecting live contracts
* ✅ You can ensure that all logic works before deploying

The key to this approach is a **mock contract**.

---

## 🧩 **What Is a Mock Contract?**

A **mock contract** is a lightweight, fake version of a real contract used for testing.

It imitates the behavior of another contract (like a Chainlink price feed) so your tests can run locally without needing the real external dependency.

---

## 🧱 **Step 1: Create a HelperConfig Script**

Create a new file in the `script` folder:

```
script/HelperConfig.s.sol
```

This script will:

* Detect which chain we’re deploying or testing on
* Deploy **mock contracts** when running locally
* Store all **chain-specific configurations** (like price feed addresses)

---

### 🔧 **Base Structure**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // If we are on local Anvil, we deploy mocks
    // Else, grab existing addresses from live networks
}
```

---

## 🧩 **Step 2: Define a Network Configuration**

We’ll define a struct to store network-specific details:

```solidity
struct NetworkConfig {
    address priceFeed; // ETH/USD price feed address
}
```

Now add two functions — one for Sepolia and one for Anvil:

```solidity
function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory sepoliaConfig = NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepoliaConfig;
}

function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
    // We’ll fill this in later to deploy a mock contract.
}
```

---

## 🔄 **Step 3: Dynamically Select the Active Network**

Add a **constructor** that detects the network using `block.chainid` and sets the active configuration.

```solidity
NetworkConfig public activeNetworkConfig;

constructor() {
    if (block.chainid == 11155111) {
        activeNetworkConfig = getSepoliaEthConfig();
    } else {
        activeNetworkConfig = getAnvilEthConfig();
    }
}
```

### 💡 What’s happening here:

* `block.chainid` → unique ID of the current network

  * e.g., 11155111 for Sepolia
  * 31337 for Anvil
* Depending on `chainid`, the script picks the correct config

👉 You can find any chain’s ID on [chainlist.org](https://chainlist.org).

---

## 🧰 **Step 4: Integrate HelperConfig in the Deploy Script**

Open `script/DeployFundMe.s.sol` and **import HelperConfig**:

```solidity
import {HelperConfig} from "./HelperConfig.s.sol";
```

Inside your `run()` function, before broadcasting, add:

```solidity
HelperConfig helperConfig = new HelperConfig();
address ethUsdPriceFeed = helperConfig.activeNetworkConfig.priceFeed;
```

Now replace the hardcoded priceFeed address with this variable:

```solidity
vm.startBroadcast();
FundMe fundMe = new FundMe(ethUsdPriceFeed);
vm.stopBroadcast();
return fundMe;
```

---

## ✅ **Step 5: Test the Setup on Sepolia**

Run your tests using the forked Sepolia chain to confirm everything still works:

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

All tests should pass ✅

---

## 🌍 **Step 6: Add Config for Multiple Chains (Optional)**

To support additional networks like **Arbitrum**, **Polygon**, or **Base**,
just copy the `getSepoliaEthConfig()` function, rename it, and replace the address.

Example:

```solidity
function getArbitrumEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory arbConfig = NetworkConfig({
        priceFeed: 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612
    });
    return arbConfig;
}
```

Then add another condition in the constructor:

```solidity
if (block.chainid == 42161) {
    activeNetworkConfig = getArbitrumEthConfig();
}
```

With this setup, switching between chains is as simple as changing your **RPC_URL**.

---

## 🧱 **Step 7: Solving the Anvil Problem**

When testing locally, we use **Anvil**, but the Chainlink price feed contract doesn’t exist there.

➡️ The solution: **Deploy a mock price feed** on Anvil.

---

### 🧰 Create a Mock Contract

Inside the `test` folder, create a new folder `mocks/` and add a new file:

```
test/mocks/MockV3Aggregator.sol
```

Paste the contents of the mock Aggregator contract (you can find this in Chainlink’s GitHub or course materials).
This mock mimics the behavior of the `AggregatorV3Interface`.

---

### ⚙️ Update HelperConfig to Deploy the Mock

We’ll import `Script` and `MockV3Aggregator`, then make `HelperConfig` inherit from `Script`.

```solidity
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    MockV3Aggregator mockPriceFeed;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
```

---

### 🧠 Breakdown

| Component                                    | Purpose                                                                      |
| -------------------------------------------- | ---------------------------------------------------------------------------- |
| `vm.startBroadcast()` / `vm.stopBroadcast()` | Simulates deployment transactions on Anvil                                   |
| `MockV3Aggregator(8, 2000e8)`                | Creates a mock Chainlink price feed with 8 decimals and ETH price = 2000 USD |
| `NetworkConfig`                              | Stores and returns the deployed mock’s address                               |
| `activeNetworkConfig`                        | Automatically holds the correct config for the current chain                 |

---

## 🧪 **Step 8: Test Everything Locally**

Run your tests normally (without forking):

```bash
forge test
```

Now:

* The deploy script uses the **mock price feed** when running on Anvil
* Tests execute **entirely locally**
* No RPCs, no API keys, no external dependencies

✅ **All tests should pass locally**

---

## 🧩 **Benefits of This Setup**

| Benefit         | Description                                           |
| --------------- | ----------------------------------------------------- |
| **Speed**       | Tests run instantly, no network latency               |
| **Safety**      | Avoids interacting with live networks                 |
| **Automation**  | Mock deployment handled automatically                 |
| **Flexibility** | Works across local, testnet, and mainnet environments |
| **Scalability** | Easily add more network configurations later          |

---

## 📘 **Summary**

| Step | Action                                | Outcome                      |
| ---- | ------------------------------------- | ---------------------------- |
| 1    | Created `HelperConfig.s.sol`          | Holds chain-specific data    |
| 2    | Added Sepolia config                  | Uses real Chainlink address  |
| 3    | Added dynamic constructor             | Detects active chain         |
| 4    | Integrated with `DeployFundMe.s.sol`  | Dynamically sets `priceFeed` |
| 5    | Created `MockV3Aggregator.sol`        | Simulates Chainlink oracle   |
| 6    | Updated `HelperConfig` to deploy mock | Deploys locally on Anvil     |
| 7    | Ran tests locally                     | All pass without needing RPC |

---

## 🧠 **Key Takeaways**

* **Mocks** make local testing possible and reliable.
* **HelperConfig** centralizes all network-related data.
* **Anvil + Mocks = fast, risk-free development.**
* This approach scales — you can add multiple networks easily.
* Professional developers **always test locally first** before touching a live chain.

---

## 🧩 **Next Steps**

In the upcoming lessons:

* You’ll **integrate Anvil** fully into your workflow.
* Learn how to **automate local testing setups**.
* And continue increasing **test coverage** while reducing network dependency.

---

