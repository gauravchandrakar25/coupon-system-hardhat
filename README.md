# Coupon System with Hardhat

This repository contains a Coupon System built using Hardhat, a development environment for Ethereum smart contracts. The Coupon System allows users to create and redeem coupons on the Ethereum blockchain.

## Getting Started

Follow these steps to set up the Coupon System on your local machine:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/gauravchandrakar25/coupon-system-hardhat.git
   ```

2. **Install Dependencies:**
   ```bash
   cd coupon-system-hardhat
   npm install
   ```

3. **Deploy Contracts:**
   ```bash
   npx hardhat run scripts/deploy.ts --network polygon_mumbai
   ```

## Usage

To interact with the Coupon System, you can deploy the smart contract on a local Ethereum network or use a testnet. I have used Polygon Mumbai testnet to deploy the smartcontract. You can then use the provided scripts or write your own to create and redeem coupons.

## Smart Contracts

- **CouponToken.sol:**
  The main smart contract that manages the creation and redemption of coupons.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

## License

This Coupon System is open-source and available under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to the Hardhat development community for providing a robust Ethereum development environment.

Happy coding!
