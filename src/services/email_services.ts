import nodemailer, { Transporter } from 'nodemailer';
import { SESClient, SendRawEmailCommand } from '@aws-sdk/client-ses';

const sesClient = new SESClient({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
  }
});

const devTransporter: Transporter = nodemailer.createTransport(
  {
    host: process.env.EMAIL_HOST!,
    port: parseInt(process.env.EMAIL_PORT!),
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    }
  }
  // {
  //   SES: {
  //     ses: sesClient,
  //     aws: { SendRawEmailCommand }
  //   }
  // }
)

const sesTransporter: Transporter = nodemailer.createTransport({
  SES: {
    ses: sesClient,
    aws: { SendRawEmailCommand }
  }
});

const transporter = process.env.NODE_ENV === "production" ? sesTransporter : devTransporter

interface MailOptions {
  from: string;
  to: string;
  subject: string;
  html: string;
}

export async function sendEmail(to: string, subject: string, html: string): Promise<boolean> {
  const mailOptions: MailOptions = {
    from: process.env.EMAIL_FROM!,
    to,
    subject,
    html,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log('Email sent:', info.messageId);
    return true;
  } catch (error) {
    console.error('Error sending email:', error);
    return false;
  }
}
