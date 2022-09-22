// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract NftMarket is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _listedItems;
    Counters.Counter private _tokenIds; //唯一

    uint256 public listingPrice = 0.025 ether;

    struct NftItem {
        uint256 tokenId;
        uint256 price;
        address creator;
        bool isListed;
    }
    event NftItemCreated(
        uint256 tokenId,
        uint256 price,
        address creator,
        bool isListed
    );

    mapping(string => bool) private _usedTokenURIs; //tokenid 是否使用
    mapping(uint256 => NftItem) private _idToNftItem;

    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _idToOwnedIndex;

    uint256[] private _allNfts;
    mapping(uint256 => uint256) private _idToNftIndex;

    constructor() ERC721("CreaturesNFT", "CNFT") {}

    function setListingPrice(uint256 newPrice) external onlyOwner {
        require(newPrice > 0, "Price must be at least 1 wei");
        listingPrice = newPrice;
    }

    function tokenURIExists(string memory tokenURI) public view returns (bool) {
        return _usedTokenURIs[tokenURI] == true;
    }

    function getNftItem(uint256 tokenId) public view returns (NftItem memory) {
        return _idToNftItem[tokenId];
    }

    function listedItemsCount() public view returns (uint256) {
        return _listedItems.current();
    }

    function totalSupply() public view returns (uint256) {
        return _allNfts.length;
    }

    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "Index out of bounds");
        return _allNfts[index];
    }

    function getAllNftsOnSale() public view returns (NftItem[] memory){
        uint allItemsCounts = totalSupply();
        uint currentIndex = 0;
        NftItem[] memory items = new NftItem[](_listedItems.current());
        for (uint i =0 ;i<allItemsCounts;i++){
            uint tokenId = tokenByIndex(i);
            NftItem storage item = _idToNftItem[tokenId];
            if(item.isListed == true){
                items[currentIndex]=item;
                currentIndex +=1;
            }
        }
        return items;
    }
    function tokenOfOwnerByIndex(address owner,uint index) public view returns(uint){
        require(index<ERC721.balanceOf(owner),"Index out of bounds");
        return _ownedTokens[owner][index];
    }

    function getOwnedNfts() public view returns(NftItem[] memory){
        uint OWnedItemsCount=ERC721.balanceOf(msg.sender);
        NftItem[] memory items = new NftItem[](OWnedItemsCount);
        for(uint i =0; i< OWnedItemsCount ;i++){
            uint tokenId = tokenOfOwnerByIndex(msg.sender,i);
            NftItem storage item = _idToNftItem[tokenId];
            items[i]= item;
        }
        return items;
    }

    function mintToken(string memory tokenURI, uint256 price)
        public
        payable
        returns (uint256)
    {
        // no Exist continue
        require(!tokenURIExists(tokenURI), "Token URI already exists");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        _tokenIds.increment();
        _listedItems.increment();

        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _createNftItem(newTokenId, price);
        _usedTokenURIs[tokenURI] = true;

        return newTokenId;
    }

    function buyNft(uint256 tokenId) public payable {
        uint256 price = _idToNftItem[tokenId].price;
        address owner = ERC721.ownerOf(tokenId);
        require(msg.sender != owner, "You already own this NFT");
        require(msg.value == price, "Please submit the asking price");

        _idToNftItem[tokenId].isListed = false;
        _listedItems.decrement();

        _transfer(owner, msg.sender, tokenId);
        payable(owner).transfer(msg.value);
    }

    function _createNftItem(uint256 tokenId, uint256 price) private {
        require(price > 0, "Price must be at least 1 wei");
        _idToNftItem[tokenId] = NftItem(tokenId, price, msg.sender, true);
        emit NftItemCreated(tokenId, price, msg.sender, true);
    }

    //代币转移前
    //这包括铸币和燃烧。
    //   *
    //   * 调用条件：
    //   *
    //   * - 当 `from` 和 `to` 都非零时，`from` 的 `tokenId` 将是
    //   * 转移到`to`。
    //   * - 当 `from` 为零时，`tokenId` 将为`to` 铸造。
    //   * - 当 `to` 为零时，`from` 的 `tokenId` 将被烧毁。
    //   * - `from` 和 `to` 永远不会都是零。
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);


        // minting token
        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        }
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _idToNftIndex[tokenId] = _allNfts.length;
        _allNfts.push(tokenId);
    }
}
