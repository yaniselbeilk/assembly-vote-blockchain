// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Election is Ownable {
    
    using SafeMath for uint256;
    // Store Candidates Count
    uint public resolutionsCount;

    
    constructor() Ownable(name) {}
    
    // Model a Candidate
    struct resolution {
        uint256 id;
        string name;
        uint voteCount;
        uint voteFor;
        uint voteAgainst;
        uint voteNeutral;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => resolution) public resolutions;

    // voted event
    event votedEvent ( uint indexed _candidateId);

    function addResolution (string memory _name) public onlyOwner {
        resolutionsCount ++;
        resolutions[resolutionsCount] = resolution(resolutionsCount, _name, 0, 0, 0, 0);
    }

    function vote (uint _resolutionId, string memory v) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_resolutionId > 0 && _resolutionId <= resolutionsCount);
        
        // add type of vote
        if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("F"))) resolutions[_resolutionId].voteFor ++;
        else if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("A"))) resolutions[_resolutionId].voteAgainst ++;
        else if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("N"))) resolutions[_resolutionId].voteNeutral++;

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        resolutions[_resolutionId].voteCount ++;

        // trigger voted event
        emit votedEvent (_resolutionId);
    }
}