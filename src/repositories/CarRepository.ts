import { Car } from '../models/Car';

export interface UserRepository {
  findById(id: string): Promise<Car | null>;
}
