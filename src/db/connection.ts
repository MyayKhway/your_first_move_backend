import dotenv from 'dotenv'
import { drizzle } from 'drizzle-orm/node-postgres'
import dotenvExpand from 'dotenv-expand'

const path = process.env.NODE_ENV == 'development' ? '.env.development' : '.env'
const envConfig = dotenv.config({
  path: path
})
dotenvExpand.expand(envConfig)
console.log(envConfig)
const db = drizzle(process.env.DB_URL || "")

export default db
