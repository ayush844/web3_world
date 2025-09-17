

### 1. **Three Main Data Locations**

Solidity can keep data in different places, but for most coding you only need to remember these three:

* **Storage**

  * Permanent.
  * Lives on the blockchain.
  * Keeps its value even after the function finishes.
  * Example: a state variable declared outside a function.

* **Memory**

  * Temporary.
  * Exists only while the function is running.
  * You can read and change it.
  * Example: local variables inside a function.

* **Calldata**

  * Temporary **and** read-only.
  * Used for function inputs that you don’t want to (or can’t) modify.
  * Cheaper than memory because it’s not copied.

---

### 2. **Key Rules**

* Strings and arrays need you to **specify** where they live (`memory` or `calldata`) when used as function parameters.

  ```solidity
  function greet(string memory name) public { ... }
  ```

* Primitive types like `uint256` don’t need `memory` or `storage` keywords—they’re handled automatically.

* Inside a function, you **can’t** declare a variable as `storage` because the function’s local variables aren’t meant to live forever.

---

### 3. **Why It Matters**

* Choosing the right location saves **gas** (fees).
* Storage is the most expensive.
* Calldata is cheapest for inputs.
* Memory is in-between.

---

**In short:**

* **Storage** = permanent, on-chain, expensive.
* **Memory** = temporary, editable, mid-cost.
* **Calldata** = temporary, read-only, cheapest.

Use each wisely to write faster, cheaper, and more secure smart contracts.
