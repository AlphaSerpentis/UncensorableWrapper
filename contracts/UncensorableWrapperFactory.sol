// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.4;

import {UncensorableToken} from "./UncensorableToken.sol";
import {ReentrancyGuard} from "./oz/security/ReentrancyGuard.sol";
import {ERC20} from "./oz/token/ERC20/ERC20.sol";
import {Clones} from "./oz/proxy/Clones.sol";

contract UncensorableWrapperFactory is ReentrancyGuard {

    /// @dev Mapping pointing to the wrapped variant
    mapping(address => address) public wrapped;
    /// @dev Implementation of the uncensorable token
    address public immutable implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    /// @dev Deploys a new uncensorable version of the token
    function deployUncensorableToken(
        address _tokenToWrap
    ) external nonReentrant() {
        require(wrapped[_tokenToWrap] == address(0), "Already wrapped");

        UncensorableToken uncensored = UncensorableToken(Clones.clone(implementation));

        uncensored.initialize(ERC20(_tokenToWrap).name(), ERC20(_tokenToWrap).symbol(), _tokenToWrap);
        
        wrapped[_tokenToWrap] = address(uncensored);
    }

}