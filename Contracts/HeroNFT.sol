// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract HeroNFT is ERC721, AccessControl{

    using SafeMath for uint256;

    string public _name = "Heroes of Peace NFT";
    string public _symbol = "HP_NFT";
    
    string private _baseTokenURI;

    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
 
    uint32 private _initialLevel = 1;
    Hero[] private heroesNFT;

    struct Hero {
        uint256 id;
        string name;
        string class;
        uint32 level;
    }

    event NewHeroNFT(address _to, uint tokenId, string name, string class, uint32 level);

    constructor() ERC721(_name, _symbol) {

        //Grant the contract deployer the default admin role: it will be able
        //to grant and revoke any roles

        _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        _setupRole(ADMIN_ROLE, _msgSender());
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Set token URI
     */
    function updateBaseURI(string calldata baseTokenURI) external onlyRole(ADMIN_ROLE) {
        _baseTokenURI = baseTokenURI;
    }

    function _createHero(address _to, string memory _nameParam, string memory _classParam) internal {
        uint tokenId = heroesNFT.length;
        heroesNFT.push(Hero(tokenId,_nameParam, _classParam, 1));
        
        _safeMint(_to, tokenId); //Method ERC721
        
        emit NewHeroNFT(_to, tokenId, _nameParam, _classParam, _initialLevel);
    }

    function createHero(address _to) external onlyRole(MINTER_ROLE) {
        (string memory generateName, string memory clagenerateClassss) = _generateRandomClassName(_to);
        _createHero(_to, generateName, clagenerateClassss);
    }

    /********************
    *** SESSION RANDON ***
    *********************/ 
    function _generateRandomClassName(address _to) private view returns (string memory generateName, string memory generateClass) {

        uint rand = uint(keccak256(abi.encodePacked(block.difficulty , block.timestamp, blockhash(block.number), _to))) %1000;
        
        if(rand >0 && rand<501){
            generateName = "Linkah";
            generateClass = "D";
        }
        if(rand >500 && rand<751){
            generateName = "Cardimande";
            generateClass = "C";
        }
        if(rand >750 && rand<901){
            generateName = "Ethenia";
            generateClass = "B";
        }
        if(rand >900 && rand<1001){
            generateName = "Bithex";
            generateClass = "A";
        }
        
        return (generateName, generateClass);
    }

    /********************
    *** SESSION GETs ***
    *********************/ 
    function getIdsHeroByOwner(address _owner) external view returns(uint[] memory result) {
        result = new uint[](balanceOf(_owner));
        uint counter = 0;
        for (uint i = 0; i < heroesNFT.length; i++) {
          if (ownerOf(i) == _owner) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }

    function getHeroById(uint256 _id) external view returns(Hero memory) {
        return heroesNFT[_id];
    }

    function getHeroByIds(uint256[] memory _ids) external view returns(Hero[] memory result) {
        result = new Hero[](_ids.length);
        
        for (uint i = 0; i < _ids.length; i++) {
          result[i] = heroesNFT[_ids[i]];
        }
        return result;
    }

    function setRoleMint(address account) external onlyRole(ADMIN_ROLE) {
        grantRole(MINTER_ROLE, account);
    }

    // OVERRIDE (ERC721, AccessControl)
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}
