import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

import DeployEasyFaucetFactory from "./02_Deploy_EasyFaucetFactory_UUPS.js";

export default buildModule("UpgradeEasyFaucetFactory", (m) => {
    const initialOwner = m.getAccount(0);

    const { uups } = m.useModule(DeployEasyFaucetFactory);

    // step1: deploy implemention
    const easyFaucetFactory = m.contract("EasyFaucetFactory");

    // step2: call upgradeToAndCall for doing upgrade
    // function upgradeToAndCall(address newImplementation, bytes memory data)
    // 20251108 使用这行代码升级会报错：`- HHE10708: Function 'upgradeToAndCall' not found in contract ERC1967Proxy`
    // m.call(uups, "upgradeToAndCall", [easyFaucetFactory, "0x"], { from: initialOwner });
    // 20251108 所以改用下面的方式
    const uupsProxy = m.contractAt("EasyFaucetFactory", uups);
    m.call(uupsProxy, "upgradeToAndCall", [easyFaucetFactory, "0x"], { from: initialOwner });

    return { easyFaucetFactory };
});