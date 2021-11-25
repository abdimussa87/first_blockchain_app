// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalNumberOfWaves;
    event NewWave(address indexed_from, uint256 timestamp, string message);
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] public waves;

    uint256 private seed;

    //rate limiting to prevent spamming with the intention of winning a prize
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Wave portal constructor running");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function getTotalNumberOfWaves() public view returns (uint256) {
        console.log("We have %d people waved at us.", totalNumberOfWaves);
        return totalNumberOfWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function wave(string memory message) public {
        //checking if it has been 15 minutes since the last request
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15m before another transaction.");

        lastWavedAt[msg.sender] = block.timestamp;

        totalNumberOfWaves += 1;
        // wallet address of the person who called the function
        console.log("%s has waved.", msg.sender);
        waves.push(Wave(msg.sender, message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        //Give reward if the seed is greater than 50%
        if (seed > 50) {
            console.log("%s won!!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "The smart contract does not have enough balance to reward wavers"
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract");
        }

        emit NewWave(msg.sender, block.timestamp, message);
    }
}
