import { Resend } from "resend"

// Initialize Resend client
// Set RESEND_API_KEY in your .env file
const resend = new Resend(process.env.RESEND_API_KEY)

type SendEmailParams = {
  to: string | string[]
  subject: string
  html?: string
  text?: string
  replyTo?: string
}

export async function sendEmail({ to, subject, html, text, replyTo }: SendEmailParams) {
  if (!process.env.RESEND_API_KEY) {
    console.warn("RESEND_API_KEY not set, skipping email")
    return { success: false, error: "Email not configured" }
  }

  if (!process.env.EMAIL_FROM) {
    console.warn("EMAIL_FROM not set, skipping email")
    return { success: false, error: "Email sender not configured" }
  }

  try {
    const { data, error } = await resend.emails.send({
      from: process.env.EMAIL_FROM,
      to,
      subject,
      html,
      text,
      replyTo,
    })

    if (error) {
      console.error("Email error:", error)
      return { success: false, error: error.message }
    }

    return { success: true, id: data?.id }
  } catch (error) {
    console.error("Failed to send email:", error)
    return { success: false, error: String(error) }
  }
}

// Convenience functions - customize as needed

export async function sendWelcomeEmail(email: string, name?: string) {
  return sendEmail({
    to: email,
    subject: "Welcome!",
    html: `
      <h1>Welcome${name ? `, ${name}` : ""}!</h1>
      <p>Thanks for signing up. We're excited to have you.</p>
    `,
  })
}

export async function sendNotificationEmail(email: string, message: string) {
  return sendEmail({
    to: email,
    subject: "New Notification",
    html: `<p>${message}</p>`,
  })
}
