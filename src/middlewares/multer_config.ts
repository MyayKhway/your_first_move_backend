const multerS3 = require('multer-s3')
import multer, { FileFilterCallback, StorageEngine } from 'multer'
import { Request, } from 'express'
import { s3, } from '../s3'
import { ParamsDictionary } from 'express-serve-static-core'
import { ParsedQs } from 'qs'

// Configure Multer for file uploads with typed parameters for req and file
let storage: StorageEngine;
storage = multerS3({
  s3: s3,
  bucket: process.env.S3BUCKET,
  metadata: (req: Request,
    file: Express.Multer.File,
    cb: (error: Error | null, metadata: any) => void) => {
    cb(null, { fieldName: file.fieldname })
  },
  key: (req: Request,
    file: Express.Multer.File,
    cb: (error: Error | null, fileName: string) => void) => {
    const { make, model } = req.body
    let fileName = `${model}-${make}-${Date.now()}`
    if (file.fieldname == "mainImg") {
      fileName = fileName.concat(`main-image-${file.originalname}`)
    } else if (file.fieldname == "otherImg") {
      fileName = fileName.concat(`other-${file.originalname}`)
    }
    cb(null, fileName);
  },
  acl: 'public-read',
})

const upload = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 }, // 100MB limit per file
  fileFilter: (req: Request<ParamsDictionary, any, any, ParsedQs, Record<string, any>>, file: Express.Multer.File, cb: FileFilterCallback) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'));
    }
  },
});

export default upload
