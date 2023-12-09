require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "polygon_mumbai",
  networks: {
    hardhat: {},
    polygon_mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [
        "787ea5cf0dba2d628e0cdb49dc59b7e22bcc5dca5d64555917396df4180e1c64",
      ],
    },
    scrollSepolia: {
      url: "https://sepolia-rpc.scroll.io/" || "",
      accounts: [
        "2c208f9982e1a3c8639f2f59449b4403db60d5a0495001c386ed854da7c56c82",
      ],
    },
  },
  etherscan: {
    apiKey: "6EJUM9X1Z6I8QME7E2696JTSB8RX1FA2MB",
  },
  customChains: [
    {
      network: "scrollTestnet",
      chainId: 534351,
      urls: {
        apiURL: "https://sepolia-rpc.scroll.io",
        browserURL: "https://sepolia.scrollscan.com/",
      },
    },
  ],
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
