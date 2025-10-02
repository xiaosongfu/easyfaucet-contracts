import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DeployEasyFaucetFactory", (m) => {
    const initialOwner = m.getAccount(0);

    // step1: deploy implemention
    const easyFaucetFactory = m.contract("EasyFaucetFactory");

    // step2: deploy UUPS
    // constructor(address implementation, bytes memory _data)
    const uups = m.contract("ERC1967Proxy", [easyFaucetFactory, m.encodeFunctionCall(easyFaucetFactory, "initialize", [initialOwner])])

    return { easyFaucetFactory, uups };
});