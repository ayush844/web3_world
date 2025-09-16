
## 1. Big Picture

Layer-2 (L2) networks—like zkSync, Arbitrum, Optimism—sit **on top of a base blockchain (Layer 1)** such as Ethereum.
Because L2s start small and gradually give more control to the public, their **“maturity” is tracked in stages**.
The website **L2Beat** (L2B) publishes these stage ratings to show how decentralized and secure each rollup really is.

---

## 2. Rollup Stages

Think of these as **levels of decentralization**:

### **Stage 0 – Early / Operator-Controlled**

* **Who’s in charge?**

  * A small team (the “operators”) and a security council make the important decisions.
* **Transparency:**

  * All data is still stored on Layer 1, so anyone can **rebuild the rollup’s state** from Ethereum if needed.
* **User exits:**

  * You *can* withdraw funds to L1, but it usually needs help or approval from the operator and can take up to **7 days**.

---

### **Stage 1 – Partially Decentralized**

* **Governance:**

  * Smart contracts handle day-to-day management.
  * A security council is still around for emergencies (like fixing bugs).
* **Proof system:**

  * The cryptographic proofs that confirm transactions are now fully working.
  * Anyone can submit these proofs, not just the core team.
* **Exits:**

  * Users can withdraw their funds **independently** without operator help.

---

### **Stage 2 – Fully Decentralized**

* **Governance:**

  * Smart contracts handle everything—no human operators needed.
  * Security council only acts if there’s a serious, on-chain error.
* **Proof system:**

  * 100 % permissionless; anyone can verify or post proofs.
* **Exits:**

  * Totally automatic and independent of any company or council.

---

## 3. zkSync’s Current Status (as reported on L2Beat)

* **Stage:**

  * **Stage 0** → still in the earliest, more centralized phase.

* **Risk Areas Explained:**

  * **Data Availability:**

    * All transaction data is on Ethereum (L1), so anyone can recreate zkSync’s state if the team disappears.
  * **State Validation:**

    * Transactions are verified with **zero-knowledge proofs** using a cryptographic system called **PLONK**.
  * **Sequencer Failure:**

    * The sequencer (the “traffic cop” that orders transactions) could go offline.
    * Users can still send transactions directly to Ethereum, but they may not be processed right away.
  * **Proposer Failure:**

    * The “proposer” bundles proofs for Ethereum.
    * If this fails, **withdrawals and transaction finalization stop** until it’s fixed.
  * **Exit Window:**

    * Right now there’s **no guaranteed time window** for users to exit during an unexpected upgrade—another early-stage risk.

---

## 4. Key Takeaways

* **Why the stages matter:**
  They give users and developers a way to judge how **trustless and independent** a Layer-2 really is.
* **For zkSync today:**

  * It’s transparent (data on L1) and uses strong cryptography,
  * But governance and operations are still centralized, so users must trust the team more than they would in a mature Stage 2 rollup.

In short, **Stage 0 means “working but still controlled by the core team,”** and the goal is to climb to **Stage 2, where no single group can censor, halt, or manipulate the network.**
