pragma solidity >=0.5.0 <0.6.0;

import "OpenZeppelin/Ownable.sol";

contract ZombieFactory is Ownable {

    /// @dev State Variables
    uint dnaDigits = 16;
    uint dnaModulus = 10**dnaDigits;
    uint cooldownTime = 1 days;

    /// @dev Structs
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    /// @dev Arrays
    Zombie[] public zombies;

    /// @dev Mappings
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /// @dev events
    event NewZombie(uint zombieId, string name, uint dna);

    /// @dev functions

    /***
     * @dev create a new zombie
     * @param _name accepts string for Zombie name
     * @param _dna accepts uint for Zombie dna
     */
    function _createZombie(string memory _name, uint _dna) internal {
        /// @dev add new zombie to array
        Zombie _newZombie = Zombie(_name, _dna, 1, uint32(now + cooldownTime),0 ,0);
        uint id = zombies.push(_newZombie) -1;
        // zombies.push(Zombie(_name, _dna, 1, now + coolddownTime)); // 1 liner variation of array push

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] ++;

        emit NewZombie(id, _name, _dna);
    }

    /***
     * @dev generate random zombie dna
     * @param _str accepts string for entropy
     */
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));    /// @audit insecure method of randomness non-issue in this use
        return rand % dnaModulus;
    }

    /***
     * @dev only create a zombie if the account hasn't yet created one
     * @param _name accepts string for Zombie name
     */
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "Error creating zombie, user already created a zombie");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}