const NftMarket = artifacts.require("NftMarket");
const { ethers, Contract } = require("ethers");

Contract("NftMarket", (account) => {
  let _contract = null;
  let _nftPrice = ethers.utils.parseEther("0.3").toString();
  let _listingPrice = ethers.utils.parseEther("0.025").toString();

  before(async () =>{
    _contract =await NftMarket.deployed();
  })
});
