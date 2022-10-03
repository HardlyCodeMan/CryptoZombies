pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    /// @notice State Variables
    uint dnaDigits = 16;
    uint dnaModulus = 10**dnaDigits;

    /// @notice Structs
    struct Zombie {
        string name;
        uint dna;
    }

    /// @notice Arrays
    Zombie[] public zombies;

    /// @notice events
    event NewZombie(uint zombieId, string name, uint dna);

    /// @notice functions

    /***
     * @param _name accepts string for Zombie name
     * @param _dna accepts uint for Zombie dna
     */
    function _createZombie(string memory _name, uint _dna) private {
        /// @notice add new zombie to array
        Zombie _newZombie = Zombie(_name, _dna);
        uint id = zombies.push(_newZombie) -1;
        // zombies.push(Zombie(_name, _dna)); // 1 liner variation of array push
        emit NewZombie(id, _name, _dna);
    }

    /***
     * @param _str accepts string for entropy
     */
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));    /// @audit insecure method of randomness
        return rand % dnaModulus;
    }

    /***
     * @param _name accepts string for Zombie name
     */
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
