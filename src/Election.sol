// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Election is Ownable {
    
    using SafeMath for uint256;
    // Store Candidates Count
    uint public candidatesCount;
    uint public voteNeutral;

    
    constructor() Ownable(name) {}
    
    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
        uint voteFor;
        uint voteAgainst;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;

    // voted event
    event votedEvent ( uint indexed _candidateId);

    function addCandidate (string memory _name) public onlyOwner {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, 0, 0);
    }

    function vote (uint _candidateId, string memory v) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);
        
        // add type of vote
        if(keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("F"))) candidates[_candidateId].voteFor ++;
        else if (keccak256(abi.encodePacked(v)) == keccak256(abi.encodePacked("A"))) candidates[_candidateId].voteAgainst ++;
        else voteNeutral++;

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent (_candidateId);
    }
}
