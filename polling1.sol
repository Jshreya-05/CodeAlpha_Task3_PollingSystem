// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Polling {

    string public question;
    string[] public options;
    uint public endTime;
    bool public pollExists;

    mapping(uint => uint) public votes;
    mapping(address => bool) public hasVoted;

    // Create a new poll
    function createPoll(
        string memory _question,
        string[] memory _options,
        uint _duration
    ) public {
        require(!pollExists, "Poll already exists");

        question = _question;
        options = _options;
        endTime = block.timestamp + _duration;
        pollExists = true;
    }

    // Vote
    function vote(uint optionIndex) public {
        require(pollExists, "No poll created");
        require(block.timestamp < endTime, "Poll ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(optionIndex < options.length, "Invalid option");

        votes[optionIndex]++;
        hasVoted[msg.sender] = true;
    }

    // Get votes
    function getVotes(uint optionIndex) public view returns (uint) {
        return votes[optionIndex];
    }

    // Get option name
    function getOption(uint index) public view returns (string memory) {
        return options[index];
    }

    // Get winner
    function getWinner() public view returns (string memory) {
        require(block.timestamp >= endTime, "Poll still active");

        uint maxVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < options.length; i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
                winnerIndex = i;
            }
        }

        return options[winnerIndex];
    }
}
