import { Request, Response, NextFunction } from 'express'
import type { Express } from 'express';
import { users, dealers } from '../../drizzle/schema'
import { User, Dealer } from '../types/utils';
import { randomBytes } from 'crypto';
import db from '../db/connection';
import { eq, or } from 'drizzle-orm';
import { hash, verify } from 'argon2';
import { sign } from 'jsonwebtoken'
import jwtOpts from '../../passport.config'
import passport from 'passport';
import { Strategy as JwtCookieComboStrategy } from 'passport-jwt-cookiecombo'
import { sendEmail } from './email_services';

export interface RequestWithUser extends Request {
  user?: User | Dealer;
  userType?: 'user' | 'dealer';
}

const generateVerificationToken = () => {
  return randomBytes(32).toString('hex');
}

const generatePassRstToken = () => {
  return randomBytes(32).toString('hex');
}

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
    await sendEmail(email, 'Verify your account', `<a href="${verificationLink}">Verify</a>`)

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
    const { name, email, password, contactNumber, location } = req.body;
    const existingMail: Dealer[] = await db.select().from(dealers).where(eq(dealers.email, email))
    const existingName: Dealer[] = await db.select().from(dealers).where(eq(dealers.name, name))
    const existing = [...existingMail, ...existingName]
    console.log(existing.length)
    if (existing.length > 0) {
      res.status(400).json({ message: 'User already exists.' })
      return
    }
    const hashedPwd = await hash(password)
    const verificationToken = generateVerificationToken();

    const newDealer: Dealer[] = await db.insert(dealers).values({
      name,
      email,
      password: hashedPwd,
      verificationToken,
      contactNumber,
      verified: false,
      updatedAt: (new Date()).toISOString(),
      address: location.address,
      location: [location.lat, location.lng]
    }).returning()

    const token = sign({
      id: newDealer[0].id,
      email: newDealer[0].email,
      type: 'dealer'
    }, jwtOpts.secret)

    const verificationLink = `${process.env.FRONTEND_URL}/verify-email?token=${verificationToken}`
    await sendEmail(email, 'Verify your account', `<a href="${verificationLink}">Verify</a>`)

    res.cookie(jwtOpts.cookieName, token, {
      ...jwtOpts.cookie,
      maxAge: 7 * 24 * 60 * 60 * 1000
    })

    res.status(201).json({
      message: 'User created. Verification email sent.',
      dealer: {
        id: newDealer[0].id,
        name: newDealer[0].name,
        email: newDealer[0].email,
        verified: newDealer[0].verified,
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
    } else {
      dealerFound = await db.select().from(dealers).where(eq(dealers.verificationToken, token as string))
    }

    if ((!userFound || userFound.length == 0) && (!dealerFound || dealerFound.length == 0)) {
      res.status(404).json({ message: 'Invalid verification token.' })
      return;
    }
    if (userFound.length > 0) {
      await db.update(users)
        .set({ verified: true, verificationToken: null, updatedAt: (new Date().toISOString()) })
        .where(eq(users.id, userFound[0].id))
    }
    if (dealerFound.length > 0) {
      await db.update(dealers)
        .set({ verified: true, verificationToken: null, updatedAt: (new Date().toISOString()) })
        .where(eq(dealers.id, dealerFound[0].id))
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
    if (!type || (type !== 'user' && type !== 'dealer')) {
      res.status(401).json({ message: 'Account type is required' })
      return
    }

    let userFound: User[] = [];
    let dealerFound: Dealer[] = [];
    if (type === 'user') {
      if (email)
        userFound = await db.select().from(users).where(eq(users.email, email))
      else if (username)
        userFound = await db.select().from(users).where(eq(users.username, username))
    } else {
      if (email)
        dealerFound = await db.select().from(dealers).where(eq(dealers.email, email))
      else if (username)
        dealerFound = await db.select().from(dealers).where(eq(dealers.name, username))
    }

    if (!((!userFound || userFound.length === 0) || (!dealerFound || dealerFound.length === 0))) {
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
      return
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
          userName: (userFound[0] as User).username,
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

export const reqResetPass = async (req: Request, res: Response) => {
  const { email } = req.body
  const userFound = await db.select().from(users).where(eq(users.email, email))

  if (!userFound || userFound.length <= 0) {
    res.status(404).json({ message: `User not found.` })
    return
  }

  const resetToken = generatePassRstToken()
  const success = await db.update(users).set({
    resetToken
  }).where(eq(users.id, userFound[0].id))
  if (success) {
    const resetLink = `${process.env.FRONTEND_URL}/password-reset?token=${resetToken}`
    await sendEmail(userFound[0].email, `Password Reset Requested`, `<a href="${resetLink}>Reset Password</a>`)
    res.status(200).json({ message: `Password reset email sent.` })
  } else {
    res.status(500).json({ message: 'Password reset failed.' })
  }
}

export const reqResetPassDealer = async (req: Request, res: Response) => {
  const { email } = req.body
  const dealerFound = await db.select().from(dealers).where(eq(dealers.email, email))

  if (!dealerFound || dealerFound.length <= 0) {
    res.status(404).json({ message: `Account not found.` })
    return
  }

  const resetToken = generatePassRstToken()
  const resetLink = `${process.env.FRONTEND_URL}/password-reset?token=${resetToken}`
  await sendEmail(dealerFound[0].email, `Password Reset Requested`, `<a href="${resetLink}>Reset Password</a>`)
  res.status(200).json({ message: `Password reset email sent.` })
}

export const resetPwd = async (req: Request, res: Response) => {
  const { token } = req.query
  const { password } = req.body
  const userFound = await db.select().from(users).where(eq(users.resetToken, token as string))
  if (!userFound || userFound.length <= 0) {
    res.status(404).json({ message: `Account not found.` })
    return
  }
  const newPass = await hash(password)
  const success = await db.update(users).set({
    password: newPass,
    resetToken: null
  }).where(eq(users.id, userFound[0].id))

  if (success) {
    res.status(200).json({ message: `Password reset successful.` })
    return
  } else {
    res.status(500).json({ message: `Password reset failed.` })
  }
}

export const resetPwdDealer = async (req: Request, res: Response) => {
  const { token } = req.query
  const { password } = req.body
  const dealerFound = await db.select().from(dealers).where(eq(dealers.resetToken, token as string))
  if (!dealerFound || dealerFound.length <= 0) {
    res.status(404).json({ message: `Account not found.` })
    return
  }
  const newPass = await hash(password)
  const success = await db.update(dealers).set({
    password: newPass,
    resetToken: null
  }).where(eq(dealers.id, dealerFound[0].id))

  if (success) {
    res.status(200).json({ message: `Password reset successful.` })
    return
  } else {
    res.status(500).json({ message: `Password reset failed.` })
  }
}

export const requireAuth = passport.authenticate('jwt', { session: false });

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

export const userOnly = (req: RequestWithUser, res: Response, next: NextFunction): void => {
  if (req.userType !== 'user') {
    res.status(403).json({ message: 'Access denied. User access only.' });
    return;
  }
  next();
};

export const dealerOnly = (req: RequestWithUser, res: Response, next: NextFunction): void => {
  if (req.userType !== 'dealer') {
    res.status(403).json({ message: 'Access denied. Dealer access only.' });
    return;
  }
  next();
};
