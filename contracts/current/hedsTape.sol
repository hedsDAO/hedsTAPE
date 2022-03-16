// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HedsTape is Ownable, ERC721 {
  Counters.Counter private _tokenIds;
  using Counters for Counters.Counter;
  using Strings for uint256;
  mapping(uint256 => string) private _tokenURIs;
  string private _baseURIextended;
  uint256 public constant HEDS_PRICE = 100000000000000000; // 0.1 ETH
  uint256 public MAX_HEADS = 100;

  constructor() public ERC721("hedsTAPE 2", "HT2") {
    setBaseURI("ipfs://QmVDgEqUoevFn7wPn8FzwY9b3NvZxnAbW9RZLh6q6r67kx");
  }
  function setBaseURI(string memory baseURI_) internal onlyOwner {
    _baseURIextended = baseURI_;
  }
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseURIextended;
  }
  function mintHead() public payable returns (uint256) {
    _tokenIds.increment();
    uint256 current = _tokenIds.current(); // set newItemId = (1, ...)
    require((HEDS_PRICE == msg.value), "ERC721Metadata: invalid amount of ether recieved");
    require(current <= MAX_HEADS, "ERC721Metadata: max hedsTapes minted"); // check to make sure newItemId less than 10
    require((bytes(_baseURIextended).length > 0), "ERC721Metadata: this tape has not been made public"); // 
    _safeMint(msg.sender, current);
    return current;
  }
  receive() external payable {}
  fallback() external payable {}
  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
  function withdraw() public onlyOwner {
    uint balance = address(this).balance;
    payable(msg.sender).transfer(balance);
  }
  function totalSupply() public view returns (uint256) {
    return _tokenIds.current();
  }
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    return _baseURIextended;
  }
}
