import dotenv from 'dotenv'
import express, { Request, Response } from 'express';
import authRouter from './routes/authRouter';
import cookieParser from 'cookie-parser';
import { setupPassport } from './services/auth_services';

dotenv.config()
const app = express();

app.use(express.json());
app.use(cookieParser(process.env.SECRET_KEY!))
setupPassport(app)
app.use('/auth', authRouter)


app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Hello, from dummy app.' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
