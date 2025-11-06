// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract EasyFaucetFactory is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    event NewFaucet(address owner, address faucet);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function newFaucet(
        address beacon,
        address initialOwner,
        address[] memory tokens
    ) public {
        bytes memory data = abi.encodeWithSignature(
            "initialize(address,address[])",
            initialOwner,
            tokens
        );
        BeaconProxy faucet = new BeaconProxy(beacon, data);
        emit NewFaucet(initialOwner, address(faucet));
    }
}
