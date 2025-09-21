

## 1️⃣ Starting Point – The Parent Contract

Suppose we already have this **SimpleStorage** contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {
    uint256 public favoriteNumber;

    function store(uint256 _newFavNumber) public virtual {
        favoriteNumber = _newFavNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}
```

Key points:

* `favoriteNumber` is a **state variable** stored on chain.
* `store()` saves a new number to `favoriteNumber`.
* `retrieve()` reads the number.
* Notice the `virtual` keyword on `store()`.

  * Without it, child contracts **cannot override** this function.

---

## 2️⃣ Inheritance – “is” Keyword

Instead of copying the whole `SimpleStorage` code to add a small feature, we **extend** it.

Create a new file `AddFiveStorage.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import { SimpleStorage } from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    // more code will come here
}
```

What’s happening:

* `import { SimpleStorage } from "./SimpleStorage.sol";`
  Brings the parent contract into scope.
* `contract AddFiveStorage is SimpleStorage`
  Means: **inherit all state variables and functions** from `SimpleStorage`.
  So `favoriteNumber`, `store()`, and `retrieve()` already exist inside this child contract.

You can deploy `AddFiveStorage` right now and it behaves exactly like `SimpleStorage`, because it automatically has those functions.

---

## 3️⃣ Adding a New Function (Optional)

You can add **extra functionality** that the parent never had:

```solidity
function sayHello() public pure returns (string memory) {
    return "Hello";
}
```

This doesn’t touch the parent’s code; it’s just an extra public function.

---

## 4️⃣ Overriding a Parent Function

Now we want to **change** how `store()` behaves:
Whenever someone calls `store(x)`, we want to save `x + 5` instead of `x`.

Steps:

### a. Match the Function Signature

The child function must have the **exact same name, parameters, and visibility** as the parent.

```solidity
function store(uint256 _newFavNumber) public override {
    favoriteNumber = _newFavNumber + 5;
}
```

### b. Use the `override` Keyword

`override` tells the compiler,

> “I know there’s a function called `store` in the parent, and I’m intentionally replacing it.”

### c. Ensure the Parent Allows Overrides

The parent’s function must be marked `virtual`.
We already added `virtual` in step 1:

```solidity
function store(uint256 _newFavNumber) public virtual {
    favoriteNumber = _newFavNumber;
}
```

If you forget `virtual` in the parent or `override` in the child, compilation fails.

---

## 5️⃣ Full Child Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import { SimpleStorage } from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {

    // Optional extra function
    function sayHello() public pure returns (string memory) {
        return "Hello";
    }

    // Override parent’s store() to add 5
    function store(uint256 _newFavNumber) public override {
        favoriteNumber = _newFavNumber + 5;
    }
}
```

---

## 6️⃣ Deploying & Testing

1. **Compile both files** in Remix with the same compiler version.
2. Deploy `AddFiveStorage`.
3. Call `store(2)`.
4. Call `retrieve()`.

You’ll get **7**, proving the override worked.

---

## 7️⃣ Key Takeaways

* **Inheritance (`is`)**
  Lets one contract reuse another’s state variables and functions.
* **virtual (parent)**
  Marks a function as “allowed to be overridden.”
* **override (child)**
  Tells the compiler you are replacing a parent’s implementation.
* **Code Reuse**
  No need to duplicate code. If you later fix a bug in `SimpleStorage`,
  every child contract that inherits it can benefit without rewriting.

---

This pattern is extremely common in Solidity:

* **Ownable** contracts (like OpenZeppelin’s) provide access control.
* **ERC20**, **ERC721**, etc., inherit base token standards and override specific hooks.

By mastering `virtual` and `override`, you can build **modular, maintainable, and upgradeable** smart contracts efficiently.
