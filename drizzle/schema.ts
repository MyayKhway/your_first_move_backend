import {
  pgTable,
  serial,
  text,
  date,
  smallserial,
  bigserial,
  integer,
  smallint,
  foreignKey,
  primaryKey,
  point,
  varchar,
  boolean
} from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"


export const users = pgTable("users", {
  id: serial().primaryKey().notNull(),
  username: text().notNull().unique(),
  email: text().notNull().unique(),
  password: text().notNull(),
  verificationToken: varchar({ length: 64 }),
  verified: boolean().default(false).notNull(),
  createdAt: date("created_at").default(sql`CURRENT_TIMESTAMP`),
  updatedAt: date("updated_at"),
});

export const dealers = pgTable("dealers", {
  id: serial().primaryKey().notNull(),
  name: text().notNull(),
  email: text().notNull(),
  password: text().notNull(),
  verificationToken: varchar({ length: 64 }),
  verified: boolean().default(false).notNull(),
  createdAt: date("created_at").default(sql`CURRENT_TIMESTAMP`),
  updatedAt: date("updated_at"),
  location: point('location', { mode: 'xy' }).notNull()
})

export const carCategories = pgTable("car_categories", {
  id: smallserial().primaryKey().notNull(),
  name: text().notNull(),
});

export const cars = pgTable("cars", {
  id: bigserial({ mode: "bigint" }).primaryKey().notNull(),
  make: text().notNull(),
  model: text().notNull(),
  year: integer().notNull(),
  fuel: text().notNull(),
  hp: integer().notNull(),
  cylinders: integer().notNull(),
  transmission: integer().notNull(),
  wheelDrive: text("wheel_drive").notNull(),
  doors: smallint().notNull(),
  size: text().notNull(),
  style: text().notNull(),
  hwMpg: integer("hw_mpg").notNull(),
  cityMpg: integer("city_mpg").notNull(),
  msrp: integer().notNull(),
});

export const carsCarCategories = pgTable("cars_car_categories", {
  car: integer().notNull(),
  category: integer().notNull(),
}, (table) => [
  foreignKey({
    columns: [table.category],
    foreignColumns: [carCategories.id],
    name: "car_categories_cars_car_categories_fk"
  }),
  foreignKey({
    columns: [table.car],
    foreignColumns: [cars.id],
    name: "cars_car_categories_cars_fk"
  }),
  primaryKey({ columns: [table.car, table.category], name: "cars_car_categories-pk" }),
]);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
export type Dealer = typeof dealers.$inferSelect;
export type NewDealer = typeof dealers.$inferInsert;
