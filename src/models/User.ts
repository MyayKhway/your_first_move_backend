/* eslint-disable  @typescript-eslint/no-explicit-any */
export class User {
  private id?: string;
  private username: string;
  private email: string;
  private password: string;
  private createdAt: Date;
  private updatedAt: Date;

  constructor(
    username: string,
    email: string,
    password: string,
    id?: string
  ) {
    // Input validation
    this.validateUsername(username);
    this.validateEmail(email);
    this.validatePassword(password);

    this.username = username;
    this.email = email;
    //TODO hash
    this.password = password;
    this.id = id;
    this.createdAt = new Date();
    this.updatedAt = new Date();
  }

  // Getters
  getId(): string | undefined {
    return this.id;
  }

  getUsername(): string {
    return this.username;
  }

  getEmail(): string {
    return this.email;
  }

  getCreatedAt(): Date {
    return this.createdAt;
  }

  getUpdatedAt(): Date {
    return this.updatedAt;
  }

  // Setters with validation
  setUsername(username: string): void {
    this.validateUsername(username);
    this.username = username;
    this.updatedAt = new Date();
  }

  setEmail(email: string): void {
    this.validateEmail(email);
    this.email = email;
    this.updatedAt = new Date();
  }

  setPassword(password: string): void {
    this.validatePassword(password);
    //TODO hash the password
    this.password = password; // Should be hashed in real implementation
    this.updatedAt = new Date();
  }

  // Validation methods
  private validateUsername(username: string): void {
    if (!username || username.trim().length < 3) {
      throw new Error('Username must be at least 3 characters long');
    }
  }

  private validateEmail(email: string): void {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRegex.test(email)) {
      throw new Error('Invalid email format');
    }
  }

  private validatePassword(password: string): void {
    if (!password || password.length < 8) {
      throw new Error('Password must be at least 8 characters long');
    }
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      username: this.username,
      email: this.email,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }

  static fromJSON(data: Record<string, any>): User {
    const user = new User(
      data.username,
      data.email,
      data.password,
      data.id
    );

    if (data.createdAt) {
      user.createdAt = new Date(data.createdAt);
    }

    if (data.updatedAt) {
      user.updatedAt = new Date(data.updatedAt);
    }

    return user;
  }
}
