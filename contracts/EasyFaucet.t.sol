// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
// import {console} from "forge-std/console.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {EasyFaucet} from "./EasyFaucet.sol";
import {TestToken} from "./TestToken.sol";

contract EasyFaucetTest is Test {
    TestToken private tokenA;
    TestToken private tokenB;
    EasyFaucet private faucet;

    function setUp() public {
        tokenA = new TestToken(address(this));
        tokenB = new TestToken(address(this));

        string memory name = "MyFaucet";

        address[] memory tokens = new address[](2);
        tokens[0] = address(tokenA);
        tokens[1] = address(tokenB);

        // Deploy Implementation
        EasyFaucet impl = new EasyFaucet();
        // Deploy Beacon
        UpgradeableBeacon beacon = new UpgradeableBeacon(
            address(impl),
            msg.sender
        );
        // Deploy BeaconProxy
        BeaconProxy proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                EasyFaucet.initialize.selector,
                msg.sender,
                name,
                tokens
            )
        );
        faucet = EasyFaucet(address(proxy));
    }

    function test_TokenInfos() public view {
        (
            address[] memory tokenAddresses,
            string[] memory symbols,
            uint8[] memory decimals,
            uint256[] memory balances
        ) = faucet.tokenInfos();

        require(tokenAddresses.length == 2, "Should have 2 tokens");
        require(
            tokenAddresses[0] == address(tokenA),
            "tokenA address should match"
        );
        require(
            tokenAddresses[1] == address(tokenB),
            "tokenB address should match"
        );
        require(
            keccak256(bytes(symbols[0])) == keccak256(bytes("TTK")),
            "tokenA symbol should be TTK"
        );
        require(
            keccak256(bytes(symbols[1])) == keccak256(bytes("TTK")),
            "tokenB symbol should be TTK"
        );
        require(
            decimals[0] == tokenA.decimals(),
            "tokenA decimals should match"
        );
        require(
            decimals[1] == tokenB.decimals(),
            "tokenB decimals should match"
        );
        require(balances[0] == 0, "EasyFaucet's tokenA balance should match");
        require(balances[1] == 0, "EasyFaucet's tokenB balance should match");
    }

    function test_Claim() public {
        uint256 claimAmount = 100 * 10 ** tokenA.decimals();

        // console.log(tokenA.owner(), msg.sender);
        tokenA.mint(address(faucet), claimAmount * 2);
        require(
            claimAmount * 2 == tokenA.balanceOf(address(faucet)),
            "EasyFaucet's tokenA balance should match"
        );

        address recipient = address(1);
        require(
            0 == tokenA.balanceOf(recipient),
            "tokenA balance should match"
        );

        // claim tokenA to recipient
        faucet.claim(address(tokenA), claimAmount, recipient);
        require(
            claimAmount == tokenA.balanceOf(recipient),
            "recipient's tokenA balance should match"
        );
        require(
            claimAmount == tokenA.balanceOf(address(faucet)),
            "EasyFaucet's tokenA balance should match"
        );
    }
}
