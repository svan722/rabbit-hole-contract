//test/RabbitpHole.test.js
const RabbitHole = artifacts.require("RabbitHole");
const { assert } = require("chai");

require("chai").use(require("chai-as-promised")).should();

contract("RabbitHole Contract", async (deployers) => {
  let rabbitHole;
  const player = deployers[0];

  beforeEach(async () => {
    rabbitHole = await RabbitHole.deployed();
  });

  it("2 players should be bot", async () => {
    const players = await rabbitHole.getPlayers();
    const bot1 = players[0];
    const bot2 = players[1];
    assert(bot1.speed === "5", "bot 1 spped is not 5");
    assert(bot2.fuel === "50", "bot 2 fuel is not 50");
  });

  it("should play game with the playe have parm speed", async () => {
    await rabbitHole.playGame(8, player, { from: player });
    await rabbitHole.playGame(9, player, { from: player });

    const players = await rabbitHole.getPlayers();
    assert(players[2].speed === 9, "there is not players with parm speed");
  });

  it("The player has been reset", async () => {
    await rabbitHole.initPlayers({ from: player });
    const players = await rabbitHole.getPlayers();
    assert(players.length === 2, "player fuel no set");
  });

});
