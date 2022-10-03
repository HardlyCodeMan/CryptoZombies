pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFactory.sol";

/***
 * @notice Interface to getKitty() from CryptoKittys project
 */
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    /***
     * @notice Load the CryptoKitty contract address
     */
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    /***
     * @notice Ensure msg.sender owns the zombie
     * @param _zombieId accepts uint of an owned zombie
     * @param _targetDna accepts uint of target zombie
     */
    function feedAndMultiply(uint _zombieId, uint _targetDna, _species) public {
        require(msg.sender == zombieToOwner[_zombieId], "Error you don't own this zombie");
        Zombie storage myZombie = zombies[_zombieId];
        
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
    }

    /***
     * @notice Get genes data from kittyContract for _kittyId
     * @param _zombieId accepts uint for owned zombie checked in feedAndMultiply()
     * @param _kittyId accepts uint for CryptoKitty
     */
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}