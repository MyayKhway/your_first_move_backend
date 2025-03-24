import express from "express";
import { fetchDealerFromCar } from "../services/dealer_services";


const dealerRouter = express.Router()

const json = (param: any): any => {
  return JSON.stringify(
    param,
    (key, value) => (typeof value === "bigint" ? value.toString() : value) // return everything else unchanged
  );
};

dealerRouter.get('/bycar/:id', async (req, res) => {
  const url = req.url.split('/')
  const carId = url[url.length - 1]
  try {
    const dealer = await fetchDealerFromCar(parseInt(carId))
    res.status(200).json(dealer[0])
  } catch (err) {
    res.status(500).json({ message: `${err}` })
  }
})

export default dealerRouter
