

# 1) Basic units: bits, nibbles, bytes, words, hex

* **bit** = 1 binary digit (0 or 1).
* **nibble** = 4 bits. One hex digit represents one nibble (0..f).

  * Example: hex `0x1` = binary `0001`.
* **byte** = 8 bits = 2 hex digits (a nibble pair).

  * Example: hex `0x01` = binary `00000001`.
* **word in EVM** = **32 bytes** = **256 bits** = **64 hex digits**.

  * Example of a 32-byte word:

    ```
    0x0000000000000000000000000000000000000000000000000000000000000001
    ```

    That's 63 zero hex digits + `1` at the end — 64 hex digits total.

So when you wrote `ox00000.....01` (typo `ox` → `0x`) — that matches the canonical way EVM shows a 256-bit word with a value 1: it's a 32-byte word with all leading zeros and `0x01` as the least-significant byte.

---
 **one hex digit = 4 bits**.

Here’s why:

* Hexadecimal (base-16) has **16 possible values** (0–F).
* Binary (base-2) needs **4 bits** to represent 16 values (because (2^4 = 16)).
* So each hex digit maps exactly to **4 binary digits (bits)**.

Examples:

| Hex | Binary (4 bits) |
| --- | --------------- |
| 0   | 0000            |
| 1   | 0001            |
| A   | 1010            |
| F   | 1111            |

So yes — **each pair like “0F”, “A3”, “7B” is 8 bits (1 byte)**, because **2 hex digits = 8 bits**.



# 2) Endianness (how bytes are ordered)

* **EVM/ABI data is big-endian** for human hex representation of integers: the most significant byte comes first in the 32-byte word.
* Example: the number `1` as a 32-byte EVM word is:

  ```
  0x0000000000000000000000000000000000000000000000000000000000000001
  ```

  The `01` appears at the *end* (least-significant byte), and leading bytes are zeros.
* Important: when reading hex strings in EVM context, treat them as big-endian for numeric value.

---
---
---
# STACK:

## > What the Stack is (conceptually)

* The EVM stack is a **LIFO** (last in, first out) structure used for *intermediate computation*.
* It stores **only 256-bit (32-byte) words**. Every PUSH, arithmetic op, comparison, etc. uses those 32-byte slots.
* **Temporary only**: stack contents exist only during transaction execution and are lost after execution finishes. They are *not persisted* like `storage`.
* Capacity limit: **maximum depth = 1024 words**. If execution pushes past 1024 → execution fails (stack overflow). If an opcode expects items but there aren’t enough → execution fails (stack underflow).

---


## 4) Advanced notes (useful later)

* **Stack vs Memory vs Storage**: stack is short-lived (fast, limited), memory is temporary but byte-addressable during execution, storage is persistent and expensive. You wanted to study the six places — we’ll cover the others later but keep in mind: stack is for immediate operands and results.
* **EVM is a stack machine**: almost every opcode consumes and/or produces stack items — different from register machines (like CPUs).
* **Interacting with words smaller than 32 bytes**: store them in a 32-byte slot (zero-padded). When packing/reading, be mindful of pad direction (left for numbers).
* **Smart-contract vulnerabilities**: incorrect stack assumptions (esp. stack depth or mixing signed/unsigned comparisons) can cause bugs — compilers usually prevent many mistakes.

---

## 5) Quick reference summary

* Word size = **32 bytes (256 bits)** = **64 hex digits**.
* Hex digit = 4 bits; two hex digits = 1 byte.
* Values are **big-endian** when represented as 32-byte hex words.
* Stack is **LIFO**, depth **≤ 1024**, used for intermediate computation only.
* Common opcodes: `PUSH`, `POP`, `DUPn`, `SWAPn`, `ADD`, `SUB`, `MLOAD`, `SSTORE`, `JUMP`, etc.
* Arithmetic is modulo `2^256`. Signed comparisons use signed opcodes (`SLT`, `SGT`).

---
---
---

# MEMORY:


# ✅ **1. What is Memory in EVM? (Simple definition)**

**Memory = temporary, byte-addressable workspace during execution.**

* It exists **only for the duration** of the transaction.
* It is **linear** (starts at address `0x00` and grows upward).
* It is **expandable**, but expansion costs gas.
* Memory is always read/written in **32-byte words** (even if you want 1 byte).

