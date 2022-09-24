

const instance = await NftMarket.deployed();


instance.mintToken("https://gateway.pinata.cloud/ipfs/QmQrgX2VRtNNjAcNX1HhiXgLTdK3HSFJiURvSt2XbucS9L","300000000000000000", {value: "25000000000000000",from: accounts[0]})
instance.mintToken("https://gateway.pinata.cloud/ipfs/QmdYMDivdYhfzWE4L3Mj9QjXN6CyaRHLpJFy3zzv43AvR2","500000000000000000", {value: "25000000000000000",from: accounts[0]})
instance.mintToken("https://gateway.pinata.cloud/ipfs/Qma4Wb6EiV7AM9kkMkeXavoaSLArk1hz6PKQZjwcfFdzqN","300000000000000000", {value: "25000000000000000",from: accounts[0]})