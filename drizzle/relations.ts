import { relations } from "drizzle-orm/relations";
import { dealers, cars, carsUsersReviews, users } from "./schema";

export const carsRelations = relations(cars, ({one, many}) => ({
	dealer: one(dealers, {
		fields: [cars.dealerId],
		references: [dealers.id]
	}),
	carsUsersReviews: many(carsUsersReviews),
}));

export const dealersRelations = relations(dealers, ({many}) => ({
	cars: many(cars),
}));

export const carsUsersReviewsRelations = relations(carsUsersReviews, ({one}) => ({
	car: one(cars, {
		fields: [carsUsersReviews.carId],
		references: [cars.id]
	}),
	user: one(users, {
		fields: [carsUsersReviews.userId],
		references: [users.id]
	}),
}));

export const usersRelations = relations(users, ({many}) => ({
	carsUsersReviews: many(carsUsersReviews),
}));