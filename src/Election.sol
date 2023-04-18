// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Whitelist.sol";
import "./SafeMath.sol";

contract Election is Whitelist {
    
    using SafeMath for uint256;
    // Store Candidates Count
    uint public resolutionsCount;
    
    // Model a Resolution
    struct resolution {
        uint256 id;
        string name;
        uint voteCount;
        uint voteFor;
        uint voteAgainst;
        uint voteNeutral;
        // Store accounts that have voted
        mapping (address => bool) voters;
    }

    // Store accounts that have voted
    //mapping(address => bool) public voters;
    // Store & Fetch Resolution
    mapping(uint => resolution) public resolutions;

    // voted event
    event votedEvent ( uint indexed _candidateId);

    function addResolution (string memory _name) public onlyOwner {
        resolutionsCount ++;
        resolution storage newResolution = resolutions[resolutionsCount];
        newResolution.id = resolutionsCount;
        newResolution.name = _name;
        newResolution.voteAgainst = 0;
        newResolution.voteCount = 0;
        newResolution.voteNeutral = 0;
    }

    function createResolution(uint256 _id, string memory _name) internal returns (resolution storage) {
        resolution storage res = resolutions[_id];
        res.id = _id;
        res.name = _name;
        res.voteCount = 0;
        res.voteFor = 0;
        res.voteAgainst = 0;
        res.voteNeutral = 0;
        return res;
    }
    

    function vote (uint _resolutionId, string memory v) public {

        // require that they haven't voted before for this resolution
        require(!resolutions[_resolutionId].voters[msg.sender]);

        // require a valid resolution
        require(_resolutionId > 0 && _resolutionId <= resolutionsCount);
        
        // add type of vote
        if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("F"))) resolutions[_resolutionId].voteFor ++;
        else if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("A"))) resolutions[_resolutionId].voteAgainst ++;
        else if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("N"))) resolutions[_resolutionId].voteNeutral++;
        else revert();

        // record that voter has voted
        resolutions[_resolutionId].voters[msg.sender] = true;

        // update resolution vote Count
        resolutions[_resolutionId].voteCount ++;

        // trigger voted event
        emit votedEvent (_resolutionId);
    }
}