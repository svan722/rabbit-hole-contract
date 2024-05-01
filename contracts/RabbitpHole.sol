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
        uint256 speed;
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

    function playGame(uint256 speed, address player) public {
        if (player != msg.sender) revert("msg.sender can not play.");
        require(speed < 10, "Speed must be at least 10");

        if (playersExists[msg.sender] == 0) {
            address newPlayerAddress = msg.sender;
            Player memory newPlayer = Player(newPlayerAddress, 50, speed, true);
            players.push(newPlayer);
            playersExists[newPlayerAddress] = players.length - 1;
        } else {
            uint256 playerIndex = playersExists[player];
            players[playerIndex].fuel =
                players[playerIndex].fuel -
                players[playerIndex].speed;
            players[playerIndex].speed = speed;
            players[0].fuel = players[0].fuel - players[0].speed;
            players[1].fuel = players[1].fuel - players[1].speed;
        }
    }

    function initPlayers() public {
        delete players;
        Player memory bot = Player(address(this), 50, 5, true);
        players.push(bot);
        bot = Player(address(this), 50, 6, true);
        players.push(bot);

        playersExists[msg.sender] = 0;
    }

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }

    modifier onlyPlayer(address _player) {
        require(
            playersExists[_player] < players.length &&
                playersExists[_player] > 0,
            "msg.sender is not player."
        );

        _;
    }
}
