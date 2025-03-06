const jwtOpts = {
  secret: process.env.SECRET_KEY || "SeCreEt",
  cookieName: "auth_token",
  options: {
    audience: 'http://localhost:5173',
    expiresIn: '7d',
    issuer: 'localhost:3000',
  },
  cookie: {
    httpOnly: true,
    sameSite: true,
    signed: true,
    secure: process.env.NODE_ENV == 'production'
  }
}

export default jwtOpts
