import dotenv from 'dotenv'
import express, { Request, Response } from 'express';
import authRouter from './routes/authRouter';
import cookieParser from 'cookie-parser';
import { setupPassport } from './services/auth_services';
import { ask } from './services/openai_services';
import cors, { CorsOptions } from 'cors'
import carRouter from './routes/carRouter';
import dealerRouter from './routes/dealerRouter';
import openaiRouter from './routes/openaiRouter';
import { json } from './routes/carRouter';

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
app.use('/openai', openaiRouter)


app.post('/ai-query', async (req, res) => {
  const { searchQuery } = req.body
  const queryAns = await ask(searchQuery)
  if (!queryAns) {
    res.status(500).json({ message: "server error" })
    return
  }
  const { reason, carRecommendations } = queryAns
  res.status(200).send({ reason, carRecommendations: json(carRecommendations) })
})


app.get('/', async (req: Request, res: Response) => {
  res.json({ message: 'Hello, from dummy app.' });
});

app.get('/openai', async (req, res,) => {
  const chatCompletion = await ask("blahblah");
  res.status(200).json({ result: chatCompletion })
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
