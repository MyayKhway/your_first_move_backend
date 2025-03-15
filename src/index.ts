import dotenv from 'dotenv'
import express, { Request, Response } from 'express';
import authRouter from './routes/authRouter';
import cookieParser from 'cookie-parser';
import { setupPassport } from './services/auth_services';
import { ask } from './services/openai_services';
import cors, { CorsOptions } from 'cors'
import carRouter from './routes/carRouter';
import dealerRouter from './routes/dealerRouter';

const allowedOrigins = [
  "http://localhost:5173",
]
const corsOpts: CorsOptions = {
  origin: allowedOrigins,
  credentials: true
}


dotenv.config()
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }))
app.use(cookieParser(process.env.SECRET_KEY!))
app.use(cors(corsOpts))
setupPassport(app)
app.use('/auth', authRouter)
app.use('/car', carRouter)
app.use('/dealer', dealerRouter)


app.get('/', async (req: Request, res: Response) => {
  res.json({ message: 'Hello, from dummy app.' });
});

app.get('/openai', async (req, res,) => {
  const chatCompletion = await ask();
  res.status(200).json({ result: chatCompletion })
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
