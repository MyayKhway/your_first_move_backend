import { cars, dealers, users } from '../../drizzle/schema'
import { Request } from 'express'

export type User = typeof users.$inferSelect
export type Dealer = typeof dealers.$inferSelect
export type Car = typeof cars.$inferSelect

export type UserData = typeof users.$inferInsert
export type DealerData = typeof dealers.$inferInsert
export type CarData = typeof cars.$inferInsert

export interface MulterRequest extends Request {
  files: {
    mainImg?: Express.Multer.File[];
    otherImg?: Express.Multer.File[];
  };
}

