
## 1️⃣  What You’re Doing

You are going to **send test cryptocurrency on zkSync’s test network**.

* **Why a test network?**

  * It lets you practice using zkSync without risking real money.
* **zkSync Sepolia / zkSync Era Testnet**

  * This is zkSync’s version of the Sepolia Ethereum testnet.
  * It behaves like the real zkSync network but only with play-money ETH.

---

## 2️⃣  Add zkSync Sepolia to MetaMask

**MetaMask** is your crypto wallet. It needs to know about the new network.

1. **Find the Network Info**

   * Go to [Chainlist.org](https://chainlist.org/) and search **“zkSync Sepolia Testnet”**.
   * Toggle the option to show **testnets**, because it’s not a main network.

2. **Connect & Add**

   * Click **“Add to MetaMask”**.
   * Approve the pop-ups.
   * Now MetaMask can switch between Ethereum and zkSync Sepolia.

3. **Check Your Balance**

   * In MetaMask, switch to zkSync Sepolia to see your test ETH.
   * Or copy your wallet address and paste it into the **zkSync Sepolia Block Explorer** to see an account summary and past transactions.

---

## 3️⃣  Get Some Test ETH

To send a transaction you need **test ETH** (fake ETH used only on Sepolia).

* **Recommended:** Use a **faucet** (a free dispenser of test ETH).

  * The faucet might ask you to sign in with GitHub or use an API.
  * After a few minutes, you should see test ETH (for example 0.05 ETH) in MetaMask.

---

## 4️⃣  Bridge Funds to zkSync Sepolia

Now you’ll move your test ETH from the **Sepolia Ethereum testnet** onto **zkSync Sepolia**.

### Two Main Ways Bridges Work

1. **Lock & Unlock**

   * The bridge **locks** your tokens on the source chain (Sepolia)
   * and **unlocks** equivalent tokens on the destination chain (zkSync).
   * Think of it as putting coins in a locker on one side and getting a key to open the same number of coins on the other side.


![Lock & Unlock](https://updraft.cyfrin.io/blockchain-basics/18-making-your-first-transaction-on-zksync/lock-unlock.png)

2. **Mint & Burn**

   * Your tokens are **burned** (destroyed) on the source chain.
   * New tokens are **minted** (created) on the destination chain.
   * Example: **USDC’s Circle CCTP bridge** does this so that there’s never double supply.

![Mint & Burn](https://updraft.cyfrin.io/blockchain-basics/18-making-your-first-transaction-on-zksync/burn-mint.png)

> zkSync’s own bridge mainly uses the **lock & unlock** style.

---

### Bridging Steps

1. Go to the **official zkSync Bridge** site (make sure you’re on the **testnet** version).
2. Connect your MetaMask wallet.
3. Choose how much Sepolia ETH to move (e.g., **0.025 ETH**).
4. Confirm the MetaMask transaction.

   * You might see a small network fee (still test ETH).

---

## 5️⃣  Verify Your Transaction

* Copy your wallet address.
* Paste it into the **zkSync Sepolia Block Explorer**.
* You’ll see details such as:

  * **Transaction hash (ID)**
  * **Status** (pending → confirmed)
  * Amount moved and the time.

---

## 6️⃣  Understanding “Finality”

* **Finality** = the point when the transaction is **irreversible and fully secured** by zkSync’s zero-knowledge proofs.
* On **Ethereum mainnet**, finality is around **13 minutes**.
* On **zkSync testnet**, the UI shows your funds almost instantly, but **true finality may take up to \~24 hours**.

  * During that waiting time you *can* use the funds inside zkSync, but absolute, cryptographic confirmation happens after those ZK proofs are posted and verified on Ethereum.

---

## 7️⃣  Key Takeaways

* **MetaMask** is your wallet; you added a new test network (zkSync Sepolia).
* **Faucet ETH** gives you free practice funds.
* **Bridging** moves those funds from Ethereum Sepolia to zkSync Sepolia.
* Bridges work by **locking & unlocking** or **minting & burning** tokens.
* **Block Explorer** lets you confirm every detail of your transaction.
* **Finality** is when your transaction is fully locked in and can never be reversed.

By following these steps you’ve successfully **sent a transaction on zkSync’s testnet**, learning the same process you’d use later on the real zkSync network with real funds.
