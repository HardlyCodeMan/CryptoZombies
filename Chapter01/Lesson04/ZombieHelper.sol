pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;
    
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
     /// @notice withdraw contract balance
     ///
    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance); 
    }

    ///
     /// @notice modify levelUpFee to suit changes in Eth price
     /// @param _fee new levelUpFee value
     ///
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    ///
     /// @notice user pays a fee level up zombie
     /// @param _zombieId zombie to level up
     ///
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee, "Error incorrect fee paid");
        zombies[_zombieId].level++;
    }

    ///
     /// @notice allow user to change zombie name from level 2
     /// @param _zombieId zombie to change name
     /// @param _newName new name for the zombie
     ///
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }

    ///
     /// @notice allow user to change zombie dna from level 20
     /// @param _zombieId zombie to change dna
     /// @param _newDna new dna for the zombie
     ///
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
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