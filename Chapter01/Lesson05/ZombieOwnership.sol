pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./OpenZeppelin/ERC721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping (uint => address) zombieApprovals;

    ///
     /// @notice return number of zombies owned by address
     /// @param _owner address to look up
     /// @return uint256
     ///
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerZombieCount[_owner];
    }

    ///
     /// @notice return owner address of zombie
     /// @param _tokenId zombie to find owner of
     /// @return address
     ///
    function ownerOf(uint256 _tokenId) external view returns (address) {
        return zombieToOwner[_tokenId];
    }

    ///
     /// @notice transfer a zombie between accounts
     /// @param _from account moving zombie from
     /// @param _to account moving zombie to
     /// @param _zombieId zombie to move
     ///
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    ///
     * 
     ///
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    ///
     * 
     ///
    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}