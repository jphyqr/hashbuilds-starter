# SMS.md - SMS/Text Messaging Configuration

---

## What It Does

Sends SMS text messages: verification codes, notifications, alerts.

---

## When You Need It

- **2FA** - Two-factor authentication codes
- **Urgent alerts** - Time-sensitive notifications
- **Delivery updates** - Order tracking
- **Appointment reminders** - Service businesses

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Do you need SMS capabilities?"
>
> | Answer | Action |
> |--------|--------|
> | **Yes** | Continue with setup |
> | **Not yet** | Skip this file, email usually suffices |
>
> **Note:** Most apps can use email instead. SMS is for truly urgent/time-sensitive messages.

---

## Decision Point 2

> **Claude Code should ask the developer:**
>
> "What SMS provider do you want?"
>
> | Provider | Best For | Pricing |
> |----------|----------|---------|
> | **Twilio** | Full-featured, global | $0.0079/msg + phone number |
> | **AWS SNS** | If already on AWS | $0.00645/msg |
> | **MessageBird** | Europe focus | Varies by country |
> | **Vonage** | Enterprise | Contact sales |
>
> **Our default recommendation: Twilio**
> - Most documentation/examples
> - Easy to set up
> - Good international coverage

---

## Recommended Setup: Twilio

### Step 1: Create Twilio Account

1. Go to [twilio.com](https://www.twilio.com)
2. Sign up (credit card required for phone number)
3. Buy a phone number ($1/month)
4. Get credentials from Console

### Step 2: Add Environment Variables

```env
# Twilio
TWILIO_ACCOUNT_SID="ACxxx"
TWILIO_AUTH_TOKEN="xxx"
TWILIO_PHONE_NUMBER="+1234567890"  # Your Twilio number
```

### Step 3: Install Dependencies

```bash
pnpm add twilio
```

### Step 4: Create SMS Helper

Create `lib/sms.ts`:

```typescript
import twilio from 'twilio'

const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
)

export async function sendSMS(to: string, body: string) {
  try {
    const message = await client.messages.create({
      body,
      from: process.env.TWILIO_PHONE_NUMBER,
      to,
    })

    return { success: true, sid: message.sid }
  } catch (error) {
    console.error('SMS error:', error)
    throw error
  }
}

// Convenience functions
export async function sendVerificationCode(phone: string, code: string) {
  return sendSMS(phone, `Your verification code is: ${code}`)
}

export async function sendAlert(phone: string, message: string) {
  return sendSMS(phone, `ALERT: ${message}`)
}
```

---

## Environment Variables

```env
# Twilio
TWILIO_ACCOUNT_SID="ACxxx"
TWILIO_AUTH_TOKEN="xxx"
TWILIO_PHONE_NUMBER="+1234567890"
```

---

## Testing

### Test Mode
Twilio provides test credentials that don't send real messages:
- Test Account SID: `ACxxx...test`
- Use magic numbers like `+15005550006` for testing

### API Route for Testing

```typescript
import { sendSMS } from '@/lib/sms'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const { to, message } = await request.json()

  try {
    const result = await sendSMS(to, message)
    return NextResponse.json(result)
  } catch (error) {
    return NextResponse.json({ error: String(error) }, { status: 500 })
  }
}
```

---

## Common Patterns

### Phone Number Format

Always use E.164 format: `+[country code][number]`
```typescript
function formatPhone(phone: string): string {
  // Remove all non-digits
  const digits = phone.replace(/\D/g, '')

  // Assume US if 10 digits
  if (digits.length === 10) {
    return `+1${digits}`
  }

  // Already has country code
  return `+${digits}`
}
```

### Rate Limiting

```typescript
// Simple rate limit: 1 SMS per minute per number
const recentSMS = new Map<string, number>()

export async function sendSMSWithLimit(to: string, body: string) {
  const lastSent = recentSMS.get(to)
  const now = Date.now()

  if (lastSent && now - lastSent < 60000) {
    throw new Error('Please wait before requesting another SMS')
  }

  recentSMS.set(to, now)
  return sendSMS(to, body)
}
```

---

## Costs Consideration

| Item | Cost |
|------|------|
| Phone number | ~$1/month |
| Outbound SMS (US) | ~$0.0079/message |
| Outbound SMS (intl) | Varies ($0.05-0.15) |
| Inbound SMS | ~$0.0075/message |

**Budget tip:** Use SMS sparingly. Email is free.

---

## Common Issues

### "Unable to create record"
- Phone number format wrong (use E.164)
- Twilio phone number not SMS-capable

### "Unverified number"
- Trial accounts can only send to verified numbers
- Upgrade or verify recipient number

### "Geographic permission"
- Some countries blocked by default
- Enable in Twilio Console → Messaging → Geo Permissions

---

## Status

| Item | Status |
|------|--------|
| SMS needed? | [ ] |
| Twilio account created | [ ] |
| Phone number purchased | [ ] |
| Credentials added | [ ] |
| Test SMS sent | [ ] |

---

_Last updated: [DATE]_
