// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

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

    Player[] private players;

    mapping(address => uint256) public playersExists;

    /// @notice There are two bots
    constructor() {
        Player memory bot = Player(address(this), 50, 5, true);
        players.push(bot);
        bot = Player(address(this), 50, 6, true);
        players.push(bot);
    }

    function playGame(uint256 speed) public {
        require(speed <= 10, "Speed must be at least 10");

        uint256 playerIndex = playersExists[msg.sender];
        if (playersExists[msg.sender] == 0) {
            Player memory newPlayer = Player(msg.sender, 50, speed, true);
            players.push(newPlayer);
            playerIndex = players.length - 1;
            playersExists[msg.sender] = playerIndex;
        } else {
            players[playerIndex].speed = speed;
        }
        for (uint256 i = 0; i < players.length; i++) {
            players[i].fuel -= players[i].speed;
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
