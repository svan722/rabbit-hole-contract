import { createRef, useEffect, useRef } from "react"
import useIsMobile from "@/hooks/useIsMobile"

interface Player {
  id: string
  PlayerPosition: number
  src: string
}

interface PlayerMovementProps {
  phase: string
  players: Player[]
}

const PlayerMovement: React.FC<PlayerMovementProps> = ({ phase, players }) => {
  const sortedPlayers = [...players].sort((a, b) => a.PlayerPosition - b.PlayerPosition)
  const playerRefs = useRef<React.RefObject<HTMLImageElement>[]>(
    sortedPlayers.map(() => createRef<HTMLImageElement>()),
  )

  useEffect(() => {
    sortedPlayers.forEach((player, index) => {
      const topPixel = useIsMobile ? 12 : 20
      const positionStyle = `${topPixel * player.PlayerPosition}px`

      const playerElement = playerRefs.current[index].current
      if (!playerElement) return

      if (phase === "Default" || phase === "Reset") {
        setTimeout(() => {
          playerElement.style.transition = "all 1.5s ease-out"
          playerElement.style.left = "50%"
          playerElement.style.visibility = "visible"
          playerElement.style.top = positionStyle
        }, index * 300)
      } else if (phase === "CloseTunnel") {
        playerElement.style.left = "80%"
        setTimeout(() => {
          playerElement.style.transition = "all 0.5s ease-out"
          playerElement.style.left = "-100%"
        }, 3000)
      } else if (phase === "OpenTunnel") {
        const delay = index * 1000
        setTimeout(() => {
          playerElement.style.top = positionStyle
          playerElement.style.left = "150vw"
          playerElement.style.transition = "all 12s ease-out"
        }, 1000 + delay)

        setTimeout(() => {
          playerElement.style.visibility = "hidden"
          playerElement.style.left = "-10vw"
          playerElement.style.transition = "none"
        }, 9000 + delay)
      }
    })
  }, [phase, sortedPlayers])

  return (
    <div className="player-container">
      {sortedPlayers.map((player, index) => (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          key={player.id}
          ref={playerRefs.current[index]}
          src={player.src}
          alt={player.id}
          className={`player-${player.id}`}
        />
      ))}
    </div>
  )
}

export default PlayerMovement
