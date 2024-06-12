// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleCollectable is ERC721, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => uint256) public tokenPrices;

    event CollectableCreated(uint256 indexed tokenId, string tokenURI, address indexed owner, uint256 price);
    event CollectableSold(uint256 indexed tokenId, address indexed newOwner, uint256 price);

    constructor() public ERC721("SimpleCollectable", "SC") {
        tokenCounter = 0;
    }

    function createCollectable(string memory tokenURI, uint256 price) public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenPrices[newItemId] = price;
        tokenCounter += 1;
        emit CollectableCreated(newItemId, tokenURI, msg.sender, price);
        return newItemId;
    }

    function purchaseCollectable(uint256 tokenId) public payable {
        uint256 price = tokenPrices[tokenId];
        require(msg.value >= price, "Not enough Ether to buy the NFT");
        address owner = ownerOf(tokenId);
        require(owner != msg.sender, "Owner cannot buy their own NFT");

        _transfer(owner, msg.sender, tokenId);
        payable(owner).transfer(msg.value);

        emit CollectableSold(tokenId, msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setPrice(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can set the price");
        tokenPrices[tokenId] = price;
    }
}
