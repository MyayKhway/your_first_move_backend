import { eq } from "drizzle-orm";
import { cars, dealers } from "../../drizzle/schema";
import db from "../db/connection";

export const fetchDealerFromCar = async (carId: number) => {
  const dealerId = await db.select({ id: cars.dealerId })
    .from(cars)
    .where(eq(cars.id, BigInt(carId)))
  const firstDealerFound = dealerId[0]
  if (dealerId.length < 1 || !firstDealerFound.id) {
    throw new Error(`Database Error: no dealer ID.`)
  }
  const dealer = await db.select().from(dealers)
    .where(eq(dealers.id, firstDealerFound.id))
  return dealer
}
