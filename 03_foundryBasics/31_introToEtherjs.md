

# 🌐 Web3 Frontend → Wallet → Blockchain (Complete Summary)

## 🎯 Lesson Goals

* Clone an existing GitHub repo quickly
* Use **Live Server** to run a frontend locally
* Understand **how a website talks to MetaMask**
* Learn what happens **under the hood** when a transaction is sent to the blockchain

---

## 🔑 Key Concepts (Very Important)

| Term              | Meaning                                                         |
| ----------------- | --------------------------------------------------------------- |
| `git clone`       | Copies a remote GitHub repository to your local machine         |
| Live Server       | VS Code extension that auto-reloads the browser on code changes |
| Browser Wallet    | Wallet like **MetaMask** injected into the browser              |
| `window.ethereum` | Object injected by MetaMask that allows Web3 interaction        |
| Provider          | RPC connection to the blockchain                                |
| Signer            | Wallet account used to sign transactions                        |
| ethers.js         | JS library to interact with Ethereum                            |

---

## 🛠️ Project Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/Cyfrin/html-fund-me-cu.git
```

### Step 2: Open in VS Code

```bash
code html-fund-me-cu
```

### Step 3: Run Frontend

* Install **Live Server** extension
* Click **Go Live** (bottom right)

✔️ Your frontend opens in the browser
✔️ Any code change updates instantly

---

## 🦊 Browser Wallets (MetaMask)

### What is a Browser Wallet?

* Acts as a **bridge** between website and blockchain
* Manages:

  * Accounts
  * Signing transactions
  * Network selection

### Important Observation

* MetaMask injects:

```js
window.ethereum
```

👉 If MetaMask is **not installed**, `window.ethereum` **does not exist**

---

## 🔍 Inspecting MetaMask Injection

* Open browser DevTools (`F12`)
* Go to **Console**
* Type:

```js
window
```

You’ll see:

```js
window.ethereum
```

📌 This object enables:

* Requesting accounts
* Sending transactions
* Reading blockchain data

---

## 🔌 Connecting Wallet (Frontend Logic)

### HTML Button

```html
<button id="connectButton">Connect</button>
```

### JavaScript Binding

```js
const connectButton = document.getElementById("connectButton");
connectButton.onclick = connect;
```

### Connect Function

```js
async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await ethereum.request({ method: "eth_requestAccounts" });
    } catch (error) {
      console.log(error);
    }
    connectButton.innerHTML = "Connected";
    const accounts = await ethereum.request({ method: "eth_accounts" });
    console.log(accounts);
  } else {
    connectButton.innerHTML = "Please install MetaMask";
  }
}
```

### 🔑 Key Points

* Requests permission to access wallet accounts
* **Does NOT expose private keys**
* Only allows transaction requests

---

## 🔁 Flow: Connect Button Click

1. User clicks **Connect**
2. MetaMask popup opens
3. User approves account
4. Button changes to **Connected**
5. Wallet address logs in console

---

## 💰 Reading Blockchain Data (getBalance)

### Function

```js
async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum);
    try {
      const balance = await provider.getBalance(contractAddress);
      console.log(ethers.formatEther(balance));
    } catch (error) {
      console.log(error);
    }
  }
}
```

### Concepts Used

| Concept       | Explanation                         |
| ------------- | ----------------------------------- |
| Provider      | Reads data from blockchain          |
| RPC URL       | Endpoint used to talk to blockchain |
| `getBalance`  | Reads ETH balance                   |
| `formatEther` | Converts Wei → ETH                  |

---

## 🌍 RPC URLs & Providers (Very Important)

* MetaMask stores **RPC URLs**
* ethers.js derives them automatically

```js
new ethers.BrowserProvider(window.ethereum)
```

➡️ Frontend → RPC → Blockchain
➡️ Similar to **API calls**

---

## ⚙️ Backend Setup (Local Blockchain)

### Step 1: Start Local Chain

```bash
anvil
```

✔️ Spins up a local Ethereum test network
✔️ Gives test accounts + private keys

---

### Step 2: Deploy Smart Contract

```bash
make deploy
```

✔️ Deploys FundMe contract to local chain

---

## 🌐 Add Local Network to MetaMask

**Network Details**

* Network Name: Localhost
* RPC URL: `http://127.0.0.1:8545`
* Chain ID: `31337`
* Currency: ETH

---

## 🔐 Import Anvil Account

1. Copy private key from anvil
2. MetaMask → Add Account
3. Import Account → Paste key

⚠️ Safe because this is **local testing**

---

## 💸 Sending Transactions (fund)

### fund Function

```js
async function fund() {
  const ethAmount = document.getElementById("ethAmount").value;
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);

    try {
      const transactionResponse = await contract.fund({
        value: ethers.parseEther(ethAmount),
      });
      await listenForTransactionMine(transactionResponse, provider);
    } catch (error) {
      console.log(error);
    }
  }
}
```

---

## 🔄 Transaction Flow (VERY IMPORTANT)

1. Frontend checks MetaMask
2. Creates provider
3. Gets signer (wallet account)
4. Creates contract instance
5. Calls smart contract function
6. MetaMask pops up
7. User signs transaction
8. Blockchain executes it

📌 **Private key NEVER leaves MetaMask**

---

## 📁 Hardcoded Values

* `contractAddress`
* `abi`

📍 Located in:

```js
constants.js
```

Used only for simplicity in this demo.

---

## ✅ Final Outcome

* Frontend + MetaMask connected
* Local blockchain running
* Smart contract deployed
* Transactions signed securely
* Balance updates correctly

---

## 🧠 Final Takeaways (Revision Gold ✨)

* `window.ethereum` = gateway to Web3
* MetaMask injects providers
* ethers.js simplifies blockchain interaction
* Frontend never accesses private keys
* Wallet signs all transactions
* RPC URLs behave like APIs
* Provider = read
* Signer = write

---
