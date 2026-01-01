# 07-analytics.md - Analytics Configuration

<!--
PROMPT: Analytics should be set up before launch. Ask me:

1. What level of analytics do you need?
   - Basic (Vercel Analytics - free, simple traffic)
   - Product (PostHog - user behavior, funnels)
   - Marketing (Google Analytics 4 - SEO, campaigns)
   - All-in-one (PostHog - most complete)

2. Is your app deployed on Vercel? (Vercel Analytics is automatic)

3. Do you need session recordings? (PostHog provides this)

4. What key events should we track?
   - signed_up, logged_in
   - feature_used
   - checkout_started, purchase_completed
   - subscription_started, subscription_cancelled

After you answer, I'll help you configure analytics tracking.
-->

---

## What It Does

Tracks user behavior: page views, events, conversions, user journeys.

---

## When You Need It

- **Pre-launch** - Set up before going live
- **Growth phase** - Track what's working
- **Optimization** - A/B testing, funnel analysis

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "What analytics do you need?"
>
> | Level | Tools | When |
> |-------|-------|------|
> | **Basic** | Vercel Analytics | MVP, simple traffic |
> | **Product** | PostHog / Mixpanel | Understanding user behavior |
> | **Marketing** | Google Analytics 4 | SEO, campaigns, acquisition |
> | **All-in-one** | PostHog | Most complete open-source |
>
> **Our default recommendation: Vercel Analytics + PostHog**
> - Vercel: Free, automatic, privacy-friendly
> - PostHog: Free tier generous, session recordings, funnels

---

## Recommended Setup: Vercel Analytics

### Step 1: Enable in Vercel

1. Go to Vercel Dashboard
2. Select your project
3. Go to Analytics tab
4. Enable Web Analytics (free for Hobby)

### Step 2: Install Package

```bash
pnpm add @vercel/analytics
```

### Step 3: Add to Layout

Update `app/layout.tsx`:

```tsx
import { Analytics } from '@vercel/analytics/react'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

Done! Vercel Analytics now tracks page views automatically.

---

## Optional: PostHog (Product Analytics)

### Step 1: Create PostHog Account

1. Go to [posthog.com](https://posthog.com)
2. Sign up (generous free tier: 1M events/month)
3. Create project, get API key

### Step 2: Add Environment Variables

```env
NEXT_PUBLIC_POSTHOG_KEY="phc_xxx"
NEXT_PUBLIC_POSTHOG_HOST="https://app.posthog.com"
```

### Step 3: Install Package

```bash
pnpm add posthog-js
```

### Step 4: Create Provider

Create `components/providers/posthog.tsx`:

```tsx
'use client'

import posthog from 'posthog-js'
import { PostHogProvider } from 'posthog-js/react'
import { useEffect } from 'react'

export function PHProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
      api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST,
      capture_pageview: false, // We'll capture manually
    })
  }, [])

  return <PostHogProvider client={posthog}>{children}</PostHogProvider>
}
```

### Step 5: Add to Layout

```tsx
import { PHProvider } from '@/components/providers/posthog'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <PHProvider>
          {children}
        </PHProvider>
      </body>
    </html>
  )
}
```

---

## Tracking Events

### Basic Event

```typescript
import posthog from 'posthog-js'

// Track button click
posthog.capture('button_clicked', {
  button_name: 'Sign Up',
  page: '/pricing',
})
```

### User Identification

```typescript
// After login
posthog.identify(user.id, {
  email: user.email,
  name: user.name,
  plan: user.plan,
})
```

### Page View (manual)

```typescript
// In a useEffect or page component
posthog.capture('$pageview', {
  path: window.location.pathname,
})
```

---

## Environment Variables

```env
# Vercel Analytics (automatic, no env needed)

# PostHog (optional)
NEXT_PUBLIC_POSTHOG_KEY="phc_xxx"
NEXT_PUBLIC_POSTHOG_HOST="https://app.posthog.com"

# Google Analytics (optional)
NEXT_PUBLIC_GA_ID="G-xxx"
```

---

## Key Metrics to Track

| Metric | What It Tells You |
|--------|-------------------|
| Page views | Traffic volume |
| Unique visitors | Real user count |
| Bounce rate | First impression quality |
| Session duration | Engagement level |
| Conversion rate | Business success |
| Feature usage | What users actually use |

---

## Common Events to Track

| Event | When |
|-------|------|
| `signed_up` | User creates account |
| `logged_in` | User signs in |
| `feature_used` | User uses key feature |
| `checkout_started` | User begins purchase |
| `purchase_completed` | User completes purchase |
| `subscription_started` | User subscribes |
| `subscription_cancelled` | User churns |

---

## Privacy Considerations

- **Cookie consent** - Required in EU (use cookie banner)
- **Data retention** - Set appropriate retention periods
- **User opt-out** - Provide way to disable tracking
- **PII** - Never track passwords, sensitive data

---

## Common Issues

### "Events not showing"
- Check API key is correct
- Ensure provider is in layout
- Check browser console for errors
- Ad blockers may block analytics

### "Duplicate page views"
- React StrictMode causes double renders
- Use `capture_pageview: false` and track manually

---

## Status

| Item | Status |
|------|--------|
| Analytics needed? | [ ] |
| Vercel Analytics enabled | [ ] |
| PostHog set up (optional) | [ ] |
| Key events identified | [ ] |
| Tracking tested | [ ] |

---

_Last updated: [DATE]_
