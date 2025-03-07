
import { Request, Response, NextFunction } from 'express'
import type { Express } from 'express';
import { users, dealers, User, Dealer } from '../../drizzle/schema'
import { randomBytes } from 'crypto';
import { createTransport } from 'nodemailer';
import db from '../db/connection';
import { eq, or } from 'drizzle-orm';
import { hash, verify } from 'argon2';
import { sign } from 'jsonwebtoken'
import jwtOpts from '../../passport.config'
import passport from 'passport';
import { Strategy as JwtCookieComboStrategy } from 'passport-jwt-cookiecombo'

export interface RequestWithUser extends Request {
  user?: User | Dealer;
  userType?: 'user' | 'dealer';
}

const generateVerificationToken = () => {
  return randomBytes(32).toString('hex');
}

const transporter = createTransport({
  host: process.env.EMAIL_HOST,
  port: parseInt(process.env.EMAIL_PORT || '587'),
  secure: process.env.EMAIL_SECURE == 'true',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  }
})

export const signup = async (req: Request, res: Response) => {
  try {
    const { username, email, password } = req.body;
    const existingUser: User[] = await db.select().from(users).where(or(eq(users.email, email), eq(users.username, username)))
    if (existingUser.length > 0) {
      res.status(400).json({ message: 'User already exists.' })
      return
    }
    const hashedPwd = await hash(password)
    const verificationToken = generateVerificationToken();

    const newUser: User[] = await db.insert(users).values({
      username,
      email,
      password: hashedPwd,
      verificationToken,
      verified: false,
      updatedAt: (new Date()).toISOString(),
    }).returning()

    const token = sign({
      id: newUser[0].id,
      email: newUser[0].email,
      type: 'user'
    }, jwtOpts.secret)

    const verificationLink = `${process.env.FRONTEND_URL}/verify-email?token=${verificationToken}`
    await transporter.sendMail({
      to: email,
      subject: 'Verify your account',
      html: `<a href="${verificationLink}">Verify</a>`
    })

    res.cookie(jwtOpts.cookieName, token, {
      ...jwtOpts.cookie,
      maxAge: 7 * 24 * 60 * 60 * 1000
    })

    res.status(201).json({
      message: 'User created. Verification email sent.',
      user: {
        id: newUser[0].id,
        username: newUser[0].username,
        email: newUser[0].email,
        verified: newUser[0].verified,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      res.status(400).json({ message: `Error: ${error.message}` })
    } else {
      res.status(400).json({ message: `Error: ${error}` })
    }
  }
}

export const dealerSignup = async (req: Request, res: Response) => {
  try {
    const { name, email, password, location } = req.body;
    const existingDealer: Dealer[] = await db.select().from(dealers).where(or(eq(dealers.email, email), eq(dealers.name, name)))
    if (existingDealer.length > 0) {
      res.status(400).json({ message: 'User already exists.' })
      return
    }
    const hashedPwd = await hash(password)
    const verificationToken = generateVerificationToken();

    const newUser: Dealer[] = await db.insert(dealers).values({
      name,
      email,
      password: hashedPwd,
      verificationToken,
      verified: false,
      updatedAt: (new Date()).toString(),
      location
    }).returning()

    const token = sign({
      id: newUser[0].id,
      email: newUser[0].email,
      type: 'user'
    }, jwtOpts.secret)

    const verificationLink = `${process.env.FRONTEND_URL}/verify-email?token=${verificationToken}`
    await transporter.sendMail({
      to: email,
      subject: 'Verify your dealer account',
      html: `<a href="${verificationLink}">Verify</a>`
    })

    res.cookie(jwtOpts.cookieName, token, {
      ...jwtOpts.cookie,
      maxAge: 7 * 24 * 60 * 60 * 1000
    })

    res.status(201).json({
      message: 'User created. Verification email sent.',
      user: {
        id: newUser[0].id,
        username: newUser[0].name,
        email: newUser[0].email,
        verified: newUser[0].verified,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      res.status(400).json({ message: `Error: ${error.message}` })
    } else {
      res.status(400).json({ message: `Error: ${error}` })
    }
  }
}

export const verifyEmail = async (req: Request, res: Response) => {
  try {
    const { token, type } = req.query;

    if (!token) {
      res.status(400).json({ message: 'Verification token is required' })
      return
    }

    if (!type || (type !== 'user' && type !== 'dealer')) {
      res.status(400).json({ message: 'Invalid account type' })
    }

    let userFound: User[] = []
    let dealerFound: Dealer[] = []
    if (type == 'user') {
      userFound = await db.select().from(users).where(eq(users.verificationToken, token as string))
      if (userFound.length > 0) {
        await db.update(users)
          .set({ verified: true, verificationToken: null, updatedAt: (new Date().toString()) })
          .where(eq(users.id, userFound[0].id))
      }
    } else {
      dealerFound = await db.select().from(dealers).where(eq(dealers.verificationToken, token as string))
      if (dealerFound.length > 0) {
        await db.update(dealers)
          .set({ verified: true, verificationToken: null, updatedAt: (new Date().toString()) })
          .where(eq(dealers.id, dealerFound[0].id))
      }
    }

    if (!userFound || userFound.length == 0) {
      res.status(404).json({ message: 'Invalid verification token.' })
      return;
    }
    if (!dealerFound || dealerFound.length == 0) {
      res.status(404).json({ message: 'Invalid verification token.' })
      return;
    }
    res.status(200).json({ message: 'Email verified successfully.' })
  } catch (error) {
    console.error('Email Verification Error: ', error)
    res.status(500).json({ message: 'Error verifying email.' })
  }
}

export const login = async (req: Request, res: Response) => {
  try {
    const { username, email, password, type } = req.body;
    console.log(req.body)
    if (!type || (type !== 'user' && type !== 'dealer')) {
      res.status(401).json({ message: 'Account type is required' })
      return
    }

    let userFound: User[] = [];
    let dealerFound: Dealer[] = [];
    if (type === 'user') {
      userFound = await db.select().from(users).where(or(eq(users.email, email), eq(users.username, username)))
    } else {
      dealerFound = await db.select().from(dealers).where(or(eq(dealers.email, email), eq(dealers.name, username)))
    }

    if ((!userFound || userFound.length === 0) && (!dealerFound || dealerFound.length === 0)) {
      res.status(401).json({ message: 'Invalid credentials.' })
      return;
    }

    let isValidPassword: boolean;
    if (type === 'user') {
      isValidPassword = await verify(userFound[0].password, password)
    } else {
      isValidPassword = await verify(dealerFound[0].password, password)
    }

    if (!isValidPassword) {
      res.status(401).json({ message: 'Invalid credentials.' })
    }

    const token: string = sign(
      {
        id: userFound.length > 0 ? userFound[0].id : dealerFound[0].id,
        email: userFound.length > 0 ? userFound[0].email : dealerFound[0].email,
        type
      }, jwtOpts.secret, {
      expiresIn: '7d'
    }
    )

    res.cookie(jwtOpts.cookieName, token, jwtOpts.cookie)

    if (type === 'user') {
      res.status(200).json({
        message: 'Login successful',
        user: {
          id: userFound[0].id,
          username: (userFound[0] as User).username,
          email: userFound[0].email,
          verified: userFound[0].verified,
        },
      });
    } else {
      res.status(200).json({
        message: 'Login successful',
        dealer: {
          id: dealerFound[0].id,
          name: (dealerFound[0] as Dealer).name,
          email: dealerFound[0].email,
          verified: dealerFound[0].verified,
        },
      });
    }
  } catch (error) {
    console.error('Login Error: ', error)
    res.status(500).json({ message: 'Error logging in.' })
  }
}

export const logout = (req: Request, res: Response): void => {
  res.clearCookie(jwtOpts.cookieName);
  res.status(200).json({ message: 'Logged out successfully' });
};

export const setupPassport = (app: Express): void => {
  app.use(passport.initialize());

  // JWT Strategy
  passport.use(
    new JwtCookieComboStrategy(
      {
        secretOrPublicKey: jwtOpts.secret,
        jwtCookieName: jwtOpts.cookieName,
        passReqToCallback: true,
      },
      async (req: RequestWithUser, payload, done) => {
        try {
          let user;
          if (payload.type === 'user') {
            const result = await db.select().from(users).where(eq(users.id, payload.id));
            user = result.length > 0 ? result[0] : null;
          } else {
            const result = await db.select().from(dealers).where(eq(dealers.id, payload.id));
            user = result.length > 0 ? result[0] : null;
          }

          if (!user) {
            return done(null, false);
          }

          // Store user type in the request for later use
          if (req) {
            req.userType = payload.type as 'user' | 'dealer';
          }

          return done(null, user);
        } catch (error) {
          return done(error, false);
        }
      }
    )
  );
};

export const requireAuth = passport.authenticate('jwt', { session: false });

// Optional verification check middleware
export const checkVerified = (req: RequestWithUser, res: Response, next: NextFunction): void => {
  const user = req.user;

  if (!user || !user.verified) {
    res.status(403).json({
      message: 'Email not verified',
      verified: false
    });
    return;
  }

  next();
};

// Middleware to restrict access to users only
export const userOnly = (req: RequestWithUser, res: Response, next: NextFunction): void => {
  if (req.userType !== 'user') {
    res.status(403).json({ message: 'Access denied. User access only.' });
    return;
  }
  next();
};

// Middleware to restrict access to dealers only
export const dealerOnly = (req: RequestWithUser, res: Response, next: NextFunction): void => {
  if (req.userType !== 'dealer') {
    res.status(403).json({ message: 'Access denied. Dealer access only.' });
    return;
  }
  next();
};
