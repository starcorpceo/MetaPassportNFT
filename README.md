# Meta Passport NFT

Meta Passport NFT is a membership based NFT which provides members access to exclusive rights in the metaverse.

There are 3 levels of passports in this smart contract that allows you to mint different levels individually.

This smart contract can be deployed on Polygon (Ethereum Layer 2). However it is Ethereum EVM compatible.

## Setup Hardhat
1. Install Hardhat
    npm install --save-dev hardhat

2. To use your local installation of Hardhat, you need to use npx to run it (i.e. npx hardhat)

3. Check local account
    npx hardhat accounts
    
4. Test the smart contract
    npx hardhat test

## Deploy Smart Contract

1. starting hardhat local network
    npx hardhat node

2. Deploy to local
    npx hardhat run scripts/deploy.js --network localhost
    
3. Deploy to Polygon Mumbai
    npx hardhat run scripts/deploy.js --network mumbai
    
4. Deploy to Polygon Mainnet
    npx hardhat run scripts/deploy.js --network polygon
    
## Verify Smart Contract
1. Install Hardhat Etherscan plugin (compatible with Etherscan and Polygonscan)
    npm install --save-dev @nomiclabs/hardhat-etherscan
    
2. npx hardhat verify --network polygon YOUR_CONTRACT_ADDRESS


