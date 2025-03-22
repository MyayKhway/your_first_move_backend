const jwtOpts = {
  secret: process.env.SECRET_KEY || "SeCreEt",
  cookieName: "auth_token",
  options: {
    audience: process.env.NODE_ENV === "production" ? process.env.FRONTEND_URL : 'http://localhost:5173',
    issuer: process.env.NODE_ENV === "production" ? 'your-first-move-44b7e461.nip.io' : 'localhost:3000',
  },
  cookie: {
    httpOnly: true,
    sameSite: (process.env.NODE_ENV === "production" ? "strict" : "lax") as "strict" | "lax",
    signed: false,
    secure: process.env.NODE_ENV === 'production'
  }
}

export default jwtOpts
