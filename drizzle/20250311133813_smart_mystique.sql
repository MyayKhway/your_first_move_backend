CREATE TABLE "dealers" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"password" text NOT NULL,
	"contactNumber" text NOT NULL,
	"verificationToken" varchar(64),
	"resetToken" varchar(64),
	"verified" boolean DEFAULT false NOT NULL,
	"created_at" date DEFAULT CURRENT_TIMESTAMP,
	"updated_at" date,
	"location" "point" NOT NULL,
	"address" varchar
);
--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "verificationToken" varchar(64);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "resetToken" varchar(64);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_username_unique" UNIQUE("username");--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_email_unique" UNIQUE("email");