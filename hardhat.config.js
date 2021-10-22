require("@nomiclabs/hardhat-waffle");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");

const { privateKey } = require("./secrets.json");

module.exports = {
  defaultNetwork: "polygon",
  networks: {
    hardhat: {},
    localhost: {
      url: "http://127.0.0.1:8545",
    },

    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [privateKey],
    },

    polygon: {
      url: "https://rpc-mainnet.maticvigil.com",
      accounts: [privateKey],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://polygonscan.com/
    apiKey: "YOUR_API_KEY",
  },

  solidity: "0.8.0",
};
