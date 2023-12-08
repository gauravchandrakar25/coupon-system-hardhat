require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "polygon_mumbai",
  networks: {
    hardhat: {
    },
    polygon_mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: ["787ea5cf0dba2d628e0cdb49dc59b7e22bcc5dca5d64555917396df4180e1c64"]
    }
  },
  etherscan: {
    apiKey: "6EJUM9X1Z6I8QME7E2696JTSB8RX1FA2MB"
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}