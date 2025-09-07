

# 1. EVM (Ethereum Virtual Machine) — the “computer” that runs the chain

* **What it is:** a deterministic virtual machine that runs smart-contract bytecode on every Ethereum node. Think of it as a replicated sandboxed CPU + memory that all nodes run to agree on state changes.
* **Key parts:**

  * **Accounts:** externally owned accounts (EOAs — people with keys) and contract accounts (code + storage).
  * **Storage / Memory / Stack:** storage = persistent key/value per contract (costly), memory = temporary during execution, stack = operand stack for opcodes.
  * **Bytecode & opcodes:** Solidity (or other language) → compiler → EVM bytecode made of opcodes (each opcode has a gas cost).
* **Why deterministic:** every node executes the same opcodes with the same inputs to reach the same resulting state and the same gas consumption.
* **Why gas is built in:** to limit and price computation (prevents infinite loops and spam) — the EVM charges gas for each opcode it executes.

# 2. Gas — the unit of computation

* **Gas (unit):** a unit that measures how much computational work (and storage) an operation costs on the EVM.
* **Gas table:** every EVM opcode (e.g., `SSTORE`, `CALL`, `ADD`) has a predefined gas cost.
* **Gas limit vs gas used:**

  * **Gas limit (transaction):** max gas you allow your transaction to consume.
  * **Gas used:** actual gas the transaction consumed while executing.
  * If execution runs out of gas → the EVM stops, the *state changes are reverted* but the gas used **is still charged** (you pay for the work done).
* **Why needed:** prevents denial-of-service and lets the network price scarce computation resources.

# 3. Gas price (units) — how gas is priced

* **Gas price** = amount of ETH you’re willing to pay per unit of gas.
* **Units on Ethereum:**

  * `wei` = smallest ETH unit (1 ETH = 10¹⁸ wei).
  * `gwei` = 10⁹ wei (common for gas prices).
* Example conversions:

  * 1 gwei = 1,000,000,000 wei.
  * 1 ETH = 1,000,000,000 gwei.

# 4. Transaction fee = gas\_used × gas\_price (basic idea)

* **Before EIP-1559 (legacy):** you set a `gasPrice` (e.g., 50 gwei). The fee = `gas_used × gasPrice`.
* **After EIP-1559 (current model):**

  * There is a **protocol `baseFee`** per gas (dynamically set by network demand) that is **burned**.
  * You supply:

    * `maxFeePerGas` (max you’re willing to pay per gas)
    * `maxPriorityFeePerGas` (tip to miners/validators)
  * **What you actually pay per gas** = `baseFee + effectivePriorityFee` (and the total must not exceed your `maxFeePerGas`).
  * **baseFee** is burned; **priorityFee** (tip) goes to the block producer. Any leftover (if `maxFee` > actual) is refunded to sender.

# 5. Concrete example calculations (step-by-step)

We’ll do digit-by-digit style calculations so it’s crystal clear.

**A. Simple legacy-style transfer example**

* `gas_used` (typical ETH transfer) = **21,000** gas.
* `gas_price` = **50 gwei**.

  * 50 gwei = 50 × 10⁹ wei = **50,000,000,000 wei**.
* Multiply to get total fee in wei:

  * 50,000,000,000 × 21,000

    * First compute ×21:
      50,000,000,000 × 20 = 1,000,000,000,000
      50,000,000,000 × 1 = 50,000,000,000
      → 50,000,000,000 × 21 = 1,050,000,000,000
    * Now multiply by 1,000 (because 21,000 = 21 × 1,000):
      1,050,000,000,000 × 1,000 = **1,050,000,000,000,000 wei**
* Convert wei → ETH:

  * 1 ETH = 1,000,000,000,000,000,000 wei (10¹⁸).
  * 1,050,000,000,000,000 ÷ 1,000,000,000,000,000,000 = **0.00105 ETH**
* So fee = **0.00105 ETH** (for this example).

**B. EIP-1559 example (base fee + tip)**

