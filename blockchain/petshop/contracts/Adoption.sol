pragma solidity ^0.5.0; // ^는 0.5.*를 의미함

contract Adoption {
    address[16] public adopters;

    function adopt(uint petId) public returns(uint) {
        require(petId >= 0 && petId <= 15); // array 크기가 16이기 때문

        adopters[petId] = msg.sender;

        return petId;
    }

    function getAdopters() public view returns (address[16] memory) {
        return adopters;
    }
}