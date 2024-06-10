import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TokenSwapModule = buildModule("TokenSwapModule", (m) => {
  const tokenAAddress = "0x123..."; // Replace with the actual address of token A
  const tokenBAddress = "0x456..."; // Replace with the actual address of token B
  const priceFeedAAddress = "0x789..."; // Replace with the actual address of price feed for token A
  const priceFeedBAddress = "0xabc..."; // Replace with the actual address of price feed for token B
  const swapPercent = 10; // Percentage of extra B tokens to give away

  const TokenSwap = m.contract("TokenSwap", [tokenAAddress, tokenBAddress, priceFeedAAddress, priceFeedBAddress, swapPercent]);

  return { TokenSwap };
});

export default TokenSwapModule;