* `gas_used` = **21,000**.
* `baseFee` = **30 gwei** → 30 × 10⁹ = **30,000,000,000 wei**
* `priorityFee` (tip) = **2 gwei** → 2 × 10⁹ = **2,000,000,000 wei**
* Compute base fee total (burned):

  * 30,000,000,000 × 21,000

    * ×21 = 30,000,000,000 × 20 + ×1 = 600,000,000,000 + 30,000,000,000 = **630,000,000,000**
    * ×1,000 → **630,000,000,000,000 wei** → convert to ETH: 630,000,000,000,000 ÷ 10¹⁸ = **0.00063 ETH** burned.
* Compute priority fee total (to miner):

  * 2,000,000,000 × 21,000 = (2,000,000,000 × 21) × 1,000

    * 2,000,000,000 × 21 = 40,000,000,000 + 2,000,000,000 = **42,000,000,000**
    * ×1,000 → **42,000,000,000,000 wei** → convert to ETH: 42,000,000,000,000 ÷ 10¹⁸ = **0.000042 ETH**
* **Total paid by sender = burned baseFee + miner tip = 0.00063 + 0.000042 = 0.000672 ETH.**
* If you set a `maxFeePerGas` higher than `baseFee + priorityFee`, the extra is refunded.

# 6. Transaction lifecycle (flow)

1. **You create a tx** (nonce, to, value, data, gas limit, gas price or EIP-1559 fields) and **sign** it with your private key.
2. **Broadcast** → transaction enters the mempool (waiting pool).
3. **Miners/validators pick txs** (they prefer higher tips / effective gas price).
4. **Included in block** → nodes execute the tx on the EVM:

   * EVM charges gas per opcode as it runs.
   * If it finishes within gas\_limit → state changes persist and gas\_used is recorded.
   * If it runs out of gas → state reverts, but gas used is still consumed (you lose the gas).
5. **Gas accounting:** baseFee burned (EIP-1559), priority fee to block producer, refunds for unused gas.
6. **Receipt** produced containing `status`, `gasUsed`, logs, and `effectiveGasPrice` (what you actually paid per gas unit).

# 7. Important edge cases / behaviours

* **Out-of-gas:** tx reverts; state returns to previous snapshot; gas still consumed.
* **Estimate gas:** use `eth_estimateGas` or libraries (ethers/web3) — they simulate to guess `gasUsed`. Always add a margin (20–30%) for safety on complex calls.
* **Replace / speed up tx:** send a new tx with same `nonce` and higher fee fields → replaces pending tx. Wallets call this “speed up” or “cancel”.
* **Refunds:** unused gas is **not charged**. But some storage-clearing operations can yield *gas refunds* (advanced).
* **Why you can’t fetch outside data directly:** deterministic execution — nodes must all get the same inputs. Oracles solve this (but that’s a separate topic).
* **Block gas limit / capacity:** blocks have a maximum total gas (so only a finite number of txs fit per block). High demand → baseFee rises (EIP-1559) or miners prioritize higher tips.

# 8. Practical tips for a newcomer

* **Look at tx receipt fields** on a block explorer: `gasUsed`, `effectiveGasPrice`, and see how total fee = gasUsed × effectiveGasPrice.
* **Use gwei for human readability** — wallets generally show gwei and estimate.
* **For contracts, always `estimateGas` and test on a testnet** before using mainnet.
* **If your tx is stuck**, you can replace it with same nonce + higher fee.
* **To save costs**, use Layer-2s (rollups) — they execute off-chain and post compressed results to L1, reducing L1 gas usage.
* **Watch baseFee vs maxFee** when using EIP-1559: if baseFee increases above your maxFee, your tx may remain pending.

# 9. Quick glossary (one-liners)

* **EVM:** replicated virtual machine that executes contract bytecode.
* **Gas:** unit measuring EVM work.
* **Gas limit:** max gas a tx can use.
* **Gas price:** ETH-per-gas (commonly quoted in gwei).
* **Base fee (EIP-1559):** per-gas fee algorithmically set by protocol, **burned**.
* **Priority fee (tip):** incentive for block producer.
* **Effective gas price:** what you actually paid per gas (what explorers show).
* **Transaction fee:** `gasUsed × effectiveGasPrice`.

---

