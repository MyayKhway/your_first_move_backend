import { relations } from "drizzle-orm/relations";
import { carCategories, carsCarCategories, cars } from "./schema";

export const carsCarCategoriesRelations = relations(carsCarCategories, ({one}) => ({
	carCategory: one(carCategories, {
		fields: [carsCarCategories.category],
		references: [carCategories.id]
	}),
	car: one(cars, {
		fields: [carsCarCategories.car],
		references: [cars.id]
	}),
}));

export const carCategoriesRelations = relations(carCategories, ({many}) => ({
	carsCarCategories: many(carsCarCategories),
}));

export const carsRelations = relations(cars, ({many}) => ({
	carsCarCategories: many(carsCarCategories),
}));