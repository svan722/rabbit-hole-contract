import { useState } from "react"
import Lever from "./Lever"
import GasolineGauge from "./GasolineGange"
import { RabbitHead } from "./RabbitHead"
import { Darkness } from "./Darkness"
import PlayerMovement from "./PlayerMovement"
import { RabbitTail } from "./RabbitTail"
import StatusTable from "./StatusTable"

function TunnelChange(setPhase) {
  setPhase("CloseTunnel") // Close tunnel: Head moves to swallow everything. Open tunnel: cars get out
  setTimeout(() => setPhase("OpenTunnel"), 5000)
  setTimeout(() => setPhase("Reset"), 16000)
}

const Total = () => {
  const [phase, setPhase] = useState("Default")
  const [players] = useState([
    { id: "player1", src: "https://i.ibb.co/SN7JyMF/sheeepy.png", PlayerPosition: 2, Fuel: 80 },
    { id: "player2", src: "https://i.ibb.co/vXGDsDD/blacksheep.png", PlayerPosition: 1, Fuel: 30 },
    { id: "player3", src: "https://i.ibb.co/SN7JyMF/sheeepy.png", PlayerPosition: 3, Fuel: 20 },
  ])

  // Function to update player positions, if needed
  // const updatePlayerPosition = (id, newPosition) => {
  //   setPlayers((currentPlayers) =>
  //     currentPlayers.map((player) =>
  //       player.id === id ? { ...player, PlayerPosition: newPosition } : player,
  //     ),
  //   )
  // }

  return (
    <>
      {/* <FuelBar players={players} /> */}
      <StatusTable />
      <div className="tunnel relative !w-full mt-[10vh] samsungS8:mt-[20vh] md:mt-[60px]">
        <PlayerMovement phase={phase} players={players} />
        <Darkness phase={phase} />
        <RabbitHead phase={phase} />
        <RabbitTail phase={phase} />
      </div>
      {/* <button id="StartTunnel" }>
        Change Tunnel - Temp
      </button> */}

      <div className="control-panels mt-[15vh] md:mt-[60px]">
        <Lever />
        <GasolineGauge />
      </div>
      <div className="w-full flex justify-center items-center gap-[10px] mt-[10px]">
        <button
          type="button"
          className="shadow-md bg-white_3 text-white_4 border-white_border bg-green 
        p-[4px_15px] rounded-[5px]
        !border-0 !outline-0 !ring-0
        transition duration-[300ms] hover:scale-[1.1]"
          onClick={() => TunnelChange(setPhase)}
        >
          Start
        </button>
        <button
          type="button"
          className="shadow-md bg-green
       p-[4px_15px] rounded-[5px] text-white
       !border-0 !outline-0 !ring-0
       transition duration-[300ms] hover:scale-[1.05]"
        >
          Set Speed
        </button>
      </div>
      <div />
    </>
  )
}

export default Total
