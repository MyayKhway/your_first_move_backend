import { S3Client, DeleteObjectCommand } from '@aws-sdk/client-s3'
import { config } from 'dotenv'

let envFile
envFile = process.env.NODE_ENV == "development" ? ".env.development" : ".env"
config({ path: envFile })

export const s3 = new S3Client({
  region: 'ap-southeast-1',
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || "",
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || "",
  }
})

export const deleteObject = async (url: string) => {
  const buckName = process.env.S3BUCKET!
  try {
    const parsedUrl = new URL(url)
    const objKey = decodeURIComponent(parsedUrl.pathname.slice(1))
    const params = {
      Bucket: buckName,
      Key: objKey
    }

    const command = new DeleteObjectCommand(params)
    const response = await s3.send(command)

    console.log(`Deleted Object ${objKey} from ${buckName}`)
    return response
  } catch (error) {
    if (error instanceof Error)
      console.error(`Error deleting Object ${error.message}`)
    else
      console.error(`Unknown error has occurred. ${error}`)
  }
}
