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
});
