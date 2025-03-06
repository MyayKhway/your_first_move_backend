import { defineConfig } from "drizzle-kit";
import dotenv from 'dotenv'
import dotenvExpand from 'dotenv-expand'

const path = process.env.NODE_ENV == 'development' ? '.env.development' : '.env'
const envConfig = dotenv.config({
  path: path
})
dotenvExpand.expand(envConfig)

export default defineConfig({
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DB_URL || "",
  },
  schema: "./drizzle/schema.ts",
  out: "./drizzle",
  migrations: {
    prefix: "timestamp",
    table: "__drizzle_migrations__",
    schema: "public"
  }
});
