import { eq } from 'drizzle-orm'
import { cars } from '../../drizzle/schema'
import db from '../db/connection'
import { CarData } from '../types/utils'

export const createCar = async (data: CarData) => {
  try {
    const returnedCar = await db.insert(cars).values({
      ...data
    }).returning()
    return returnedCar
  } catch (err) {
    throw Error(`Database error. ${err}`)
  }
}

export const fetchAllCars = async (id: number) => {
  try {
    const allCars = await db.select().from(cars).where(eq(cars.dealerId, id))
    return allCars
  } catch (err) {
    throw Error(`Database error. ${err}`)
  }
}

export const fetchCarById = async (id: number) => {
  try {
    const carReturned = await db.select().from(cars).where(eq(cars.id, BigInt(id)))
    return carReturned[0]
  } catch (err) {
    throw Error(`Database error. ${err}`)
  }
}

export const deleteCarById = async (id: number) => {
  try {
    await db.delete(cars).where(eq(cars.id, BigInt(id)))
  } catch (err) {
    throw Error(`Database error. ${err}`)
  }
}
