// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Whitelist is Ownable {

    constructor() Ownable(name) {}

    mapping(address => bool) public whitelist;
    event AddedBeneficiary(address indexed _beneficiary);


    function isWhitelisted(address _beneficiary) internal view returns (bool) {
      return (whitelist[_beneficiary]);
    }

    /**
     * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
     * @param _beneficiaries Addresses to be added to the whitelist
     */
    function addToWhitelist(address[] memory _beneficiaries) public onlyOwner {
      for (uint256 i = 0; i < _beneficiaries.length; i++) {
        whitelist[_beneficiaries[i]] = true;
      }
    }

    /**
     * @dev Removes single address from whitelist.
     * @param _beneficiary Address to be removed to the whitelist
     */
    function removeFromWhitelist(address _beneficiary) public onlyOwner {
      whitelist[_beneficiary] = false;
    }
}