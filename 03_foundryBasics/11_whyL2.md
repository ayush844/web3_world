
# ⚙️ Deploying to zkSync Sepolia & Understanding Gas Usage

In the previous lessons, we deployed our smart contract to the **Sepolia testnet** (a Layer 1 test network) and began exploring **zkSync**, a Layer 2 (L2) scaling solution.

While **Sepolia** closely mirrors Ethereum mainnet behavior, **zkSync** offers a much more **cost-efficient** and **scalable** alternative — which is why most modern projects prefer **Layer 2 deployments** today.

---

## 💸 Why Projects Prefer Layer 2 (zkSync)

Deploying directly to Ethereum mainnet is **very expensive** due to high gas fees.
Even small contracts like `SimpleStorage` can cost several dollars to deploy, while larger contracts can cost **hundreds or even thousands of dollars**.

**Layer 2 solutions** such as **zkSync Era** provide:

* The **same level of security** as Ethereum (via zero-knowledge proofs)
* **Much cheaper** transaction and deployment costs
* **Faster confirmations**

In short — zkSync = **Ethereum’s scalability, without the cost.**

---

## ⛽ Understanding Gas Usage in zkSync

When deploying to a **zkSync local node**, a **`/broadcast`** folder is created automatically.
It contains detailed deployment transaction data, including gas usage and fees.

### 🧾 Example File:

`/broadcast/run-latest.json`

This file includes an entry like:

```json
"gasUsed": "0x5747A"
```

This hexadecimal value represents the amount of gas consumed by your deployment.

---

### 🔢 Converting Gas Usage to Decimal

To convert this value to decimal using Foundry’s **cast** command:

```bash
cast to-base 0x5747A dec
```

This will output:

```
357498
```

So, your contract deployment used **357,498 gas units**.

---

## 💰 Estimating Deployment Cost on Ethereum

You can estimate deployment cost using the formula:

[
\text{Total Cost} = \text{Gas Used} \times \text{Gas Price}
]

Example:

| Value          | Description                             |
| -------------- | --------------------------------------- |
| **Gas Used**   | 357,498                                 |
| **Gas Price**  | 8 Gwei (8 × 10⁻⁹ ETH)                   |
| **Total Cost** | 357,498 × 8 Gwei = 0.002859984 ETH ≈ $7 |

This total can be verified under the **Transaction Fee** section on **Sepolia Etherscan**.

> 🧩 Even a small contract like `SimpleStorage` costs around **$7** to deploy on Ethereum.
> Larger, production-grade contracts can cost **hundreds or thousands** of dollars — which is why **Layer 2** is the practical choice.

---

## 🌐 Deploying to zkSync Sepolia (Layer 2 Testnet)

Deployment to **zkSync Sepolia** is very similar to deploying to a **local zkSync node**.
The only difference is the **RPC endpoint** used.

### 🪄 Steps:

1. **Go to [Alchemy](https://alchemy.com)** and create a new app.

   * **Network:** zkSync
   * **Chain:** zkSync Sepolia

2. Copy the **RPC URL** for zkSync Sepolia.
   Example:

   ```
   https://zksync-sepolia.g.alchemy.com/v2/<YOUR_API_KEY>
   ```

3. Add it to your `.env` file:

   ```bash
   ZKSYNC_RPC_URL=https://zksync-sepolia.g.alchemy.com/v2/<YOUR_API_KEY>
   PRIVATE_KEY=your_private_key
   ```

4. Deploy using:

   ```bash
   source .env
   forge create src/SimpleStorage.sol:SimpleStorage \
   --rpc-url $ZKSYNC_RPC_URL \
   --private-key $PRIVATE_KEY \
   --legacy \
   --zksync
   ```

---

## 📊 Comparing Layer 1 vs Layer 2 Costs

To visualize the difference in gas fees between Ethereum and Layer 2 networks:

👉 Visit **[L2Fees.info](https://l2fees.info)**

This site compares:

* The **average cost** of sending a transaction
* The **cost of deploying a contract**
* Across **Ethereum**, **Arbitrum**, **Optimism**, and **zkSync Era**

You’ll see that zkSync often reduces costs by **over 95%** while maintaining **Layer 1-level security**.

---

## ✅ Summary

| Concept    | Layer 1 (Ethereum / Sepolia) | Layer 2 (zkSync)                      |
| ---------- | ---------------------------- | ------------------------------------- |
| Gas Used   | High (e.g., 357,498 gas)     | Low (significantly reduced)           |
| Cost (ETH) | 0.00027 ETH (~$7)            | 0.00001–0.0001 ETH (~a few cents)     |
| Security   | Base layer (Ethereum)        | Inherits from Ethereum via ZK proofs  |
| Speed      | Slower                       | Faster                                |
| Ideal For  | Final mainnet deployment     | Testing, scaling, and cost efficiency |

---

## 💡 Key Takeaways

* **GasUsed** in `/broadcast/run-latest.json` helps estimate transaction cost.
* Convert hex gas values using `cast to-base <hex> dec`.
* **Layer 2 deployments (zkSync)** drastically reduce costs and improve performance.
* Use **Alchemy’s zkSync Sepolia RPC URL** for L2 testnet deployments.
* Check **L2Fees.info** for real-time gas price comparisons.

---
