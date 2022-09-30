pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFactory.sol";

/***
 * @dev Interface to getKitty() from CryptoKittys project
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

    KittyInterface kittyContract;

    /***
     * @dev Load the CryptoKitty contract address
     * @param _address accepts contract address
     */
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    /***
     * @dev resets cooldownTime when called after an action
     * @param _zombie accepts the Zombie struct
     */
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    /***
     * @dev checks true/false is the zombie is ready to conduct an action
     * @param _zombie accepts the Zombie struct
     */
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    /***
     * @dev Ensure msg.sender owns the zombie
     * @param _zombieId accepts uint of an owned zombie
     * @param _targetDna accepts uint of target zombie
     * @param _species cat or zombie?
     */
    function feedAndMultiply(uint _zombieId, uint _targetDna, _species) internal {
        require(msg.sender == zombieToOwner[_zombieId], "Error you don't own this zombie");
        Zombie storage myZombie = zombies[_zombieId];
        
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        require(_isReady(myZombie), "Error Zombie still in cooldown");    ///@dev ensure zombie is actionable
        
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }
        
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    /***
     * @dev Get genes data from kittyContract for _kittyId
     * @param _zombieId accepts uint for owned zombie checked in feedAndMultiply()
     * @param _kittyId accepts uint for CryptoKitty
     */
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}