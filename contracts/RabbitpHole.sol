// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/**
    ██████╗  █████╗ ██████╗ ██████╗ ██╗████████╗██████╗ ██╗  ██╗ ██████╗ ██╗     ███████╗
    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║  ██║██╔═══██╗██║     ██╔════╝
    ██████╔╝███████║██████╔╝██████╔╝██║   ██║   ██████╔╝███████║██║   ██║██║     █████╗  
    ██╔══██╗██╔══██║██╔══██╗██╔══██╗██║   ██║   ██╔═══╝ ██╔══██║██║   ██║██║     ██╔══╝  
    ██║  ██║██║  ██║██████╔╝██████╔╝██║   ██║   ██║     ██║  ██║╚██████╔╝███████╗███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
*/
/// @notice
contract RabbitHole {
    struct Player {
        address player;
        uint256 fuel;
        uint256 speed;
        bool alive;
    }

    struct GameData {
        Player[] players;
        uint speed;
    }

    Player[] private players;
    mapping(address => uint256) public playersExists;

    /// @notice There are two bots
    constructor() {
        Player memory bot = Player(address(this), 50, 500, true);
        players.push(bot);
        bot = Player(address(this), 50, 600, true);
        players.push(bot);
    }

    function addPlayer() public onlyNilPlayer(msg.sender) {
        address newPlayerAddress = msg.sender;
        Player memory newPlayer = Player(newPlayerAddress, 50, 0, true);
        players.push(newPlayer);
        playersExists[newPlayerAddress] = players.length - 1;
    }

    /// @notice players can set speed
    function setPlayerSpeed(uint256 speed) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender]].speed = speed;
    }

    function setPlayerFuel(uint256 fuel) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender] - 1].fuel = fuel;
        //rule 1
        if (fuel == 0) players[playersExists[msg.sender] - 1].alive = false;

        //rule 2  Iterate through players to find the player with the minimum speed
        uint256 minPlayerSpeed = players[0].speed;
        for (uint256 i = 1; i < players.length; i++) {
            if (players[i].speed < minPlayerSpeed) {
                minPlayerSpeed = players[i].speed;
            }
        }
        if (players[playersExists[msg.sender] - 1].speed <= minPlayerSpeed) {
            players[playersExists[msg.sender] - 1].alive = false;
        }
    }

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }

    function setPlayerAlive(bool alive) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender] - 1].alive = alive;
    }

    function random() internal view returns (uint) {
        uint seed = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1)))
        ) % 300;
        uint adjusted = seed + 500;
        return adjusted;
    }

    modifier onlyPlayer(address _player) {
        require (
            playersExists[_player] < players.length &&
            playersExists[_player] > 0,
            "msg.sender is not player."
        );

        _;
    }

    modifier onlyNilPlayer(address _player) {
        require (
            playersExists[_player] > players.length - 1 ||
            playersExists[_player] == 0,
            "msg.sender is player"
        );

        _;
    }
}