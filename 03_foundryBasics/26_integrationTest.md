
# Integration tests — notes

## Goal

Create programmatic scripts to interact with the `FundMe` contract (fund & withdraw) and verify those interactions with **integration tests** (distinct from unit tests). Use `foundry-devops` to target the **most recent deployment** automatically.

---

## Prerequisites

Install the DevOps helper library:

```bash
forge install Cyfrin/foundry-devops --no-commit
```

Make sure your Foundry toolchain is up-to-date if you hit build issues:

```bash
forge update --force
```

---

## File: `script/Interactions.s.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}
```

### What this script does (brief)

* Two `Script` contracts:

  * `FundFundMe` — sends `0.1 ether` to the latest deployed `FundMe` contract by calling `fund`.
  * `WithdrawFundMe` — calls `withdraw` on the latest deployed `FundMe`.
* `DevOpsTools.get_most_recent_deployment("FundMe", block.chainid)` fetches the most recent deployment address for `FundMe`.
* `vm.startBroadcast()` / `vm.stopBroadcast()` wrap actual transaction broadcasts (Foundry cheatcodes).
* `console.log` prints confirmations to terminal.

---

## How to run the script manually

Example (one-off) command to run the fund script:

```bash
forge script script/Interactions.s.sol:FundFundMe --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

(Use `WithdrawFundMe` similarly.)

---

## Organize tests: folder structure

Create:

```
test/
  ├── unit/
  │    └── FundMe.t.sol   (move your unit test here)
  └── integration/
       └── FundMeTestIntegration.t.sol
```

If you moved `FundMe.t.sol`, update any import paths inside it as needed.

---

## File: `test/integration/FundMeTestIntegration.t.sol`

```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";

contract InteractionsTest is Test {
    FundMe public fundMe;
    DeployFundMe deployFundMe;

    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    address alice = makeAddr("alice");


    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(alice, STARTING_USER_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public {
        uint256 preUserBalance = address(alice).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;

        // Using vm.prank to simulate funding from the USER address
        vm.prank(alice);
        fundMe.fund{value: SEND_VALUE}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 afterUserBalance = address(alice).balance;
        uint256 afterOwnerBalance = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        assertEq(preOwnerBalance + SEND_VALUE, afterOwnerBalance);
    }
}
```

### Test flow explained

1. **setUp()**

   * Deploys `FundMe` with your deploy script (`DeployFundMe`).
   * Gives `alice` 10 ETH test balance via `vm.deal`.

2. **testUserCanFundAndOwnerWithdraw()**

   * Records pre-fund balances of `alice` and contract owner.
   * `vm.prank(alice)` simulates a transaction from `alice`.
   * `alice` calls `fund{value: 0.1 ether}()` on `fundMe`.
   * Instantiate `WithdrawFundMe` and call `withdrawFundMe(address(fundMe))` — this runs the withdraw script (which broadcasts a transaction).
   * Assert contract balance is zero and balances moved as expected:

     * `alice` lost `SEND_VALUE`.
     * Owner gained `SEND_VALUE`.

---

## Run the integration test

Run only this test (verbose output):

```bash
forge test --mt testUserCanFundAndOwnerWithdraw -vv
```

Expected (example) output snippet:

```
[PASS] testUserCanFundAndOwnerWithdraw() (gas: 330965)
Logs:
  Withdraw FundMe balance!

Suite result: ok. 1 passed; 0 failed; 0 skipped;
```

---

## Troubleshooting notes (important)

* **foundry-devops vm.keyExists deprecation**
  If `forge build` fails due to `vm.keyExists` being deprecated in `foundry-devops/src/DevOpsTools.sol`, replace the call with:

  ```diff
  - vm.keyExists(...)
  + vm.keyExistsJson(...)
  ```

  Then ensure your `forge-std`’s `Vm.sol` exposes `keyExistsJson`. If not, update Foundry:

  ```bash
  forge update --force
  ```

  If issues persist, check the `foundry-devops` repo / Cyfrin discord for guidance.

* **FFI warning**
  Forge FFI (`vm.ffi`) lets tests run shell commands — powerful but dangerous. Repos with `ffi = true` in `foundry.toml` can execute external commands. **Do not enable this unless you trust the repo**.

---

## Quick checklist for your notes

* [ ] `script/Interactions.s.sol` created (contains Fund & Withdraw scripts)
* [ ] `foundry-devops` installed: `forge install Cyfrin/foundry-devops --no-commit`
* [ ] Tests separated: `test/unit/` and `test/integration/`
* [ ] `test/integration/FundMeTestIntegration.t.sol` added
* [ ] Run `forge test --mt testUserCanFundAndOwnerWithdraw -vv` — expect pass
* [ ] If build fails due to `vm.keyExists`, replace with `vm.keyExistsJson` and run `forge update --force`

---
