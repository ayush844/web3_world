Here’s a **detailed, step-by-step guide** to help you fully understand how to deploy a Solidity contract to **zkSync** (a Layer 2 rollup network) on a **testnet**, including bridging funds, setting up MetaMask, and using the Remix zkSync plugin.

---

## 1️⃣ Why zkSync & Layer 2 Matter

* **High Gas Costs on Mainnet**: Ethereum mainnet fees can spike during network congestion.
* **Rollups & Layer 2**: zkSync is a **zero-knowledge rollup**—it bundles many transactions off-chain and posts a single proof to mainnet, drastically cutting costs and increasing throughput.
* **Goal Here**: Practice a full **testnet deployment** (no real money) exactly as professional devs do for Layer 2 apps.

---

## 2️⃣ Prerequisites

* **MetaMask wallet** installed in your browser.
* Basic knowledge of Remix (where you’ve written `SimpleStorage.sol`).
* Some **Sepolia test ETH** (the Ethereum testnet currency) to bridge.

---

## 3️⃣ Get zkSync Test Funds

### Method 1: Faucet (simple, but sometimes down)

* Visit a zkSync testnet faucet (link in the course’s GitHub repo).
* Request free zkSync Sepolia ETH.

### Method 2: Bridging (recommended, more reliable)

1. **Have Sepolia ETH**

   * If you don’t, grab it from a public faucet such as [https://sepoliafaucet.com](https://sepoliafaucet.com).
2. **Open the zkSync Bridge**

   * Go to the [zkSync Bridge](https://bridge.zksync.io/) (ensure it’s the testnet version).
3. **Connect Wallet**

   * Click **Connect Wallet**, choose MetaMask, and unlock it.
   * Make sure MetaMask is on **Ethereum Sepolia Testnet**.
4. **Transfer**

   * Specify a small amount (0.001–0.01 ETH is plenty).
   * Click **Continue** and confirm in MetaMask.
   * Wait 5–15 minutes for the bridge to complete.
5. **Add zkSync Sepolia Network to MetaMask**

   * Go to [Chainlist.org](https://chainlist.org), enable testnets, search “zkSync Sepolia,” and **Add to MetaMask**.
   * Switch network to **zkSync Sepolia Testnet** once the bridging is done.

You should now see your bridged ETH balance in MetaMask under the zkSync Sepolia network.

---

## 4️⃣ Prepare Your Contract

1. In Remix, place your `SimpleStorage.sol` file **inside a folder named `contracts/`**.
   *This is important: the current zkSync Remix plugin only recognizes contracts inside a `contracts` folder.*
2. Check the Solidity version. zkSync currently requires **Solidity 0.8.24** (verify in the plugin docs).

---

## 5️⃣ Using the Remix zkSync Plugin

1. **Activate Plugin**

   * In Remix, open the **Plugin Manager** (puzzle icon), search for **zkSync**, and activate it.
   * A new “zkSync” tab appears on the left.

2. **Compile**

   * In the zkSync tab, choose your contract and click **Compile**.
   * Ensure the compiler version matches (0.8.24).

3. **Connect Wallet**

   * In the Deploy section of the zkSync plugin, select **Injected Provider – MetaMask**.
   * MetaMask should be on **zkSync Sepolia Testnet**.

4. **Deploy**

   * Click **Deploy**.
   * MetaMask pops up asking for confirmation—approve it.
   * The Remix terminal should soon show a **green “verification successful”** message.

---

## 6️⃣ Verify & Interact

* Copy the deployed contract address and paste it into the [zkSync Sepolia Explorer](https://explorer.sepolia.zksync.io/) to view details (transactions, bytecode, etc.).
* In Remix’s **Deployed Contracts** panel, use your contract’s functions:

  * **Write functions** (e.g. `store(uint256)`) trigger a transaction—MetaMask will ask for confirmation.
  * **Read functions** (`retrieve()`, etc.) are free and do not prompt MetaMask.

---

## 7️⃣ Tips & Gotchas

* **Testnet Only**: Always use a wallet that holds **only test ETH**.
* **Slow Bridge?**: Transfers can take 10–15 minutes—be patient.
* **Plugin Bug**: If “No smart contracts ready for deployment” appears even after compilation, double-check your contract is inside a **`contracts` folder**.
* **Gas Fees**: zkSync fees are far lower than Ethereum mainnet, but still require small test ETH.

---

## ✅ Summary Workflow

1. **Fund**: Get Sepolia ETH → bridge to zkSync Sepolia.
2. **Setup**: Add zkSync Sepolia network to MetaMask.
3. **Code**: Place `SimpleStorage.sol` in `contracts/`, set compiler to 0.8.24.
4. **Plugin**: Enable zkSync Remix plugin, compile, deploy.
5. **Verify & Interact**: Check on zkSync explorer and call functions via Remix.

Deploying to zkSync testnet gives you **real Layer 2 experience**—cheap transactions, live chain data, and the same tools you’d use for a production app, but with **zero financial risk**.
