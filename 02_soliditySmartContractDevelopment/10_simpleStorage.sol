// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; // stating our version


contract SimpleStorage {
    uint256 myFavoriteNumber;

    //uint256[] listOfFavoriteNumbers; //[]

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Person public pat = Person({favoriteNumber: 123, name: "Pat"});

    Person[] public listOfPeople; //[]

    mapping(string => uint256) public nameToFavoriteNumber;



    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256){
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNUmber) public {
        listOfPeople.push(Person(_favoriteNUmber, _name));
        nameToFavoriteNumber[_name] = _favoriteNUmber;
    }



}