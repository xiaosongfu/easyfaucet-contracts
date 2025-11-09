import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

import DeployEasyFaucet from "./01_Deploy_EasyFaucet_Beacon.js"

export default buildModule("UpgradeEasyFaucet", (m) => {
    const initialOwner = m.getAccount(0);

    const { beacon } = m.useModule(DeployEasyFaucet);

    // step1: deploy implemention
    const easyFaucet = m.contract("EasyFaucet");

    // step2: call upgradeTo for doing upgrade
    // `function upgradeTo(address newImplementation)`
    m.call(beacon, "upgradeTo", [easyFaucet], { from: initialOwner });

    return { easyFaucet }
});
