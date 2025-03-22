import type { Request, Response, NextFunction } from "express";
import { JwtPayload, verify } from "jsonwebtoken";
import jwtOpts from "../../passport.config";

export const isAuthorizedUser = async (req: Request, res: Response, next: NextFunction) => {
  const { auth_token } = req.cookies
  if (!auth_token) {
    res.status(401).json({ message: "Not Authorized" })
    return
  }
  const { type } = verify(auth_token, jwtOpts.secret) as JwtPayload
  if (type !== "user") {
    res.status(404).json({ message: "Not Authorized" })
    return
  }
  next()
}

export const isAuthorizedDealer = async (req: Request, res: Response, next: NextFunction) => {
  const { auth_token } = req.cookies
  if (!auth_token) {
    res.status(404).json({ message: "Not Authorized" })
    return
  }
  const { type } = verify(auth_token, jwtOpts.secret) as JwtPayload
  if (type !== "dealer") {
    res.status(404).json({ message: "Not Authorized" })
    return
  }
  next()
}

export const isAuthorized = async (req: Request, res: Response, next: NextFunction) => {
  const { auth_token } = req.cookies
  if (!auth_token) {
    res.status(401).json({ message: "Not Authorized" })
    return
  }
  const { type } = verify(auth_token, jwtOpts.secret) as JwtPayload
  if (type !== "user" && type !== "dealer") {
    res.status(404).json({ message: "Not Authorized" })
    return
  }
  next()
}
