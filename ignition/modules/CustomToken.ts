import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CustomTokenModule = buildModule("CustomTokenModule", (m) => {
  const name = "MyToken";
  const symbol = "MTK";

  const CustomToken = m.contract("CustomToken", [name, symbol]);

  return { CustomToken };
});

export default CustomTokenModule;
