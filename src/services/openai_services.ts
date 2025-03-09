import OpenAI from 'openai'
import { z } from 'zod'

const client = new OpenAI({
  apiKey: process.env.OPENAI_APIKEY,
})

const responseFormat = z.object({
  year: z.number(),
  make: z.string(),
  model: z.string(),
})


async function ask() {
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
        content: 'I am a student commuting to my school every day. Recommend me cars. I am not very rich but I want a fast car.'
      }
    ],
    model: 'gpt-4o-mini',
    response_format: responseFormat,
  });
  return chatCompletion
}

export { ask }
