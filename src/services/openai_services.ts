import OpenAI from 'openai'
import { ChatCompletionTool } from 'openai/resources';
import db from '../db/connection';
import { eq } from 'drizzle-orm';
import { cars } from '../../drizzle/schema';
import { fetchCarbySpec } from './car_services';
import { CarData } from '../types/utils';

const client = new OpenAI({
  apiKey: process.env.OPENAI_APIKEY,
})

const tools: ChatCompletionTool[] = [{
  "type": "function",
  "function": {
    "name": "fetch_car",
    "description": "Fetch car from database",
    "parameters": {
      "type": "object",
      "properties": {
        "seats": {
          "type": "number",
          "description": "number of seats"
        },
        "fuel": {
          "type": "string",
          "description": "fuel type(EV, Hybrid, Petrol or Diesel)"
        },
        "style": {
          "type": "string",
          "description": "style of car body(Hatchback, SUV, Sedan, Truck, MPV, Coupe)",
        },
        "cc": {
          "type": "number",
          "description": "Engine displacement"
        },
        "min_mpg": {
          "type": "number",
          "description": "minimum miles per gallon",
        },
        "msrp": {
          "type": "number",
          "description": "price in Thai Baht"
        }
      },
      "required": [
        "seats", "fuel", "cc", "min_mpg", "msrp", "style"
      ],
      "additionalProperties": false
    },
    "strict": true
  }
}]

export async function ask(query: string) {
  interface functionArgsType {
    seats: number,
    fuel: string,
    style: string,
    cc: number,
    min_mpg: number,
    msrp: number
  }
  const chatCompletion = await client.chat.completions.create({
    messages: [
      {
        role: 'developer',
        content: [
          {
            type: "text",
            text: `
   You are a helpful assistant for recommending cars employed by Your-First-Move company. You are somewhat of a car aficionado.
   The users will describe their needs, either subtlely or explicitly. You need to infer their needs and quantify their needs according
   to the following measurements. (Engine Fuel Type, Horsepower, Engine Cylinders, Transmission Type, Driven Wheels, Market Category,
   Vehicle Size, highway Miles per gallon, city miles per gallon, and MSRP and recommend them cars. You are to query the existing database using tools(function calls).
You are not to ask questions for clarifications but you need to state reasons of your choices. In the database the cars are all brand new so they are not very cheap which means you need to 
remember that the msrp of the cars are more than you think.
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
    tools
  });
  console.log(chatCompletion.choices[0].message.content)
  const toolCalls = chatCompletion.choices[0].message.tool_calls
  if (!toolCalls || toolCalls.length <= 0)
    return null
  const promises = toolCalls.map(async (toolCall) => {
    const args: functionArgsType = JSON.parse(toolCall.function.arguments)
    const carResults = fetchCarbySpec(args)
    return carResults
  })
  const results = await Promise.all(promises)
  const carRecommendations = results.flat().filter(Boolean)
  console.log(carRecommendations)
  return { reason: chatCompletion.choices[0].message.content, carRecommendations: carRecommendations }
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
            for about six sentences. The data is
make:${carInfo[0].make}
model:${carInfo[0].model}
year:${carInfo[0].year}
engine size:${carInfo[0].cc}
and its fuel type is ${carInfo[0].fuel}.
It has ${carInfo[0].seats}.
`,
          },
        ]
      },
    ],
    model: 'gpt-4o-mini',
  });
  return chatCompletion.choices[0].message.content
}
