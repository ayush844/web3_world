

## **Solidity Libraries & PriceConverter Example**

### 1️⃣ **Why Use a Library?**

* Libraries help **reuse common code** (e.g., price conversion) across multiple contracts.
* Prevents code duplication and makes maintenance easier.
* Ideal for utility functions like `getPrice()` and `getConversionRate()` which are needed in multiple places.

---

### 2️⃣ **What is a Solidity Library?**

* Similar to a contract **but with restrictions**:

  * ❌ **No state variables** (cannot store data on the blockchain).
  * ❌ **Cannot receive ETH** directly.
* Functions inside a library can:

  * Be **internal**: embedded directly into the contract using the library.
  * Be **public/external**: if so, the library must be **deployed separately** and then linked.

> **Rule of Thumb:**
> For simple reusable logic, make functions **internal** so the compiler embeds them automatically.

---

### 3️⃣ **Creating the PriceConverter Library**

**File:** `PriceConverter.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // ✅ Fetch the current ETH price in USD (with 18 decimals)
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed =
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // Sepolia ETH/USD feed
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10); // Convert from 8 to 18 decimals
    }

    // ✅ Convert ETH amount (in wei) to USD (18 decimals)
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
```

**Key Points**

* `internal view`:

  * `internal` lets the main contract use these functions directly.
  * `view` ensures no state changes occur.
* `AggregatorV3Interface`: fetches live ETH/USD prices from Chainlink.

---

### 4️⃣ **Using the Library in a Contract**

**In `FundMe.sol` (or another contract):**

```solidity
pragma solidity ^0.8.18;
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256; // 👈 Attach library to uint256 type

    uint256 public minimumUsd = 5 * 1e18;

    function fund() public payable {
        // 👇 Library function used like it's part of uint256
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough ETH");
    }
}
```

**How It Works:**

* `using PriceConverter for uint256;`
  ➜ Extends all `uint256` variables with library functions.
* `msg.value.getConversionRate()`
  ➜ The `msg.value` (amount of ETH sent) is **automatically passed** as the first parameter to `getConversionRate()`.

---

### 5️⃣ **Passing Additional Arguments**

If a library function requires more parameters:

```solidity
uint256 result = msg.value.getConversionRate(123);
```

Here:

* `msg.value` is the **first implicit argument**.
* `123` is explicitly passed as the second argument.

---

### 6️⃣ **Benefits of Libraries**

* ✅ **Code Reuse**: No need to copy `getPrice` or `getConversionRate` into every contract.
* ✅ **Gas Efficient**: Internal libraries are inlined during compilation, so no extra contract calls.
* ✅ **Clean Code**: Keeps main contract small and readable.

---

### 7️⃣ **When to Deploy a Library Separately**

* Only if you need **public/external** functions.
* Then:

  * Deploy the library first.
  * Link its address to the main contract at deployment.

---

### ✅ **Summary**

* **Libraries** in Solidity = reusable, stateless code modules.
* Functions should be **internal** for embedding into contracts.
* Example: `PriceConverter` library fetches ETH/USD price and converts ETH to USD.
* Attach with `using PriceConverter for uint256;` to call as `msg.value.getConversionRate()`.
* Keeps contracts modular, gas-efficient, and easier to maintain.

---
