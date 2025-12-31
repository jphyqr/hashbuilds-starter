# PAYMENTS.md - Payment Processing Configuration

---

## What It Does

Processes payments: one-time purchases, subscriptions, invoices.

---

## When You Need It

- **E-commerce** - Selling products
- **SaaS** - Subscription billing
- **Marketplace** - Transaction fees
- **Services** - Invoice payments

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Do you need to accept payments?"
>
> | Answer | Action |
> |--------|--------|
> | **Yes** | Continue with setup |
> | **Not yet** | Skip this file, come back when needed |

---

## Decision Point 2

> **Claude Code should ask the developer:**
>
> "What payment model do you need?"
>
> | Model | Example | Stripe Feature |
> |-------|---------|----------------|
> | **One-time** | E-commerce, services | Checkout Sessions |
> | **Subscriptions** | SaaS, memberships | Subscriptions + Billing Portal |
> | **Marketplace** | Take commission | Connect (complex) |
> | **Invoicing** | B2B, services | Invoicing |
>
> **Note:** Most apps start with one-time or subscriptions.

---

## Recommended Setup: Stripe

### Step 1: Create Stripe Account

1. Go to [stripe.com](https://stripe.com)
2. Sign up and verify your business
3. Get API keys from Dashboard → Developers → API Keys

### Step 2: Add Environment Variables

```env
# Stripe
STRIPE_SECRET_KEY="sk_test_xxx"          # Use sk_live_xxx for production
STRIPE_PUBLISHABLE_KEY="pk_test_xxx"     # Use pk_live_xxx for production
STRIPE_WEBHOOK_SECRET="whsec_xxx"        # From webhook endpoint
```

### Step 3: Install Dependencies

```bash
pnpm add stripe @stripe/stripe-js
```

### Step 4: Create Stripe Helper

Create `lib/stripe.ts`:

```typescript
import Stripe from 'stripe'

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-04-10',
})
```

### Step 5: Create Checkout API Route

Create `app/api/checkout/route.ts`:

```typescript
import { stripe } from '@/lib/stripe'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const { priceId, successUrl, cancelUrl } = await request.json()

  try {
    const session = await stripe.checkout.sessions.create({
      mode: 'payment',  // or 'subscription'
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: successUrl || `${process.env.NEXT_PUBLIC_URL}/success`,
      cancel_url: cancelUrl || `${process.env.NEXT_PUBLIC_URL}/cancel`,
    })

    return NextResponse.json({ url: session.url })
  } catch (error) {
    return NextResponse.json({ error: String(error) }, { status: 500 })
  }
}
```

### Step 6: Create Webhook Handler

Create `app/api/webhooks/stripe/route.ts`:

```typescript
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const body = await request.text()
  const signature = headers().get('stripe-signature')!

  let event

  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )
  } catch (err) {
    return NextResponse.json({ error: 'Invalid signature' }, { status: 400 })
  }

  switch (event.type) {
    case 'checkout.session.completed':
      const session = event.data.object
      // Handle successful payment
      console.log('Payment succeeded:', session.id)
      break

    case 'invoice.paid':
      // Handle subscription payment
      break

    case 'customer.subscription.deleted':
      // Handle subscription cancellation
      break
  }

  return NextResponse.json({ received: true })
}
```

---

## Environment Variables

```env
# Stripe
STRIPE_SECRET_KEY="sk_test_xxx"
STRIPE_PUBLISHABLE_KEY="pk_test_xxx"
STRIPE_WEBHOOK_SECRET="whsec_xxx"

# For subscriptions
STRIPE_PRICE_ID_MONTHLY="price_xxx"
STRIPE_PRICE_ID_YEARLY="price_xxx"
```

---

## Testing

### Test Mode
- Use `sk_test_` keys for development
- Test card: `4242 4242 4242 4242`
- Any future date, any CVC

### Webhook Testing
```bash
# Install Stripe CLI
brew install stripe/stripe-cli/stripe

# Login
stripe login

# Forward webhooks to local
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```

---

## Common Patterns

### Client-Side Checkout Button

```tsx
'use client'

import { Button } from '@/components/ui/button'

export function CheckoutButton({ priceId }: { priceId: string }) {
  async function handleCheckout() {
    const res = await fetch('/api/checkout', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ priceId }),
    })

    const { url } = await res.json()
    window.location.href = url
  }

  return <Button onClick={handleCheckout}>Subscribe</Button>
}
```

### Store Customer ID

```prisma
model User {
  id              String  @id @default(cuid())
  stripeCustomerId String? @unique
  // ...
}
```

---

## Subscription Considerations

| Feature | Implementation |
|---------|----------------|
| Trial periods | Set in Stripe product |
| Billing portal | `stripe.billingPortal.sessions.create()` |
| Upgrade/downgrade | Update subscription via API |
| Failed payments | Handle via webhooks |

---

## Common Issues

### "No such price"
- Create products/prices in Stripe Dashboard first
- Use correct price ID format: `price_xxx`

### "Webhook signature failed"
- Ensure STRIPE_WEBHOOK_SECRET is correct
- Use raw request body (not parsed JSON)

### "Customer not found"
- Create Stripe customer on first purchase
- Store customer ID in your database

---

## Status

| Item | Status |
|------|--------|
| Payments needed? | [ ] |
| Stripe account created | [ ] |
| Products/prices created | [ ] |
| API keys added | [ ] |
| Webhook endpoint created | [ ] |
| Test payment completed | [ ] |

---

_Last updated: [DATE]_
