pragma solidity ^0.8.0;

contract Votesecute {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public admin;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;

    constructor() {
        admin = msg.sender;
    }

    function addCandidate(string memory _name) public {
        require(msg.sender == admin, "Only admin can add candidates");
        candidates.push(Candidate(candidates.length, _name, 0));
    }

    function authorizeVoter(address _voter) public {
        require(msg.sender == admin, "Only admin can authorize voters");
        voters[_voter].authorized = true;
    }

    function vote(uint _candidateId) public {
        require(voters[msg.sender].authorized, "You are not authorized to vote");
        require(!voters[msg.sender].voted, "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate");

        voters[msg.sender].vote = _candidateId;
        voters[msg.sender].voted = true;
        candidates[_candidateId].voteCount++;
        totalVotes++;
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function getWinner() public view returns (string memory winnerName) {
        uint highestVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}
