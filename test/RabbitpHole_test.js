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
    assert(bot1.speed === "500", "bot 1 spped is not 500");
    assert(bot2.fuel === "50", "bot 2 fuel is not 50");
  });

  it("should add a new player", async () => {
    await rabbitHole.addPlayer({ from: deployers[3] });
    const players = await rabbitHole.getPlayers();
    expect(players.length).to.equal(3); // Since two bots are already added in the constructor
    expect(players[2].player).to.equal(deployers[3]);
  });

  it("should set player speed", async () => {
    await rabbitHole.setPlayerSpeed(900, { from: deployers[3] });
    const players = await rabbitHole.getPlayers();
    assert(players[2].speed === "900", "player speed no set");
  });

  it("should set player fuel status", async () => {
    await rabbitHole.setPlayerFuel(100, { from: deployers[3] });
    const players = await rabbitHole.getPlayers();
    assert(players[2].fuel === "100", "player fuel no set");
  });

  it("update player alive status", async () => {
    await rabbitHole.setPlayerFuel(0, { from: deployers[3] });
    const players = await rabbitHole.getPlayers();
    assert(players[2].fuel === "0", "dead player");
  });

  it("should set player fuel status", async () => {
    await rabbitHole.addPlayer({ from: deployers[5] });
    await rabbitHole.setPlayerSpeed(3, { from: deployers[5] });
    await rabbitHole.setPlayerFuel(100, { from: deployers[5] });
    const players = await rabbitHole.getPlayers();
    assert(
      players[3].alive === false,
      "Newly added player should be dead due to fuel being zero"
    );
  });

  it("should set player alive status", async () => {
    await rabbitHole.setPlayerAlive(true, { from: deployers[5] });
    const players = await rabbitHole.getPlayers();
    expect(players[3].alive === "true", "Newly added player should be alive");
  });
});
