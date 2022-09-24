
Marketplace has dependencies on multiple technologies.

Pinata - store images, and NFT metadata
Ganache - private Blockchain, to run application localy

## Getting Started

First, run the development server:

You should pay attention to the configuration file .env or .env.development



```bash
NEXT_PUBLIC_NETWORK_ID=5777
NEXT_PUBLIC_TARGET_CHAIN_ID=1337
NEXT_PUBLIC_PINATA_DOMAIN=https://gateway.pinata.cloud

SECRET_COOKIE_PASSWORD={your custom at least 32 characters long password!}

PINATA_API_KEY={your api key from pinata}
PINATA_SECRET_API_KEY={your api secret key from pinata}

```
* (your api pinata key has to allow `pinFileToIPFS` and `pinJSONToIPFS` rules)

3. Then migrate a contract to Ganache, contract can be found in the `contracts` folder. It's called `NftMarket.sol`

* To migrate the contract run `truffle migrate` in the terminal while Ganache network is setup and running.

* Do not forget to link `trufle-config.js` with Ganache, just go to `config` and click `Add Project`

* `keys.json` must be created if you want to deploy to Ropsten, if not, just remove import of `keys.json` from `trufle-config.js` and also comment out `ropsten` configuration

4. Now everything is setup and you can test out the app.

* Run `npm run dev` in the terminal. App will run at `localhost:3000`


## ⚡️ Tech-Stack
Typescript
 
Solidity

React hooks

Truffle / Ganache

openZeppelin

Metamask (web3)

Web3-react

Pinata IPFS

