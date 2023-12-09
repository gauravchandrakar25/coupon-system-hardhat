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

3. **Compile Contracts:**
   ```bash
   npx hardhat compile
   ```

4. **Run Tests:**
   ```bash
   npx hardhat test
   ```

## Usage

To interact with the Coupon System, you can deploy the smart contract on a local Ethereum network or use a testnet. You can then use the provided scripts or write your own to create and redeem coupons.

Example Script for Creating a Coupon:
```bash
npx hardhat run scripts/createCoupon.js
```

Example Script for Redeeming a Coupon:
```bash
npx hardhat run scripts/redeemCoupon.js
```

## Smart Contracts

- **CouponManager.sol:**
  The main smart contract that manages the creation and redemption of coupons.

- **Coupon.sol:**
  Represents a coupon with details such as the discount percentage, expiration date, etc.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

## License

This Coupon System is open-source and available under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to the Hardhat development community for providing a robust Ethereum development environment.

Happy coding!
