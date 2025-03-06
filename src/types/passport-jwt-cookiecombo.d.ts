/* eslint-disable @typescript-eslint/no-explicit-any */

declare module 'passport-jwt-cookiecombo' {
  import { Strategy as PassportStrategy } from 'passport-strategy'
  import { RequestWithUser } from '../services/auth_services';

  export interface StrategyOptions {
    secretOrPublicKey: string | Buffer;
    jwtCookieName?: string,
    passReqToCallback?: boolean,
  }

  export interface VerifyCallback {
    (req: RequestWithUser, payload: any, done: VerifiedCallback): void;
  }

  export interface VerifiedCallback {
    (error: any, user?: any, info?: any): void;
  }

  export class Strategy extends PassportStrategy {
    constructor(options: StrategyOptions, verify: VerifyCallback);
    authenticate(req: any, options?: any): void;
  }
}
