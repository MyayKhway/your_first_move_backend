import { eq } from 'drizzle-orm'
import { cars, carsUsersReviews, users } from '../../drizzle/schema'
import db from '../db/connection'
import { CarData } from '../types/utils'

export const createCar = async (data: CarData) => {
  try {
    const returnedCar = await db.insert(cars).values({
      ...data
    }).returning()
    return returnedCar
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }
}

export const fetchAllCars = async () => {
  try {
    const allCars = await db.select().from(cars)
    return allCars
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }
}

export const fetchAllCarsByDealer = async (id: number) => {
  try {
    const allCars = await db.select().from(cars).where(eq(cars.dealerId, id))
    return allCars
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }
}

export const fetchCarById = async (id: number) => {
  try {
    const carReturned = await db.select().from(cars).where(eq(cars.id, BigInt(id)))
    return carReturned[0]
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }
}

export const deleteCarById = async (id: number) => {
  try {
    await db.delete(cars).where(eq(cars.id, BigInt(id)))
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }
}

export const getReviewsByCarId = async (id: number) => {
  try {
    const reviews = await db.select().from(carsUsersReviews).where(eq(carsUsersReviews.carId, id))
    return reviews
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }

}
export const fetchCarsByStyle = async (style: string) => {
  try {
    const carsReturned = await db.select().from(cars).where(eq(cars.style, style));

    const carWithRatings = await Promise.all(carsReturned.map(async (car) => {
      const reviews = await getReviewsByCarId(Number(car.id));
      let rating = 0;
      if (reviews.length > 0)
        rating = reviews.reduce((prev, next) => prev + next.rating, 0) / reviews.length;
      return {
        ...car,
        rating,
        reviews: reviews.length
      };
    }));

    console.log(carWithRatings); // Now contains the resolved values, not promises
    return carWithRatings;
  } catch (err) {
    throw new Error(`Database error. ${err}`)
  }

}

export const fetchCarsByFuel = async (fuel: string) => {
  try {
    const carsReturned = await db.select().from(cars).where(eq(cars.fuel, fuel))
    return carsReturned
  } catch (err) {
    throw new Error(`Database Error. ${err}`)
  }
}

export const fetchAllReviews = async (carId: number) => {
  try {
    const reviewsReturned = await db.select({
      userName: users.username,
      content: carsUsersReviews.content,
      rating: carsUsersReviews.rating
    }).from(carsUsersReviews)
      .leftJoin(users, eq(users.id, carsUsersReviews.userId))
      .where(eq(carsUsersReviews.carId, carId))
    return reviewsReturned
  } catch (err) {
    throw new Error(`Database Error. ${err}`)
  }
}

export const makeNewReview = async (carId: number, userId: number, content: string, rating: number) => {
  try {
    const newReview = db.insert(carsUsersReviews).values({
      carId,
      userId,
      content,
      rating,
    })
    return newReview
  } catch (err) {
    throw new Error(`Database Error. ${err}`)
  }
}

