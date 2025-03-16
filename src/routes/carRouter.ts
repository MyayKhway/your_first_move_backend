import express from "express";
import upload from "../middlewares/multer_config";
import { Car, CarData, MulterRequest } from "../types/utils";
import { createCar, deleteCarById, fetchAllCars, fetchAllReviews, fetchCarById, fetchCarsByFuel, fetchCarsByStyle, makeNewReview } from "../services/car_services";


const carRouter = express.Router()

const json = (param: any): any => {
  return JSON.stringify(
    param,
    (key, value) => (typeof value === "bigint" ? value.toString() : value) // return everything else unchanged
  );
};

carRouter.post('/create', upload.fields([
  { name: 'mainImg', maxCount: 1 },
  { name: 'otherImg', maxCount: 7 },
]), async (
  req,
  res) => {
  try {
    const {
      make,
      model,
      year,
      cc,
      torque,
      fuel,
      cityMpg,
      hwMpg,
      seats,
      style,
      features,
      price,
      dealerId
    } = req.body
    const files = req as MulterRequest
    const mainImg = files.files?.["mainImg"]?.[0] as Express.MulterS3.File || null
    const otherImages = files.files?.["otherImg"] as Express.MulterS3.File[] || []
    const otherImg = otherImages.map(img => img.location)
    const newCar: CarData = {
      make,
      model,
      year: parseInt(year),
      cc: parseInt(cc),
      torque: parseInt(torque),
      fuel,
      cityMpg: parseInt(cityMpg),
      hwMpg: parseInt(hwMpg),
      seats: parseInt(seats),
      style,
      features: features.split(','),
      msrp: parseInt(price),
      mainPicUrl: mainImg ? mainImg.location : 'N/A',
      otherImageUrls: otherImg,
      dealerId: parseInt(dealerId)
    }
    const returnedCar = await createCar(newCar)

    res.status(200).json({
      make: returnedCar[0].make,
      model: returnedCar[0].model
    })
  } catch (error) {
    if (error instanceof Error)
      res.status(500).json({ message: error.message })
    else
      res.status(500).json({ message: error })
  }
})

carRouter.get('/all', async (req, res) => {
  try {
    const { id } = req.query
    if (!id || typeof id !== "string") {
      res.status(400).json({ message: 'no search params' })
      return
    }
    const allCars = await fetchAllCars(parseInt(id))
    res.status(200).send(json(allCars))
  } catch (error) {
    res.status(500).json({ message: `${error}` })
  }

})

carRouter.get('/:id', async (req, res) => {
  try {
    const url = req.url.split('/')
    const id = url[url.length - 1]
    const carReturned = await fetchCarById(parseInt(id))
    res.status(200).send(json(carReturned))
  } catch (error) {
    res.status(500).json({ message: `${error}` })
  }
})

carRouter.delete('/:id', async (req, res) => {
  try {
    const url = req.url.split('/')
    const id = url[url.length - 1]
    await deleteCarById(parseInt(id))
    res.status(200).json({ message: 'sucessful' })
  } catch (error) {
    res.status(500).json({ message: `${error}` })
  }
})

carRouter.get('/type/:style', async (req, res) => {
  try {
    const url = req.url.split('/')
    const style = url[url.length - 1]
    let cars: Car[] = []
    if (style === "ev") {
      cars = await fetchCarsByFuel("EV")
    } else if (style == "suv") {
      cars = await fetchCarsByStyle("SUV")
    } else if (style == "truck") {
      cars = await fetchCarsByStyle("Truck")
    } else if (style == "sedan") {
      cars = await fetchCarsByStyle("Sedan")
    } else if (style == "hybrid") {
      cars = await fetchCarsByFuel("Hybrid")
    }
    res.status(200).send(json(cars))
  } catch (err) {
    res.status(500).json({ message: `${err}` })
  }
})

carRouter.get('/reviews/:id', async (req, res) => {
  try {
    const url = req.url.split('/')
    const id = url[url.length - 1]
    const reviews = await fetchAllReviews(parseInt(id))
    res.status(200).json(reviews)
  } catch (err) {
    res.status(500).json({ message: `${err}` })
  }
})

carRouter.post('/reviews', async (req, res) => {
  try {
    const { carId, userId, rating, content } = req.body
    console.log(carId, userId, rating, content)
    const newReview = await makeNewReview(parseInt(carId), parseInt(userId), content, parseInt(rating))
    res.status(200).json(newReview)
  } catch (err) {
    res.status(500).json({ message: `${err}` })
  }
})

export default carRouter
