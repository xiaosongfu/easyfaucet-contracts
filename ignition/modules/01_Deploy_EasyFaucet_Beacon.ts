import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DeployEasyFaucet", (m) => {
    const initialOwner = m.getAccount(0);

    // step1: deploy implemention
    const easyFaucet = m.contract("EasyFaucet");

    // step2: deploy Beacon
    // constructor(address implementation_, address initialOwner) Ownable(initialOwner)
    const beacon = m.contract("UpgradeableBeacon", [easyFaucet, initialOwner])

    return { easyFaucet, beacon };
});