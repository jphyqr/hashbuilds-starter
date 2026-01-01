# 02-json-ld.md - AI Discoverability

<!--
PROMPT: JSON-LD helps AI assistants (ChatGPT, Perplexity) understand your site. Ask me:

1. What type of entity are you?
   - Organization (most businesses)
   - LocalBusiness (has physical location)
   - SoftwareApplication (SaaS product)
   - Person (personal brand)

2. Do you have a logo? (If yes, what's the URL?)

3. Do you have social media profiles? (LinkedIn, Twitter, etc.)

4. Do you have an FAQ page or section? (FAQ schema is powerful for AI answers)

5. What are your main products/services? (For Product/Service schema)

After you answer, I'll generate your JSON-LD schema.
-->

---

## What This Does

Structured data that helps AI assistants understand your site:

- **ChatGPT** can cite your site as a source
- **Perplexity** can include you in answers
- **Google AI Overviews** can reference your content
- **Search engines** better understand your content

---

## Required Schema Types

| Schema Type | Purpose | Priority |
|-------------|---------|----------|
| Organization | Who you are | Required |
| WebSite | Your site structure | Required |
| FAQ | Common questions | High |
| Service/Product | What you offer | Medium |
| BreadcrumbList | Navigation | Nice-to-have |

---

## Implementation

### Step 1: Create JSON-LD Component

Create `components/json-ld.tsx`:

```tsx
type OrganizationSchema = {
  name: string
  url: string
  logo?: string
  description?: string
  sameAs?: string[]
}

export function OrganizationJsonLd({ data }: { data: OrganizationSchema }) {
  const schema = {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: data.name,
    url: data.url,
    ...(data.logo && { logo: data.logo }),
    ...(data.description && { description: data.description }),
    ...(data.sameAs && { sameAs: data.sameAs }),
  }

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  )
}

type FAQSchema = {
  question: string
  answer: string
}[]

export function FAQJsonLd({ faqs }: { faqs: FAQSchema }) {
  const schema = {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: faqs.map(faq => ({
      '@type': 'Question',
      name: faq.question,
      acceptedAnswer: {
        '@type': 'Answer',
        text: faq.answer,
      },
    })),
  }

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  )
}
```

### Step 2: Add to Layout

Add to `app/layout.tsx`:

```tsx
import { OrganizationJsonLd } from '@/components/json-ld'

export default function RootLayout({ children }) {
  return (
    <html>
      <head>
        <OrganizationJsonLd
          data={{
            name: "Your Company",
            url: "https://yourdomain.com",
            logo: "https://yourdomain.com/logo.png",
            description: "What you do in one sentence",
            sameAs: [
              "https://linkedin.com/company/yourcompany",
              "https://twitter.com/yourcompany",
            ],
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  )
}
```

### Step 3: Add FAQ Schema to Pages

On pages with FAQs:

```tsx
import { FAQJsonLd } from '@/components/json-ld'

export default function PricingPage() {
  const faqs = [
    {
      question: "How much does it cost?",
      answer: "Plans start at $29/month for individuals..."
    },
    {
      question: "Is there a free trial?",
      answer: "Yes, we offer a 14-day free trial..."
    }
  ]

  return (
    <>
      <FAQJsonLd faqs={faqs} />
      {/* Page content */}
    </>
  )
}
```

---

## Testing

1. Deploy your site
2. Go to [Google's Rich Results Test](https://search.google.com/test/rich-results)
3. Enter your URL
4. Verify schema is detected

---

## Common Issues

### "Schema not detected"
- Check JSON-LD is in `<head>` or `<body>`
- Validate JSON syntax (use JSON validator)
- Ensure no React errors preventing render

### "Invalid schema"
- Use [Schema.org](https://schema.org) as reference
- Check required fields are present
- Validate with [Schema Markup Validator](https://validator.schema.org)

---

## Status

| Item | Status |
|------|--------|
| Business type determined | [ ] |
| OrganizationJsonLd component created | [ ] |
| Added to root layout | [ ] |
| FAQJsonLd component created | [ ] |
| Added to relevant pages | [ ] |
| Tested with Rich Results Test | [ ] |

---

_JSON-LD is a one-time setup that pays dividends as AI search grows._
