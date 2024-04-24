import { behindTheCamp } from "./behindTheCamp"

const getDefaultFeed = async () => {
  const first = {
    name: "only-countdown",
    tokenId: 0,
    description: "",
    image: "",
    animation_url: "",
    content: {
      mime: "video/mp4",
      uri: "",
    },
  }
  const shuffledBehindTheCamp = [...behindTheCamp].sort(() => 0.5 - Math.random())
  shuffledBehindTheCamp.unshift(first)
  return shuffledBehindTheCamp
}

export default getDefaultFeed
