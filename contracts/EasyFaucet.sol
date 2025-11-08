// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract EasyFaucet is Initializable, OwnableUpgradeable {
    string public name;
    address[] private tokens;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner,
        string memory name_,
        address[] memory tokens_
    ) public initializer {
        __Ownable_init(initialOwner);

        name = name_;

        for (uint i; i < tokens_.length; i++) {
            tokens.push(tokens_[i]);
        }
    }

    function addToken(address token) public onlyOwner {
        tokens.push(token);
    }

    function claim(address token, uint256 amount, address recipient) public {
        IERC20(token).transfer(recipient, amount);
    }

    function tokenInfos()
        public
        view
        returns (
            address[] memory,
            string[] memory,
            uint8[] memory,
            uint256[] memory
        )
    {
        string[] memory symbols = new string[](tokens.length);
        uint8[] memory decimals = new uint8[](tokens.length);
        uint256[] memory balance = new uint256[](tokens.length);

        for (uint i; i < tokens.length; i++) {
            symbols[i] = IERC20Metadata(tokens[i]).symbol();
            decimals[i] = IERC20Metadata(tokens[i]).decimals();
            balance[i] = IERC20(tokens[i]).balanceOf(address(this));
        }

        return (tokens, symbols, decimals, balance);
    }
}
