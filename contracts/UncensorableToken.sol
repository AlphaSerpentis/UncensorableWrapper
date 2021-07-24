// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.4;

import {ERC20Upgradeable} from "./oz/token/ERC20/ERC20Upgradeable.sol";
import {ERC20, IERC20} from "./oz/token/ERC20/ERC20.sol";
import {SafeERC20} from "./oz/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardUpgradeable} from "./oz/security/ReentrancyGuardUpgradeable.sol";

contract UncensorableToken is ERC20Upgradeable, ReentrancyGuardUpgradeable {
    using SafeERC20 for IERC20;

    address public underlyingToken;

    event Wrapped(uint256 amount);
    event Unwrapped(uint256 amount);

    function initialize(
        string memory _name,
        string memory _symbol,
        address _whoAreWeWrapping
    ) external initializer {
        __ERC20_init_unchained(_name, _symbol);
        underlyingToken = _whoAreWeWrapping;
    }

    function wrap(uint256 _amount) external {
        IERC20(underlyingToken).safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);

        emit Wrapped(_amount);
    }

    function unwrap(uint256 _amount) external {
        IERC20(underlyingToken).safeTransfer(msg.sender, _amount);
        _burn(msg.sender, _amount);

        emit Unwrapped(_amount);
    }

    function decimals() public view override returns(uint8) {
        return ERC20(underlyingToken).decimals();
    }

}