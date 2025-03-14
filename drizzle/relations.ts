import { relations } from "drizzle-orm/relations";
import { cars, carsUsersLikes, users } from "./schema";

export const carsUsersLikesRelations = relations(carsUsersLikes, ({one}) => ({
	car: one(cars, {
		fields: [carsUsersLikes.carId],
		references: [cars.id]
	}),
	user: one(users, {
		fields: [carsUsersLikes.userId],
		references: [users.id]
	}),
}));

export const carsRelations = relations(cars, ({many}) => ({
	carsUsersLikes: many(carsUsersLikes),
}));

export const usersRelations = relations(users, ({many}) => ({
	carsUsersLikes: many(carsUsersLikes),
}));