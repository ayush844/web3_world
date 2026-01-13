// Layout of Contract:
// license
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @author  Ayush Sharma
 * @title   Raffle
 * @dev     It implements Chainlink VRFv2.5 and Chainlink Automation
 * @notice  This contract is for creating a sample raffle
 */
contract Raffle is VRFConsumerBaseV2Plus {
    // errors
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(
        uint256 balance,
        uint256 playersLength,
        uint256 raffleState
    );

    // type declarations
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1
    }

    // state variables
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    // @dev duration of olottery in seconds
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players; // @dev payable because we will be sending money to the winner
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;

    RaffleState private s_raffleState;

    // events
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    // we also need to call the constructor of VRFConsumerBaseV2Plus (parent contract)
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN; // or RaffleState(0);
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent");
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle()); // works only with higher solidity versions
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle(); // @dev more gas efficient
        }

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));

        // @dev why emit events?
        // 1) makes migration easier
        // 2) makes frontend indexing easier
        emit RaffleEntered(msg.sender);
    }

    /**
     * @notice  .
     * @dev     this is the function that the chainlink nodes will call to check if lottery is ready to have a winner picked
     * the following should be true in order for upkeepNeeded to be true:
     * 1) time interval has been passed between raffle runs
     * 2) the lottery is OPEN
     * 3) the contract has ETH
     * 4) Implicitly, your subscription has LINK
     * @param  -ignored
     * @return  upkeepNeeded  - true if its time to restart the lottery
     * @return  bytes  .
     */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasEth = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = timeHasPassed && isOpen && hasEth && hasPlayers;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.

        // since we defined upkeepNeeded as a return variable, we don't need to explicitly return it

        return (upkeepNeeded, "0x0"); // not necessary
        // or just return (upkeepNeeded, bytes(""));
        // or just return (upkeepNeeded, "");
        // or do nothing as we have already assigned value to upkeepNeeded
    }

    // @dev things that pickWinner/performUpkeep function will do
    // 1. Get a random number from chainlink VRF
    // 2. Use that random number to pick a winner
    // 3. be Automatically called
    function performUpkeep(bytes calldata /* performData */) external {
        (bool upkeepNeeded, ) = checkUpkeep("");

        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }

        s_raffleState = RaffleState.CALCULATING;

        // get a random number from chainlink VRF2.5
        // 1. Request RNG(Random NumberGenerator)
        // 2. get RNG

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash, // @dev gas price ceiling you are willing to pay for a request in wei
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit, // @dev gas limit for fulfillRandomWords function
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });

        s_vrfCoordinator.requestRandomWords(request); // this calls rawFulfillRandomWords present inisde VRFConsumerBaseV2Plus which calls fulfillRandomWords
    }

    // @dev we added this function because we are inheriting from VRFConsumerBaseV2Plus and this is an abstract function there
    // this function will be called by the VRFCoordinator when  we do requestRandomWords

    // CEI: Checks-Effects-Interactions pattern (IMPORTANT IN SMART CONTRACTS for security reasons)
    function fulfillRandomWords(
        uint256 /*requestId*/,
        uint256[] calldata randomWords
    ) internal override {
        // CHECKS (requires, or conditionals) (no checks here because we have already done them in pickWinner function)

        // EFFECTS (Internal contract state changes)

        // use that random number to pick a winner
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0); // reset the players array to zero size
        s_lastTimeStamp = block.timestamp;
        emit WinnerPicked(s_recentWinner); // positioned here to follow CEI pattern, since it is an internal state change

        // INTERACTIONS (external contract interactions)
        (bool success, ) = recentWinner.call{value: address(this).balance}("");

        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    // getter functions

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
