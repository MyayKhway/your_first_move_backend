import express from "express";
import { askDescription } from "../services/openai_services";


const openaiRouter = express.Router()

openaiRouter.get('/desc/:carId', async (req, res) => {
  try {
    const url = req.url.split('/')
    const carId = url[url.length - 1]
    const description = await askDescription(parseInt(carId))
    res.status(200).json(description)
  } catch (err) {
    res.status(500).json({ message: `Error asking first-move AI ${err}` })
  }

})

export default openaiRouter
