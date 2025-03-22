const jwtOpts = {
  secret: process.env.SECRET_KEY || "SeCreEt",
  cookieName: "auth_token",
  options: {
    audience: process.env.NODE_ENV === "production" ? process.env.FRONTEND_URL : 'http://localhost:5173',
    expiresIn: '7d',
    issuer: process.env.NODE_ENV === "production" ? 'your-first-move-44b7e461.nip.io' : 'localhost:3000',
  },
  cookie: {
    httpOnly: true,
    sameSite: true,
    signed: true,
    secure: process.env.NODE_ENV == 'production'
  }
}

export default jwtOpts
