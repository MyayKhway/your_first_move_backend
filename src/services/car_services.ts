import { and, between, desc, eq, getTableColumns, gt, ilike, inArray, lt, sql } from 'drizzle-orm'
import { cars, cars, carsUsersReviews, users } from '../../drizzle/schema'
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

export const fetchAllCarsWithReviews = async () => {
  try {
    const carsReturned = await db.select().from(cars);

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

    return carWithRatings;
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
    const newReview = await db.insert(carsUsersReviews).values({
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

export const fetchCarBrands = async () => {
  try {
    const brands = await db.selectDistinct({ brands: cars.make }).from(cars)
    console.log(brands)
    return brands
  } catch (err) {
    throw new Error(`Database Error. ${err}`)
  }
}

export const fetchCarbySpec = async ({ seats, fuel, style, cc, min_mpg, msrp }:
  {
    seats: number,
    fuel: string,
    style: string,
    cc: number,
    min_mpg: number,
    msrp: number
  }) => {
  console.log(seats, fuel, style, cc, min_mpg, msrp)
  const carsByStyleAndFuel = await db.select().from(cars).where(
    and(
      ilike(cars.style, style),
      ilike(cars.fuel, fuel)
    )
  )
  // const fetchedCars = await db.select().from(cars).where(
  //   and(
  //     between(cars.seats, seats - 1, seats + 1),
  //     ilike(cars.fuel, `${fuel}`),
  //     ilike(cars.style, `${style}`),
  //     between(cars.cc, cc - 500, cc + 500),
  //     gt(cars.hwMpg, min_mpg - 5),
  //     lt(cars.msrp, msrp + 50000)
  //   )
  // )
  // if (!fetchedCars) {
  //   const fetchedCarsNew = await db.select().from(cars).where(
  //     and(
  //       ilike(cars.style, `${style}`),
  //       between(cars.cc, cc - 500, cc + 500),
  //       gt(cars.hwMpg, min_mpg - 5),
  //     )
  //   )
  //   return fetchedCarsNew
  // }
  // const carsReturned = await db.select().from(cars).limit(10)
  const carWithRatings = await Promise.all(carsByStyleAndFuel.map(async (car) => {
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
  return carWithRatings
}

export const fetchBestReviewedCars = async () => {
  // get four best revied cars
  try {
    const carIds = await db.select(
      {
        carId: carsUsersReviews.carId,
        avgRating: sql`avg(${carsUsersReviews.rating})`
      }
    )
      .from(carsUsersReviews)
      .groupBy(carsUsersReviews.carId)
      .orderBy(({ avgRating }) => avgRating)
      .limit(4)
    if (!carIds) {
      return null
    }
    const carsIdonly = carIds.map(car => car.carId)
    const carsResuls = await db.select().from(cars).where(inArray(cars.id, carsIdonly.map(id => BigInt(id))))
    return carsResuls
  } catch (err) {
    throw new Error(`Database Error. ${err}`)
  }
}
