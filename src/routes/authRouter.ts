import express from "express";
import {
  signup,
  login,
  logout,
  verifyEmail,
} from '../services/auth_services'

const authRouter = express.Router()

authRouter.post('/signup', signup)
authRouter.post('/signin', login)
authRouter.post('/logout', logout)
authRouter.post('/verify-email', verifyEmail)

export default authRouter
