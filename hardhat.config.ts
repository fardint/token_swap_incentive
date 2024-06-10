import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import * as dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    polygonAmoyTestnet: {
      url: "https://rpc-amoy.polygon.technology/",
      chainId: 80002,
      accounts: privateKey ? [`0x${privateKey}`] : []
    }
  }
};

export default config;
