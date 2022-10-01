pragma solidity >=0.5.0 <0.6.0;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    uint randNonce;     /// @dev cheaper for gas than = 0;
    uint attackVictoryProbability = 70;

    /***
     * @dev create a random number through keccak256 and modulus (%)
     * @param _modulus modulus value for calculation
     * @audit insecure method of randomness that can be attacked by miners
     */
    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint (keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
    }

    /***
     * @dev calculate outcome and process the attack 
     * @param _zombieID attacking zombie
     * @param _targetID defending zombie
     */
    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];

        uint rand = randMod(100);

        if(rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);   // already run in feedAndMultiply() for a win
        }
    }
}