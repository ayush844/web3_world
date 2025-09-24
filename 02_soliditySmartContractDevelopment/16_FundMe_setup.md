

## 📝 FundMe Smart Contract setup – Full Notes

### Goal

Create a **crowdfunding contract** that:

1. Lets anyone send ETH to the contract.
2. Allows **only the owner** to withdraw the funds.
3. Enforces a **minimum funding amount** (in USD or ETH).

---

## 1️⃣ Project Setup

* **Remix IDE**: Start fresh—delete default files, create `FundMe.sol`.
* Always write down the logic in **plain English** before coding.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    function fund() public payable {}
    // function withdraw() public {}  // to be added later
}
```

---

## 2️⃣ Accepting ETH

### payable & msg.value

* **payable**: allows a function to **receive ETH**.
* **msg.value**: amount of ETH (in Wei) sent with the call.

```solidity
function fund() public payable {
    // access ETH sent using msg.value
}
```

---

## 3️⃣ Minimum Funding Requirement

* **require(condition, "error message")**:
  Stops execution and reverts state if condition is false.
* Units:

  * `1 ether` = `1e18 wei`
  * `1 gwei` = `1e9 wei`

```solidity
function fund() public payable {
    require(msg.value >= 1 ether, "Didn't send enough ETH");
    // logic if requirement passes
}
```

🔗 **Why require?**
Ensures the contract only accepts deposits ≥ 1 ETH.

---

## 4️⃣ Understanding Revert

* If `require` fails, **all state changes roll back**.
* Example:

```solidity
uint256 public myValue = 1;

function fund() public payable {
    myValue = myValue + 2;
    require(msg.value > 1 ether, "Not enough ETH");
    // If require fails: myValue stays 1
}
```

* **Gas use on revert**:
  *Gas already spent on executed steps is lost*, but unused gas is returned.

---

## 5️⃣ Gas Basics

* **Gas** = computational cost of running code on the EVM.
* Sender specifies:

  * **Gas price** (wei per unit)
  * **Gas limit** (max units to consume)
* If code finishes early, unused gas is refunded.

---

## 6️⃣ Ethereum Transaction Fields

### For a **simple value transfer**

| Field    | Purpose                                     |
| -------- | ------------------------------------------- |
| nonce    | Sender’s transaction count                  |
| gasPrice | Max wei per gas unit                        |
| gasLimit | Max gas units to use                        |
| to       | Recipient address                           |
| value    | Amount of ETH (wei) sent                    |
| data     | Empty                                       |
| v, r, s  | Signature components (authenticates sender) |

### For a **contract interaction**

Same as above **but** `data` contains:

* Encoded function name + parameters.

---

## 7️⃣ Key Takeaways

* `payable` enables receiving ETH.
* `msg.value` is the sent amount (in Wei).
* `require` checks conditions and **reverts** on failure.
* Revert = **undo all state changes**, refund remaining gas.
* Gas costs are always paid for executed steps, even on revert.
* Transactions carry fields like nonce, gasPrice, gasLimit, value, data, and signature.

---

## Example: Minimum-1-ETH Fund Function

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    uint256 public myValue = 1;

    function fund() public payable {
        myValue = myValue + 2;
        require(msg.value >= 1 ether, "Didn't send enough ETH");
    }
}
```

This captures **all key mechanics**: receiving ETH, using `msg.value`, enforcing a minimum, and demonstrating how revert and gas work.
