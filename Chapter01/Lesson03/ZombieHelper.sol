pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    
    ///
     /// @notice ensure zombie is at or above a certain level
     /// @param _level check value
     /// @param _zombieId zombie to check
     ///
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level, "Error zombie level not high enough");
        _;
    }

    ///
     /// @notice allow user to change zombie name from level 2
     /// @param _zombieId zombie to change name
     /// @param _newName new name for the zombie
     ///
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].name = _newName;
    }

    ///
     /// @notice allow user to change zombie dna from level 20
     /// @param _zombieId zombie to change dna
     /// @param _newDna new dna for the zombie
     ///
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].dna = _newDna;
    }

    ///
     /// @notice returm an array of all the zombies owned by the owner
     /// @param _owner owner address to load all the zombies
     ///
    function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
              result[counter] = i;
              counter++;
            }
        }
        return result;
    }
}