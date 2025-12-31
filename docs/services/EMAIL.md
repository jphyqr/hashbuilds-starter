# EMAIL.md - Transactional Email Configuration

---

## What It Does

Sends transactional emails: magic links, notifications, receipts, alerts.

---

## When You Need It

- **Auth with magic links** - Required
- **User notifications** - Usually
- **Receipts/invoices** - For payments
- **Alerts** - Admin notifications

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Which email provider do you want to use?"
>
> | Provider | Best For | Pricing |
> |----------|----------|---------|
> | **Resend** | Modern DX, React Email | 3k free/mo, then $20/mo |
> | **SendGrid** | High volume | 100/day free, then usage |
> | **Postmark** | Deliverability focus | $15/mo for 10k |
> | **AWS SES** | Cheapest at scale | $0.10/1k emails |
>
> **Our default recommendation: Resend**
> - Best developer experience
> - React Email support (build emails with JSX)
> - Simple API, great dashboard
> - 3,000 emails/month free

---

## Decision Point 2

> **Claude Code should ask the developer:**
>
> "Do you have a custom domain?"
>
> | Answer | Action |
> |--------|--------|
> | **Yes** | Configure DNS for your domain |
> | **No** | Use Resend's test domain (limited to verified emails only) |
>
> **Production requires a verified domain.**

---

## Recommended Setup: Resend

### Step 1: Create Resend Account

1. Go to [resend.com](https://resend.com)
2. Sign up (GitHub OAuth recommended)
3. You'll get a test API key immediately

### Step 2: Add Domain (for production)

1. Go to Resend Dashboard → Domains
2. Add your domain (e.g., yourdomain.com)
3. Add the DNS records Resend provides:
   - SPF record
   - DKIM records (3 CNAME)
   - Optional: DMARC

Wait for verification (usually 5-30 minutes).

### Step 3: Create API Key

1. Go to Resend Dashboard → API Keys
2. Create new key
3. Copy and add to `.env`

### Step 4: Install Dependencies

Already included in starter:
```bash
pnpm add resend
```

### Step 5: Create Email Helper

Create `lib/email.ts`:

```typescript
import { Resend } from 'resend'

const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendEmail({
  to,
  subject,
  html,
  text,
}: {
  to: string | string[]
  subject: string
  html?: string
  text?: string
}) {
  try {
    const { data, error } = await resend.emails.send({
      from: process.env.EMAIL_FROM!,
      to,
      subject,
      html,
      text,
    })

    if (error) {
      console.error('Email error:', error)
      throw error
    }

    return data
  } catch (error) {
    console.error('Failed to send email:', error)
    throw error
  }
}

// Convenience functions
export async function sendWelcomeEmail(email: string, name?: string) {
  return sendEmail({
    to: email,
    subject: 'Welcome!',
    html: `<p>Hi ${name || 'there'},</p><p>Welcome to our platform!</p>`,
  })
}

export async function sendNotificationEmail(email: string, message: string) {
  return sendEmail({
    to: email,
    subject: 'New Notification',
    html: `<p>${message}</p>`,
  })
}
```

---

## Environment Variables

```env
# Email (Resend)
RESEND_API_KEY="re_xxxxx"
EMAIL_FROM="noreply@yourdomain.com"

# For NextAuth magic links
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD="re_xxxxx"  # Same as RESEND_API_KEY
```

---

## Testing

### Option 1: Test API Route

Create `app/api/test/email/route.ts`:

```typescript
import { sendEmail } from '@/lib/email'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const { to } = await request.json()

  try {
    const result = await sendEmail({
      to,
      subject: 'Test Email',
      html: '<p>This is a test email from your app!</p>',
    })

    return NextResponse.json({ success: true, id: result?.id })
  } catch (error) {
    return NextResponse.json({ error: String(error) }, { status: 500 })
  }
}
```

### Option 2: Resend Dashboard

1. Go to Resend Dashboard
2. Click "Send test email"
3. Enter your email
4. Verify it arrives

---

## Common Email Types

| Email Type | When to Send |
|------------|--------------|
| Magic link | Auth sign-in |
| Welcome | After first sign-up |
| Password reset | User requests reset |
| Notification | Action in app |
| Receipt | After payment |
| Weekly digest | Scheduled |

---

## Common Issues

### "Email not arriving"
- Check spam/junk folder
- Verify domain is configured in Resend
- Check Resend dashboard for delivery status
- Ensure API key is correct

### "550 sending not allowed"
- Domain not verified
- Add and verify DNS records

### "Only test emails work"
- You're on free tier without verified domain
- Add your domain to send to any email

---

## Status

| Item | Status |
|------|--------|
| Provider chosen | [ ] |
| Account created | [ ] |
| Domain added | [ ] |
| DNS verified | [ ] |
| API key added to .env | [ ] |
| Test email sent | [ ] |
| Added to HANDOFF.md | [ ] |

---

_Last updated: [DATE]_
