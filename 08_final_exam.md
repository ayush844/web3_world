
---

### 🔑 Public / Private Keys

* **Relationship:** Public key is derived from the private key using **elliptic-curve multiplication** (secp256k1 in Ethereum).
* **One-way:** You can go from private → public → address, but not the reverse.

---

### 🧩 Public Key & Wallet Address in Ethereum

* Address = **last 20 bytes of Keccak-256 hash of the uncompressed public key**.
* Path: **Private key → Public key → Address**.
* Public key can be reconstructed from a signature, but private key stays secret.

---

### ⚡ Centralised Sequencer Outage (Layer-2 / Rollups)

* **Effect:** No new transactions can be ordered or batched → network “freezes” for new activity.
* **Existing batches** already posted to L1 continue finalising.
* **Normal withdrawals pause**, but “forced inclusion” or “escape hatch” to L1 lets users withdraw, though slower and costlier.

---

### ✅ Transaction Authorisation

* **Digital signatures (ECDSA)** allow anyone to verify that a transaction was signed by the owner of the private key—proving sender authorisation without revealing the key.

---

### 🔍 Blockchain Explorer

* A **web-based tool** to view blocks, transactions, and account balances.
* Example: **Etherscan**.

---

### 🕵️ Witness in Zero-Knowledge Proofs

* The **private input** that satisfies the statement being proven.
* Used by the prover to generate a zk-proof; never revealed to the verifier.

---

### 🌐 Chain ID

* **Unique network identifier** embedded in transaction signatures.
* Prevents **replay attacks** across chains and ensures wallets/dApps connect to the correct network.

---

### 💸 Double Spending Prevention

* Achieved by the blockchain’s **decentralised consensus** and **append-only ledger**.
* Nodes agree on one canonical chain; cryptographic links between blocks make altering history infeasible.

---
