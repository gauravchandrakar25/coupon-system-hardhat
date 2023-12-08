import hre from "hardhat"

async function main() {
  const CouponToken = await hre.ethers.getContractFactory("CouponToken");
  const coupon = await CouponToken.deploy();

  await coupon.deployed();

  console.log(
    `Contract deployed ${coupon.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});