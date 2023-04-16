// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address private owner;
    string public name;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor(string memory _name) {
        owner = msg.sender;
        name = _name;
    }

    modifier onlyOwner {
        require(msg.sender==owner, 'caller must be an owner');
        _;
    }

    function transferOwnership(address newOwner, string memory newName) public onlyOwner () {
        require(newOwner!=address(0), "Address shouldn't be zero");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        name = newName;
    }
}