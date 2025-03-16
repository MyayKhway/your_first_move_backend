import OpenAI from 'openai'
import db from '../db/connection';
import { eq } from 'drizzle-orm';
import { cars } from '../../drizzle/schema';

const client = new OpenAI({
  apiKey: process.env.OPENAI_APIKEY,
})

export async function ask(query: string) {
  const chatCompletion = await client.chat.completions.create({
    messages: [
      {
        role: 'developer',
        content: [
          {
            type: "text",
            text: `You are a helpful assistant for recommending cars.
The users will describe their needs, either subtlely or explicitly. You need to infer their needs and quantify their needs according
to the following measurements.
(Engine Fuel Type, Horsepower, Engine Cylinders,
Transmission Type, Driven Wheels, Market Category,
Vehicle Size, highway Miles per gallon, city miles per gallon,
and MSRP.
`,
          },
        ]
      },
      {
        role: 'user',
        content: query
      }
    ],
    model: 'gpt-4o-mini',
  });
  return chatCompletion
}

export async function askDescription(carId: number) {
  const carInfo = await db.select().from(cars).where(eq(cars.id, BigInt(carId)))
  const chatCompletion = await client.chat.completions.create({
    messages: [
      {
        role: 'system',
        content: [
          {
            type: "text",
            text: `You are a helpful car seller. Given the following data about a particular car. You have to describe and give reasons to buy this car
            for about six sentences. The data is make:${carInfo[0].make} model:${carInfo[0].model} year:${carInfo[0].year}`,
          },
        ]
      },
    ],
    model: 'gpt-4o-mini',
  });
  return chatCompletion.choices[0].message.content
}
