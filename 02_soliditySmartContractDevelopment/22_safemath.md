

## **SafeMath & Integer Overflow**

### 1️⃣ Problem: Integer Overflow (Pre–Solidity 0.8)

* **Overflow/Underflow**:

  * Happens when an integer goes **beyond its max or min limit**.
  * Example with `uint8` (0 → 255):

    ```solidity
    uint8 x = 255;
    x = x + 1;  // Before 0.8 ➜ wraps to 0 (overflow)
    ```
* **Impact**: Wrong calculations, potential exploits, and security risks.

---

### 2️⃣ SafeMath Library (Before v0.8)

* **Purpose**: Prevent silent overflows/underflows by reverting the transaction if a math operation exceeded limits.
* **Usage**:

  ```solidity
  function add(uint a, uint b) public pure returns (uint) {
      uint c = a + b;
      require(c >= a, "SafeMath: addition overflow");
      return c;
  }
  ```
* Imported from **OpenZeppelin** and used widely in older Solidity code.

---

### 3️⃣ Example: Pre-0.8 Behavior

**File:** `SafeMathTester.sol`

```solidity
pragma solidity ^0.6.0;

contract SafeMathTester {
    uint8 public bigNumber = 255;

    function add() public {
        bigNumber = bigNumber + 1; // wraps to 0 (overflow!)
    }
}
```

* With Solidity 0.6:

  * Calling `add()` changes `bigNumber` from **255 → 0**.
  * No error thrown.

---

### 4️⃣ Solidity 0.8 Upgrade

* **Automatic Overflow Checks**:

  * From v0.8 onward, **all arithmetic is checked by default**.
  * Overflow/underflow now **reverts the transaction** with an error.
* Deploying the same contract with `pragma solidity ^0.8.0`:

  * `add()` will **revert** instead of wrapping to 0.

---

### 5️⃣ The `unchecked` Keyword

* For gas savings when you **know** overflow cannot happen:

  ```solidity
  uint8 public bigNumber = 255;

  function add() public {
      unchecked {
          bigNumber = bigNumber + 1; // wraps to 0 again
      }
  }
  ```
* **Caution**: Reintroduces old risks—only use when 100% safe.

---

### 6️⃣ Key Takeaways

* **Before 0.8**:

  * Must use **SafeMath** to protect against overflow/underflow.
* **After 0.8**:

  * Built-in checks make SafeMath mostly **obsolete**.
* **Unchecked Block**:

  * Optional tool to skip checks for **gas efficiency**, but use carefully.

---

### ✅ Summary Table

| Solidity Version | Default Behavior                  | Recommended Practice                                       |
| ---------------- | --------------------------------- | ---------------------------------------------------------- |
| < 0.8.0          | No checks → wraps on overflow     | Use `SafeMath` library                                     |
| ≥ 0.8.0          | Auto-revert on overflow/underflow | SafeMath optional; use `unchecked` for micro-optimizations |

---

### 🔑 Insight

SafeMath’s history shows how Solidity evolved:

* **Older contracts** may still import SafeMath for backward compatibility.
* Understanding SafeMath is important for **auditing legacy code** and appreciating Solidity’s built-in safety features today.

---
