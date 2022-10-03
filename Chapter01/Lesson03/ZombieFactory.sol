pragma solidity >=0.5.0 <0.6.0;

import "OpenZeppelin/Ownable.sol";

contract ZombieFactory is Ownable {

    /// @notice State Variables
    uint dnaDigits = 16;
    uint dnaModulus = 10**dnaDigits;
    uint cooldownTime = 1 days;

    /// @notice Structs
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    /// @notice Arrays
    Zombie[] public zombies;

    /// @notice Mappings
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /// @notice events
    event NewZombie(uint zombieId, string name, uint dna);

    /// @notice functions

    ///
     /// @param _name accepts string for Zombie name
     /// @param _dna accepts uint for Zombie dna
     ///
    function _createZombie(string memory _name, uint _dna) internal {
        /// @notice add new zombie to array
        Zombie _newZombie = Zombie(_name, _dna, 1, uint32(now + cooldownTime));
        uint id = zombies.push(_newZombie) -1;
        // zombies.push(Zombie(_name, _dna, 1, now + coolddownTime)); // 1 liner variation of array push

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] ++;

        emit NewZombie(id, _name, _dna);
    }

    ///
     /// @param _str accepts string for entropy
     ///
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));    /// @audit insecure method of randomness
        return rand % dnaModulus;
    }

    ///
     /// @notice only create a zombie if the account hasn't yet created one
     /// @param _name accepts string for Zombie name
     ///
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "Error creating zombie, user already created a zombie");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}