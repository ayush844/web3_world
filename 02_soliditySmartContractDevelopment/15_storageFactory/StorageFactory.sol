// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// import "contracts/SimpleStorage.sol";
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory{

    // SimpleStorage public simpleStorage;
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        // simpleStorage = new SimpleStorage();
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);

    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // to interact with another contract we need 2 things:
        // adress
        // ABI (application binary interface)
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

}