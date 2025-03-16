import { pgTable, unique, serial, text, date, varchar, boolean, foreignKey, bigserial, integer, smallint, point, primaryKey } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"



export const users = pgTable("users", {
	id: serial().primaryKey().notNull(),
	username: text().notNull(),
	email: text().notNull(),
	password: text().notNull(),
	createdAt: date("created_at").default(sql`CURRENT_TIMESTAMP`),
	updatedAt: date("updated_at"),
	verificationToken: varchar({ length: 64 }),
	verified: boolean().default(false).notNull(),
	resetToken: varchar({ length: 64 }),
}, (table) => [
	unique("users_username_unique").on(table.username),
	unique("users_email_unique").on(table.email),
]);

export const cars = pgTable("cars", {
	id: bigserial({ mode: "bigint" }).primaryKey().notNull(),
	make: text().notNull(),
	model: text().notNull(),
	fuel: text().notNull(),
	style: text().notNull(),
	hwMpg: integer("hw_mpg"),
	cityMpg: integer("city_mpg"),
	msrp: integer().notNull(),
	cc: integer(),
	torque: integer(),
	seats: smallint().notNull(),
	mainPicUrl: text("main_pic_url").notNull(),
	otherImageUrls: text("other_image_urls").array(),
	year: integer(),
	features: text().array(),
	dealerId: integer("dealer_id"),
}, (table) => [
	foreignKey({
			columns: [table.dealerId],
			foreignColumns: [dealers.id],
			name: "cars_dealers_fk"
		}),
]);

export const dealers = pgTable("dealers", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	email: text().notNull(),
	password: text().notNull(),
	createdAt: date("created_at").default(sql`CURRENT_TIMESTAMP`),
	updatedAt: date("updated_at"),
	location: point().notNull(),
	verificationToken: varchar({ length: 64 }),
	verified: boolean().default(false).notNull(),
	resetToken: varchar({ length: 64 }),
	address: varchar(),
	contactNumber: text().notNull(),
	website: text(),
});

export const carsUsersReviews = pgTable("cars_users_reviews", {
	carId: integer("car_id").notNull(),
	userId: integer("user_id").notNull(),
	content: text().notNull(),
	rating: integer().notNull(),
	date: date().default(sql`CURRENT_DATE`).notNull(),
}, (table) => [
	foreignKey({
			columns: [table.carId],
			foreignColumns: [cars.id],
			name: "fk_cars_cars_users"
		}),
	foreignKey({
			columns: [table.userId],
			foreignColumns: [users.id],
			name: "fk_users_cars_users"
		}),
	primaryKey({ columns: [table.carId, table.userId], name: "cars_users_like_pk"}),
]);
