import "dotenv/config";
require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");

module.exports = {
  defaultNetwork: "polygon_mumbai",
  sourcify: {
    enabled: true,
  },
  networks: {
    polygon_mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.POLYGON_PRIVATE_KEY],
    },
    scrollSepolia: {
      url: "https://sepolia-rpc.scroll.io/" || "",
      accounts: [process.env.SCROLL_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      scrollSepolia: process.env.SCROLL_API,
      polygon_mumbai: process.env.MUMBAI_API,
    },
    customChains: [
      {
        network: "scrollSepolia",
        chainId: 534351,
        urls: {
          apiURL: "https://api-sepolia.scrollscan.com/api",
          browserURL: "https://api.sepolia.scrollscan.com/api",
        },
      },
    ],
  },
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
