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
    error NotPlayGame();

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
        Player memory bot = Player(address(this), 50, 5, true);
        players.push(bot);
        bot = Player(address(this), 50, 6, true);
        players.push(bot);
    }

    /// @notice players can set speed
    function setPlayerSpeed(uint256 speed) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender]].speed = speed;
    }

    function playGame(address player) public {
        if (players.length == 4) revert("game is started");
        if (player != msg.sender) 
            revert("msg.sender can not play.");
        
        if (playersExists[msg.sender] == 0) {
            address newPlayerAddress = msg.sender;
            Player memory newPlayer = Player(newPlayerAddress, 50, random(), true);
            players.push(newPlayer);
            playersExists[newPlayerAddress] = players.length - 1;
        }

        uint256 playerIndex = playersExists[player];
        players[playerIndex].fuel = players[playerIndex].fuel - players[playerIndex].speed;
        players[0].fuel = players[0].fuel - players[0].speed;
        players[1].fuel = players[1].fuel - players[1].speed;
    }

    function initPlayers() public {
        delete players;

        Player memory bot = Player(address(this), 50, 5, true);
        players.push(bot);
        bot = Player(address(this), 50, 6, true);
        players.push(bot);

        playersExists[msg.sender] = 0;
    }

    function setPlayerFuel(uint256 fuel) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender]].fuel = fuel;
        //rule 1
        if (fuel == 0) players[playersExists[msg.sender]].alive = false;

        //rule 2  Iterate through players to find the player with the minimum speed
        uint256 minPlayerSpeed = players[0].speed;
        for (uint256 i = 1; i < players.length; i++) {
            if (players[i].speed < minPlayerSpeed) {
                minPlayerSpeed = players[i].speed;
            }
        }
        if (players[playersExists[msg.sender]].speed <= minPlayerSpeed) {
            players[playersExists[msg.sender]].alive = false;
        }
    }

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }

    function setPlayerAlive(bool alive) public onlyPlayer(msg.sender) {
        players[playersExists[msg.sender] - 1].alive = alive;
    }

    function random() internal view returns (uint) {
        uint seed = uint(keccak256(abi.encodePacked(
            block.timestamp,
            block.difficulty, //prevrandao,
            blockhash(block.number - 1)
        )));
        uint speed = (seed % 10) + 1;
        return speed;
    }

    modifier onlyPlayer(address _player) {
        require (
            playersExists[_player] < players.length &&
            playersExists[_player] > 0,
            "msg.sender is not player."
        );

        _;
    }
}