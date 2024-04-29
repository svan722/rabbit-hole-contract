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
    assert(bot1.speed === "5", "bot 1 spped is not 500");
    assert(bot2.fuel === "50", "bot 2 fuel is not 50");
  });

  it("should play game with the playe have random speed", async () => {
    await rabbitHole.playGame(player, { from: player });
    const players = await rabbitHole.getPlayers();
    assert(players.length === 3, "there is not players with random speed");
  });

  it("should set player speed", async () => {
    await rabbitHole.setPlayerSpeed(9, { from: player });
    const players = await rabbitHole.getPlayers();
    assert(players[2].speed === "9", "player speed no set");
  });

  it("should set player fuel status", async () => {
    await rabbitHole.setPlayerFuel(40, { from: player });
    const players = await rabbitHole.getPlayers();
    assert(players[2].fuel === "40", "player fuel no set");
  });

  it("The player has been reset", async () => {
    await rabbitHole.initPlayers({ from: player });
    const players = await rabbitHole.getPlayers();
    assert(players.length === 2, "player fuel no set");
  });

  
});
