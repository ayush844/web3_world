

# 📘 Notes: How Blockchain Works

---

## 🔑 1. Hash & Hashing

* **Hash:** A unique fixed-length string (fingerprint) generated from any input data.
* **Hashing:** The process of converting input data into a hash using a **cryptographic hash function**.
* **Properties of a cryptographic hash function:**

  * Deterministic: same input → same output.
  * Irreversible: you cannot get the original input from the hash.
  * Collision-resistant: two different inputs should not produce the same hash.
  * Sensitive: even a tiny change in input changes the hash completely.
* **Common functions:**

  * **SHA-256 (Bitcoin):** Produces a 256-bit (64 hex characters) hash.
  * **Keccak-256 (Ethereum):** Similar 256-bit function but different design.

---

## 📦 2. What is a Block?

A **block** is the fundamental unit of storage in a blockchain.
Each block contains:

* **Data:** The transactions or information recorded in this block.
* **Nonce:** A random number miners change to find a valid hash.
* **Hash:** The fingerprint of this block (calculated using hashing).
* **Previous Hash:** A reference to the hash of the previous block (this is what chains blocks together).

📌 **Mining a block** = finding a hash that meets certain conditions (e.g., starts with a certain number of zeros).

---

## 🔄 3. Are Blocks and Nodes the Same?

* **Block:** A container of transactions.
* **Node:** A computer in the blockchain network that stores copies of the blockchain, verifies transactions, and may participate in consensus (e.g., mining or validating).
  👉 They are **not the same**. A blockchain has many nodes, and those nodes store blocks.

---

## ⛏️ 4. Mining

* **Definition:** The process of adding a block to the blockchain by solving a computational puzzle.
* **How it works:**

  1. Miners take the block’s data + nonce + previous hash.
  2. They hash it repeatedly until the result meets the difficulty target (e.g., starts with a required number of zeros).
  3. Once a valid hash is found, the block is broadcasted to the network and added to the blockchain.

---

## 🧑‍🏭 5. Miners and the Problems They Solve

* **Miners:** Special nodes that perform mining.
* **Problem they solve:** The **Proof of Work (PoW)** puzzle:

  * They must find a valid nonce that makes the block hash less than the difficulty target.
  * This is computationally expensive, making the blockchain secure.
* **Reward:** Miners are rewarded with tokens (Bitcoin, ETH, etc.) and transaction fees for their work.

---

## ⛓️ 6. What is a Blockchain?

* A **blockchain** is a chain of blocks, each linked to the previous one using its hash.
* Structure of each block:

  * `Data`
  * `Nonce`
  * `Hash`
  * `Previous Hash`
* This chaining makes it **tamper-proof**.

---

## ✏️ 7. What Happens if Data in a Block is Changed?

* If data in a block is altered:

  * Its hash changes.
  * This breaks the link with the next block (since the `previous hash` stored there no longer matches).
  * That change propagates, invalidating all blocks after it.
    👉 This is why blockchain is immutable — changing old data requires re-mining all following blocks, which is practically impossible.

---

## 🟢 8. Genesis Block

* The **first block** of a blockchain.
* It has no previous block, so its `previous hash` is usually `0`.
* Every blockchain has exactly one genesis block (Bitcoin’s was created in 2009 by Satoshi Nakamoto).

---

## 🌐 9. Distributed Blockchain & Peers

* A **distributed blockchain** = blockchain copies stored on many nodes (peers) worldwide.
* **Consensus:** All peers must agree on the state of the blockchain.
* **If one peer changes a block’s data:**

  * Its chain becomes invalid because hashes don’t match.
  * Other peers reject it since the majority chain (longest valid chain) is considered true.
    👉 This keeps the blockchain trustworthy and decentralized.

---

## 💰 10. Tokens

* **Token:** A unit of value that exists on a blockchain.
* **Types:**

  * **Native tokens:** Created by the blockchain itself (e.g., BTC on Bitcoin, ETH on Ethereum).
  * **Custom tokens:** Built using smart contracts (e.g., ERC-20 tokens like USDT, LINK on Ethereum).
* **Use cases:** Payments, governance, access to services, stablecoins, NFTs.

---

## 🌍 11. How is Blockchain Decentralized?

* Instead of one central server (like banks or Google), blockchain data is copied across thousands of **nodes**.
* Every node has equal rights to validate and store transactions.
* **Consensus protocols (like PoW, PoS):** Ensure all nodes agree on the same version of the blockchain.
  👉 No single entity controls the system = decentralized.

---

## 🤖 12. Smart Contracts

* **Definition:** Programs that run on the blockchain (mainly on platforms like Ethereum).
* **Features:**

  * Stored at a blockchain address.
  * Contain state variables and functions.
  * Executed automatically when triggered.
* **Example:**

  * “If Alice sends 1 ETH to this contract, transfer an NFT to Alice.”
* **Benefit:** Removes need for intermediaries → rules are enforced by code.

---

# ✅ Summary

* **Hashing** secures data.
* **Blocks** store data + nonce + hash + prev hash.
* **Nodes** are computers in the network; **miners** solve hash puzzles to add blocks.
* **Blockchain** = linked chain of blocks; changing data breaks it.
* **Genesis block** = first block.
* **Distributed peers** keep identical copies, reject tampered ones.
* **Tokens** = digital assets on blockchains.
* **Decentralization** comes from distributed consensus.
* **Smart contracts** = code that automates rules directly on the chain.



---
---
---


# 🔑 Public & Private Keys, Signing, and Message Signatures

---

