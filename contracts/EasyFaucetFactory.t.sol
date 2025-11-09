// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {EasyFaucetFactory} from "./EasyFaucetFactory.sol";
import {EasyFaucet} from "./EasyFaucet.sol";
import {TestToken} from "./TestToken.sol";

contract EasyFaucetFactoryTest is Test {
    TestToken private tokenA;
    TestToken private tokenB;
    UpgradeableBeacon beacon;
    EasyFaucetFactory private faucetFactory;

    function setUp() public {
        tokenA = new TestToken(address(this));
        tokenB = new TestToken(address(this));

        // Deploy Beancon
        EasyFaucet faucet = new EasyFaucet();
        beacon = new UpgradeableBeacon(address(faucet), msg.sender);

        EasyFaucetFactory impl = new EasyFaucetFactory();

        ERC1967Proxy proxy = new ERC1967Proxy(
            address(impl),
            abi.encodeWithSelector(
                EasyFaucetFactory.initialize.selector,
                msg.sender
            )
        );
        faucetFactory = EasyFaucetFactory(address(proxy));
    }

    function test_NewFaucet() public {
        string memory name = "MyFaucet";

        address[] memory tokens = new address[](2);
        tokens[0] = address(tokenA);
        tokens[1] = address(tokenB);

        // event NewFaucet(address indexed owner, string name, address faucet);
        vm.expectEmit(true, true, false, false);
        emit EasyFaucetFactory.NewFaucet(msg.sender, "", address(0));
        faucetFactory.newFaucet(address(beacon), msg.sender, name, tokens);
    }
}