Best analogy:

> Memory is like a blank notebook you can write in during a function call.
> When the call ends, the notebook is thrown away.

---

# ✅ **2. What does memory look like at the beginning?**

Here is the memory layout right after a new call starts:

```
Address     Meaning
---------------------------------------------
0x00–0x1F   Solidity scratch space (32 bytes)
0x20–0x3F   Solidity scratch space (32 bytes)
0x40–0x5F   Free memory pointer (word starting at 0x40)
0x60–0x7F   Zero-filled region (empty buffer)
0x80–...    Actual free memory begins here
```

Visual:

```
0x00  | scratch space 32 bytes
0x20  | scratch space 32 bytes
0x40  | free memory pointer (initially = 0x80)
0x60  | reserved empty slot (zeroed out)
0x80  | <--- free memory actually starts here
0xA0
0xC0
...
```
> 0x1F = 0001 1111 ==decimal==> 31 (1F = 1* 16^1 + 15*16^0 = 16 + 15 = 31)

> 31 + 1 = 32 (next position)

> 32 / 16 = 2 | remainder = 0 ==> 2 and 0 => 0x20

```
another examnple:

45:
45/16 => 2 | remainder = 13
2 and 14 ==> 0x2D
```
---

# ✅ **3. Why does Solidity reserve these areas?**

### **(A) 0x00–0x3F = scratch space**

* Solidity uses these 64 bytes as temporary workspace.
* Example: storing return values before copying to output.
* You should treat it as **unsafe** to store your data here manually.

### **(B) 0x40 = free memory pointer**

This is the **most important memory address** in Solidity.

At address `0x40`, Solidity stores a **32-byte word** containing the address where free memory begins.

At the start of execution:

```
[ memory @0x40 ] = 0x80
```

Meaning:

> "Nothing has been stored beyond 0x80 yet."

So the first safe place to write data is **0x80**.

---

# ❗ Why is the free memory pointer stored at 0x40?

Because Solidity reserves:

* 0x00–0x3F → scratch space (cannot be written safely)
* 0x40 → safe location to *store* the pointer
* 0x60 → reserved empty 32 bytes (explained next)

---

# ✅ **4. What is 0x60 used for?**

`0x60` to `0x7F` (next 32 bytes) are **just zeros**, kept empty *intentionally*.

Reason:

> It is used as the "initial empty array value"
> (a dynamic array of length zero points to 0).

Example: if Solidity puts a dynamic array length into memory,
it uses `0x60` as the placeholder because it's 32 bytes of zeros.

But **you should not write here** manually — it is reserved.

---

# ✅ **5. 0x80 → where free memory actually starts**

When Solidity needs to write something to memory (struct, array, string, ABI encoding), it always:

1. Reads the free memory pointer at `0x40`.
2. Writes data starting at that location.
3. Updates the free memory pointer to the next available location.

So initially:

```
free memory pointer = 0x80
```

Meaning:

> “Memory from 0x80 onward is unused.”

---

# 🔥 **6. Why does free memory pointer come before 0x60?**

You wrote something like:

> 0x40 comes before 0x60 so initializing it means we load fewer words.

This is correct — here’s the clean explanation:

### Memory expansion is expensive.

If your program only ever uses memory up to `0x40`,
the EVM never needs to initialize or zero-out memory past `0x40`.

So:

* `0x00–0x3F` = reserved scratch
* `0x40` = pointer to free space
* Solidity sets the pointer to **0x80**, not 0x60, because:

  * 0x60 is reserved as zero buffer
  * EVM guarantees memory grows in 32-byte chunks

### Why not start at 0x60?

Because Solidity wants a consistent area of 32 bytes filled with zeros.

This is used for things like:

* empty strings
* empty arrays
* return zero values
* hashing dynamic arrays

If 0x60 were used, you’d lose this "guaranteed zero region".

---

# 🔥 **7. The biggest reason this layout matters**

When you allocate memory, Solidity does:

```
uint256 ptr = mload(0x40);   // read free memory pointer
... write data at ptr ...
mstore(0x40, ptr + size);    // update pointer
```

So all memory usage looks like a **stack that grows upward**.

Everything written moves the pointer forward:

```
0x80 → 0xA0 → 0xC0 → 0xE0 → …
```

