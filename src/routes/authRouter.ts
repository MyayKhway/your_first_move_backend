import express from "express";
import {
  signup,
  login,
  logout,
  verifyEmail,
  reqResetPass,
  resetPwd,
  resetPwdDealer,
  dealerSignup,
  reqResetPassDealer,
} from '../services/auth_services'

const authRouter = express.Router()

authRouter.post('/signup', signup)
authRouter.post('/dealer/signup', dealerSignup)
authRouter.post('/signin', login)
authRouter.post('/logout', logout)
authRouter.post('/verify-email', verifyEmail)
authRouter.post('/req-reset-pass', reqResetPass)
authRouter.post('/req-reset-pass-dealer', reqResetPassDealer)
authRouter.post('/reset-pass-user', resetPwd)
authRouter.post('/reset-pass-dealer', resetPwdDealer)

export default authRouter
