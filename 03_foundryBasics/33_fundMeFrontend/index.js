// Import ethers library to talk to Ethereum blockchain
import { ethers } from "./ethers-6.7.esm.min.js"

// Import smart contract ABI and contract address
import { abi, contractAddress } from "./constants.js"

// Get buttons from the HTML page
const connectButton = document.getElementById("connectButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const balanceButton = document.getElementById("balanceButton")

// Attach functions to button clicks
connectButton.onclick = connect
withdrawButton.onclick = withdraw
fundButton.onclick = fund
balanceButton.onclick = getBalance

// Connect MetaMask wallet to the website
async function connect() {
  // Check if MetaMask is installed
  if (typeof window.ethereum !== "undefined") {
    try {
      // Ask MetaMask to connect user account
      await ethereum.request({ method: "eth_requestAccounts" })

      // Change button text after connection
      connectButton.innerHTML = "Connected"
    } catch (error) {
      console.log(error)
    }
  } else {
    // If MetaMask is not installed
    connectButton.innerHTML = "Please install MetaMask"
  }
}

// Withdraw ETH from the smart contract
async function withdraw() {
  console.log("Withdrawing...")

  if (typeof window.ethereum !== "undefined") {
    // Create a connection to the blockchain using MetaMask
    const provider = new ethers.BrowserProvider(window.ethereum)

    // Ask MetaMask for account access
    await provider.send("eth_requestAccounts", [])

    // Get the connected wallet (used to sign transactions)
    const signer = await provider.getSigner()

    // Connect smart contract with the wallet
    const contract = new ethers.Contract(contractAddress, abi, signer)

    try {
      // Call withdraw function from contract
      const txResponse = await contract.withdraw()

      // Wait until transaction is confirmed
      await txResponse.wait(1)

      console.log("Withdraw successful")
    } catch (error) {
      console.log(error)
    }
  }
}

// Send ETH to the smart contract
async function fund() {
  // Get ETH amount entered by user
  const ethAmount = document.getElementById("ethAmount").value
  console.log(`Funding with ${ethAmount} ETH`)

  if (typeof window.ethereum !== "undefined") {
    // Create blockchain connection
    const provider = new ethers.BrowserProvider(window.ethereum)

    // Ask MetaMask for account access
    await provider.send("eth_requestAccounts", [])

    // Get wallet that will send ETH
    const signer = await provider.getSigner()

    // Connect contract with wallet
    const contract = new ethers.Contract(contractAddress, abi, signer)

    try {
      // Send ETH while calling fund function
      const txResponse = await contract.fund({
        value: ethers.parseEther(ethAmount),
      })

      // Wait for confirmation
      await txResponse.wait(1)
    } catch (error) {
      console.log(error)
    }
  }
}

// Get ETH balance of the smart contract
async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    // Create read-only blockchain connection
    const provider = new ethers.BrowserProvider(window.ethereum)

    try {
      // Get balance of contract
      const balance = await provider.getBalance(contractAddress)

      // Convert Wei to ETH and print
      console.log(ethers.formatEther(balance))
    } catch (error) {
      console.log(error)
    }
  }
}
