/* eslint-disable no-console */
import axios from "axios"

const getPlayers = async () => {
  let response
  try {
    response = await axios.get(
      `https://sepolia.etherscan.io/address/0x6B0f5dBb5FF1398902DDEa5D2d13Dd27291AE21e#readContract`,
    )
  } catch (ex) {
    response = { data: false }
  } 
  return response
}

export default async function handler(req: any, res: any) {
  const { data } = await getPlayers()
  res.status(200).json(data)
}