Continuous, efficient, cheap.

---

# 📦 **8. Memory is where Solidity stores things like:**

### ✔ Structs

Stored contiguously:

```
struct S { uint a; uint b; }
```

Memory layout:

```
a → 32 bytes
b → 32 bytes
```

### ✔ Dynamic arrays in memory

```
[ length | element0 | element1 | ... ]
```

### ✔ Strings & bytes

Same layout as dynamic arrays.

### ✔ ABI encoding before returning a value

---

# ⚠️ **9. Memory is NOT persistent**

Once the transaction ends:

* Memory is wiped.
* Stack disappears.
* Only **storage** keeps data permanently.

---

# 🧪 **10. A very simple example**

Solidity code:

```solidity
uint256 x = 10;
uint256 y = 20;
```

Both are stack variables (not storage), so compiler will:

* Allocate temporary space in memory if needed (like for returning)
* But the numbers themselves live only in the stack

If you do:

```solidity
return (x, y);
```

Then memory will contain something like:

```
0x80: 0x000...000a   (10)
0xA0: 0x000...0014   (20)
```

And free memory pointer becomes `0xC0`.

---

# 🎯 Summary in simplest words

* **Memory** is temporary storage for the function execution.
* Solidity reserves:

  * `0x00–0x3F` scratch space
  * `0x40` free memory pointer
  * `0x60` zero-filled buffer
* First real free memory address = **0x80**
* Memory grows upward, 32 bytes at a time.
* Used for structs, arrays, strings, ABI encoding, function returns.
* Destroyed after execution.

---
---
---
##  Trick:
Here are **two super easy mental methods** to convert decimal → hex quickly.

---

## ✅ **Method 1: The 16-Blocks Method (Fastest)**

Just remember:
**Hex groups numbers in blocks of 16.**

Example: **32 → hex**

* 32 is **two blocks of 16**
  because ( 2 × 16 = 32 )

* Remainder = 0

So:

```
2  → hex '2'
0  → hex '0'

32 → 0x20
```

That's it.

---

## ✅ **Method 2: Repeated Division (Simple rule)**

1. Divide by 16
2. The quotient = first hex digit
3. The remainder = second hex digit

Example: **45 → hex**

* 45 ÷ 16 = 2 remainder 13
* Remainder 13 in hex is **D**

So:
```
45 = 0x2D
```
---

# ⚡ Quick Cheat Table (0–15 in hex)

| Decimal | Hex |
| ------- | --- |
| 0       | 0   |
| 1       | 1   |
| 2       | 2   |
| 3       | 3   |
| 4       | 4   |
| 5       | 5   |
| 6       | 6   |
| 7       | 7   |
| 8       | 8   |
| 9       | 9   |
| 10      | A   |
| 11      | B   |
| 12      | C   |
| 13      | D   |
| 14      | E   |
| 15      | F   |

---
---
To convert **0x1F → decimal**, you just expand it using powers of 16.

Hex number **1F** has two digits:

* **1** is in the 16¹ place
* **F** is in the 16⁰ place
* And **F = 15** in decimal

### Step-by-step:

[
1F_{16} = (1 \times 16^1) + (15 \times 16^0)
]

Now compute:

* (1 \times 16 = 16)
* (15 \times 1 = 15)

Add them:

[
16 + 15 = 31
]

### Final result:

```
0x1F = 31 (decimal)
```

---
---
---

Perfect — now I’ll explain **calldata**, **storage**, **blockchain state**, and finally **how all storage locations work together with the EVM** in simple, intuitive terms.

This will complete the mental model of "how the EVM stores and moves data."

---
---
---
#  CALLDATA (simplest of all)

### ✔ What is calldata?

**Calldata = read-only input data sent with a function call.**

Examples:

* Function selector (first 4 bytes)
* Encoded arguments (next bytes)

### ✔ Properties

* **Read-only** (cannot modify it)
* **Cheapest** place to read from
* **External only** (exists only when a transaction or external call happens)
* **Not persistent**

### ✔ Why read-only?

Because calldata belongs to the *caller*, not the contract.
Contract should not change what caller sent.

### ✔ Example layout

When calling:

```solidity
myFunc(10, 20);
```

Calldata might look like:

```
[4 bytes]   function selector
[32 bytes]  10
[32 bytes]  20
```

