// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleCollectable is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 public price;

    constructor(uint256 _price) public ERC721("SimpleCollectable", "SC") {
        tokenCounter = 0;
        price = _price;
    }

    function createCollectable(string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }

    function buyCollectable(string memory tokenURI) public payable returns (uint256) {
        require(msg.value >= price, "Not enough Ether to buy the NFT");
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
}