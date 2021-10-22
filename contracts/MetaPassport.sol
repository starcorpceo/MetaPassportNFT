// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaPassport is ERC721Enumerable, ReentrancyGuard, Ownable, AccessControl {

  using Strings for uint256;

  bytes32 public constant META_ADMIN_ROLE = keccak256("META_ADMIN_ROLE");

  uint256 public constant MAX_L1_ID = 5500;
  uint256 public constant MAX_L2_ID = 8000;
  uint256 public constant MAX_L3_ID = 8888;

  // Default price on Polygon is in Matic, required to support WETH as payment
  uint256 public l1Price = 200 * 10**18;
  uint256 public l2Price = 400 * 10**18;
  uint256 public l3Price = 600 * 10**18;

  // Current Token ID for each Level
  uint256 public l1TokenId = 1;
  uint256 public l2TokenId = 5501;
  uint256 public l3TokenId = 8001;

  // Base URL for Metadata
  string public baseURI;
  mapping(address => uint256) public mintTimes;

  bool public mintPaused = true;

  IERC20 public token;

  modifier mintNotPaused() {
    require(!mintPaused, "Meta Passport: Mint event is paused");
    _;
  }

  modifier l1NotExceeded() {
    require(l1TokenId < MAX_L1_ID, "MetaMata Passport: Max level 1 passports has been minted");
    _;
  }

  modifier l2NotExceeded() {
    require(l2TokenId < MAX_L2_ID, "MetaMata Passport: Max level 2 passports has been minted");
    _;
  }

  modifier l3NotExceeded() {
    require(l3TokenId < MAX_L3_ID, "MetaMata Passport: Max level 3 passports has been minted");
    _;
  }

  event MintPaused(address account);

  event MintUnpaused(address account);

  event BaseURIUpdated(address account, string baseURI);

  event L1Minted(address account, uint256 tokenId, uint256 price);

  event L2Minted(address account, uint256 tokenId, uint256 price);

  event L3Minted(address account, uint256 tokenId, uint256 price);

  constructor() ERC721("Meta Passport", "METAPASS") {
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(META_ADMIN_ROLE, _msgSender());

    baseURI = "ipfs://YOUR_IPFS_URI/";
  }

  function mintL1() external payable nonReentrant mintNotPaused() l1NotExceeded() {
    smartMint(_msgSender(), l1TokenId, l1Price);

    emit L1Minted(_msgSender(), l1TokenId, l1Price);

    l1TokenId++;
  }

  function mintL2() external payable nonReentrant mintNotPaused() l2NotExceeded() {
    smartMint(_msgSender() , l2TokenId, l2Price);

    emit L2Minted(_msgSender(), l2TokenId, l2Price);

    l2TokenId++;
  }

  function mintL3() external payable nonReentrant mintNotPaused() l3NotExceeded() {
    smartMint(_msgSender(), l3TokenId, l3Price);

    emit L3Minted(_msgSender(), l3TokenId, l3Price);

    l3TokenId++;
  }

  function adminMintL1(address _to) external l1NotExceeded() onlyRole(META_ADMIN_ROLE) {
    _safeMint(_to, l1TokenId);

    l1TokenId++;
  }

  function adminMintL2(address _to) external l2NotExceeded() onlyRole(META_ADMIN_ROLE) {
    _safeMint(_to, l2TokenId);

    l2TokenId++;
  }

  function adminMintL3(address _to) external l3NotExceeded() onlyRole(META_ADMIN_ROLE) {
    _safeMint(_to, l3TokenId);

    l3TokenId++;
  }

  function smartMint(address _addr, uint256 _tokenId, uint256 _price) private {

    uint256 times = mintTimes[_addr];

    require(times < 10, "MetaMata Passport: sender has already minted");
    require(msg.value >= _price, "MetaMata Passport: sender has not paid required Ether amount");

    _safeMint(_addr, _tokenId);

    mintTimes[_msgSender()] = ++times;
  }

  function setBaseURI(string memory _baseURI) external onlyRole(META_ADMIN_ROLE) {
    baseURI = _baseURI;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "MetaMata Passport: URI query for nonexistent token");

    string memory json = ".json";
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), json)) : "";
  }

  function withdraw() external onlyRole(META_ADMIN_ROLE) {
    uint256 balance = address(this).balance;

    payable(_msgSender()).transfer(balance);
  }

  function setL1Price(uint256 _price) external onlyRole(META_ADMIN_ROLE) {
    l1Price = _price;
  }

  function setL2Price(uint256 _price) external onlyRole(META_ADMIN_ROLE) {
    l2Price = _price;
  }

  function setL3Price(uint256 _price) external onlyRole(META_ADMIN_ROLE) {
    l3Price = _price;
  }

  function pauseMint() external onlyRole(META_ADMIN_ROLE) {
    mintPaused = true;
    emit MintPaused(_msgSender());
  }

  function unpauseMint() external onlyRole(META_ADMIN_ROLE) {
    mintPaused = false;
    emit MintUnpaused(_msgSender());
  }

  function walletOfOwner(address _owner) public view returns(uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);

    uint256[] memory tokensId = new uint256[](tokenCount);

    for(uint256 i; i < tokenCount; i++){
      tokensId[i] = tokenOfOwnerByIndex(_owner, i);
    }

    return tokensId;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControl) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

}