### ✔ Big takeaway

> Calldata is the **cheapest and most efficient** place to read arguments.
> That’s why `calldata` is used for `external` functions and large arrays.

---
---
---
# STORAGE (hardest, but I’ll make it simple)

### ✔ What is storage?

**Storage = the permanent database of a smart contract.**

* Lives on the blockchain.
* Data stays **after** the function ends.
* Very **expensive** (especially writing).
* Organized in **32-byte slots**.

### ✔ Imagine storage like this:

```
slot 0 → 32 bytes
slot 1 → 32 bytes
slot 2 → 32 bytes
...
```

Each variable goes into a slot (if small, variables may be tightly packed).

### ✔ Why so expensive?

Because storage changes → require miners/validators to update the blockchain state and propagate it across the network.

### ✔ Key difference from memory

| Memory                           | Storage                        |
| -------------------------------- | ------------------------------ |
| Temporary (wiped after function) | Permanent (saved on chain)     |
| Cheap to read/write              | Extremely expensive            |
| Used for computation             | Used for long-term data        |
| Has reserved areas               | No reserved areas, fully yours |
| Free memory pointer at 0x40      | No such pointer                |

---

# 🔥 How storage keys actually work

* Every slot is a **256-bit index**.
* Basic variables occupy the next available slot.
* Structs and dynamic arrays use **keccak hashing** of slot numbers to find their data locations.

But details aren’t needed now — only the core idea:

> Storage is key-value 32-byte slots.
> Key = slot number.

---
---
---
# 3. Blockchain State (global state)

This contains **all accounts**, and each account has:

### ✔ Account state fields

1. **nonce**

   * Count of transactions sent from this account
   * Prevents replay

2. **balance (ether)**

   * Amount of ETH owned by this account

3. **code**

   * For smart contracts: the bytecode
   * For EOAs (normal wallets): empty

4. **storage**

   * Key-value store (32-byte slots)
   * Permanent contract data

### Blockchain state looks like:

```
Account A:
  nonce
  balance
  code
  storage (key → value)

Account B:
  nonce
  balance
  code
  storage

...
```

---

# 💡 4. How STACK, MEMORY, CALLDATA, STORAGE all work together

This is the **most important** conceptual part.

Imagine running a function:

```solidity
function foo(uint a, uint b) external returns(uint) {
    uint c = a + b;
    return c;
}
```

Here is what happens step by step:

---

## Step 1 — **Caller sends calldata**

Example calldata:

```
selector | a | b  
```

Stored in the **calldata region**.

---

## Step 2 — **EVM loads arguments from calldata → stack**

`a` and `b` are fetched from calldata and pushed on the **stack**:

```
stack: [ b, a ]
```

Stack is used for computation.

---

## Step 3 — **EVM computes c = a + b** using stack

Addition uses stack only:

```
POP b
POP a
PUSH a+b
```

Now top of stack:

```
c
```

---

## Step 4 — **If a variable must persist, EVM writes to storage**

Example:

```solidity
storedValue = c;
```

Then:

* value on stack → written into **storage slot**.
* Very expensive operation.

---

## Step 5 — **If returning**, EVM moves data → memory → return buffer

Return values go through **memory**, not stack.

Solidity writes:

1. Write return value into memory at `0x80`.
2. Update free memory pointer.
3. RETURN reads from memory and sends output.

---

# Summary table (simplest possible)

| Location     | Lifetime            | Read/Write     | Cost       | Purpose                               |
| ------------ | ------------------- | -------------- | ---------- | ------------------------------------- |
| **Stack**    | per instruction     | R/W            | very cheap | computations                          |
| **Memory**   | per call            | R/W            | cheap      | temporary data, returns, ABI encoding |
| **Calldata** | per call            | read only      | cheapest   | function inputs                       |
| **Storage**  | permanent           | very expensive | expensive  | contract state                        |
| **Code**     | permanent           | read only      | -          | contract bytecode                     |
| **Logs**     | permanent event log | write only     | medium     | events/emits                          |

---

# 🧠 Final Intuition (simple)

Think of the contract as a computer:

* **calldata** → input arguments
* **stack** → CPU registers
* **memory** → RAM
* **storage** → hard disk (permanent)
* **code** → program instructions
* **logs** → printed event history

---
