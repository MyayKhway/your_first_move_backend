-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"username" text NOT NULL,
	"email" text NOT NULL,
	"password" text NOT NULL,
	"created_at" date DEFAULT CURRENT_TIMESTAMP,
	"updated_at" date
);
--> statement-breakpoint
CREATE TABLE "car_categories" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"name" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "cars" (
	"id" bigserial PRIMARY KEY NOT NULL,
	"make" text NOT NULL,
	"model" text NOT NULL,
	"year" integer NOT NULL,
	"fuel" text NOT NULL,
	"hp" integer NOT NULL,
	"cylinders" integer NOT NULL,
	"transmission" integer NOT NULL,
	"wheel_drive" text NOT NULL,
	"doors" smallint NOT NULL,
	"size" text NOT NULL,
	"style" text NOT NULL,
	"hw_mpg" integer NOT NULL,
	"city_mpg" integer NOT NULL,
	"msrp" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "cars_car_categories" (
	"car" integer NOT NULL,
	"category" integer NOT NULL,
	CONSTRAINT "cars_car_categories-pk" PRIMARY KEY("car","category")
);
--> statement-breakpoint
ALTER TABLE "cars_car_categories" ADD CONSTRAINT "car_categories_cars_car_categories_fk" FOREIGN KEY ("category") REFERENCES "public"."car_categories"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cars_car_categories" ADD CONSTRAINT "cars_car_categories_cars_fk" FOREIGN KEY ("car") REFERENCES "public"."cars"("id") ON DELETE no action ON UPDATE no action;
*/