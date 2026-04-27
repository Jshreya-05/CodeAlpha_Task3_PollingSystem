// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Polling {

    string public question;
    string[] public options;
    uint public endTime;

    mapping(uint => uint) public votes;
    mapping(address => bool) public hasVoted;

    // Create a new poll
    function createPoll(
        string memory _question,
        string[] memory _options,
        uint _duration
    ) public {
        question = _question;
        options = _options;
        endTime = block.timestamp + _duration;
    }

    // Vote for an option
    function vote(uint optionIndex) public {
        require(block.timestamp < endTime, "Poll ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(optionIndex < options.length, "Invalid option");

        votes[optionIndex]++;
        hasVoted[msg.sender] = true;
    }

    // Get votes of an option
    function getVotes(uint optionIndex) public view returns (uint) {
        return votes[optionIndex];
    }

    // Get option name
    function getOption(uint index) public view returns (string memory) {
        return options[index];
    }
}