## 🔐 1. Public and Private Keys

Blockchain uses **asymmetric cryptography** (public-key cryptography).

* **Private Key:**

  * A secret 256-bit number (just a big random number).
  * Acts like your **password** — whoever has it controls your funds.
  * Must **never** be shared.

* **Public Key:**

  * Derived mathematically from the private key (using elliptic curve cryptography).
  * Can be shared with anyone.
  * Used to generate your blockchain **address** (e.g., Ethereum address).

📌 **Analogy:**

* Private key = your email password.
* Public key = your email address.
  Anyone can send you mail using your address (public), but only you can open it using your password (private).

---

## 📝 2. Signing a Transaction

When you send crypto or interact with a smart contract, you **sign the transaction** with your private key.

### How it works (step by step):

1. **Transaction data prepared**
   Example: `From: Alice’s address, To: Bob’s address, Amount: 1 ETH`.

2. **Hashing the transaction**

   * The transaction is hashed → creates a fixed-size representation of the data.

3. **Signature generation**

   * Your private key is used to generate a **digital signature** for that hash (using elliptic curve algorithms like ECDSA/secp256k1).
   * The signature is unique for both **your private key** and **that transaction’s data**.

4. **Broadcasting**

   * The signed transaction (transaction data + signature) is sent to the blockchain network.

5. **Verification by nodes**

   * Nodes use your **public key** to verify the signature matches the transaction data.
   * This proves:

     * The sender owns the private key.
     * The transaction hasn’t been altered.

📌 **Key point:**
The private key itself is never revealed; only the signature is shared.

---

## ✍️ 3. Message Signature

Sometimes you don’t want to send a transaction (on-chain), but still prove **you own an address**. This is done by signing a **message**.

### Example:

* A dApp asks you to **“Sign this message to log in”**.
* You sign a plain message (like `"Login at 12:00 UTC"`) with your private key.
* The dApp checks the signature against your public key (address).
* ✅ This proves you control that address, without moving funds.

### Why it’s useful:

* Logging into dApps (Web3 login).
* Verifying identity (prove wallet ownership).
* Off-chain agreements (signed messages can later be used on-chain as proof).

---

## 🧩 4. Summary

* **Private key:** Secret number that lets you control funds.
* **Public key:** Derived from private key; used to verify signatures and generate addresses.
* **Signing a transaction:** Using private key to produce a unique signature for the tx. Ensures authenticity and integrity.
* **Message signature:** Like signing a note with your private key to prove wallet ownership, without spending gas or sending crypto.

---
---
---


# ⛽ Ethereum Gas Fees and EIP-1559

---

## ⚡ 1. Base Fee

* The **base fee** is the **minimum amount of gas (per unit) required** for a transaction to be included in a block.
* Introduced in **EIP-1559** (Ethereum’s big upgrade in Aug 2021, “London Hard Fork”).
* **Dynamic:** The base fee automatically adjusts depending on how full recent blocks are.

  * If blocks are more than 50% full → base fee increases (transactions cost more).
  * If blocks are less than 50% full → base fee decreases (transactions cost less).
* **Burned:** The base fee is destroyed (burned), reducing ETH supply → makes ETH more deflationary.

📌 **Analogy:** Like a **minimum ticket price** that everyone has to pay, and it changes based on crowd demand.

---

## ⚡ 2. Priority Fee (a.k.a. “Tip”)

* An **extra fee** you add to incentivize miners/validators to prioritize your transaction.
* Unlike the base fee (which is burned), the **priority fee goes directly to the validator**.
* You set it manually (e.g., 2 gwei tip).
* The higher the priority fee, the faster your transaction is likely to be processed.

📌 **Analogy:** Like paying **extra for express delivery** to move ahead in the queue.

---

## ⚡ 3. Why transactions get more expensive when more people use the chain

* Ethereum has limited **block space** (limited gas per block).
* When more users want to transact (high demand):

  1. Base fee goes up (automatic adjustment by EIP-1559).
  2. People may offer higher priority fees to get processed faster.
* Result → congestion = higher total cost for transactions.

📌 **Real-world analogy:** Think of surge pricing in Uber → more demand = higher base price + tips to get a ride faster.

---

## ⚡ 4. What is EIP-1559?

EIP = Ethereum Improvement Proposal.
**EIP-1559** changed how gas fees are calculated. Before this, Ethereum had a simple **auction system**: users bid gas prices, and miners picked the highest bids → often led to unpredictable and very high fees.

### 🔑 What EIP-1559 introduced:

1. **Base Fee:** Algorithmically set, burned after every tx → no guessing.
2. **Priority Fee (Tip):** Optional, goes to validators for faster inclusion.
3. **More predictable fees:** Wallets can estimate fees better.
4. **ETH burning:** Makes ETH supply deflationary over time.

📌 **Formula for Total Fee Paid:**

```
Total Transaction Fee = (Base Fee × Gas Used) + (Priority Fee × Gas Used)
```

Example:

* Base fee = 30 gwei
* Priority fee = 2 gwei
* Gas used = 21,000 (simple ETH transfer)

Total Fee = (30 × 21,000) + (2 × 21,000) = **672,000 gwei (0.000672 ETH)**

---

## 🧩 5. Summary

* **Base fee:** Dynamic, burned, ensures stable pricing.
* **Priority fee (tip):** Goes to validators, incentivizes inclusion.
* **Congestion = higher costs:** Demand raises base fee + priority bidding.
* **EIP-1559:** Introduced the base fee model, improved predictability, reduced volatility, and made ETH deflationary.

---

