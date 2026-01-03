# Page Creation Checklist

**Read this BEFORE creating any `page.tsx` or `layout.tsx` file.**

---

## Pre-Flight Checklist

Before creating a new page, answer these questions:

| Question | Answer | Impact |
|----------|--------|--------|
| Is this a public page? | Yes/No | SEO requirements |
| Does it need client-side interactivity? | Yes/No | Layout boundary |
| Is it part of a programmatic set? | Yes/No | Dynamic metadata |
| Does it display structured content? | Yes/No | JSON-LD schema |

---

## Layout Decision Tree

```
Is this page public-facing (SEO matters)?
├── YES → Does it need client interactivity (useState, onClick)?
│   ├── YES → Create layout.tsx with metadata, page.tsx with 'use client'
│   └── NO → Server component page.tsx with metadata export
└── NO (admin/dashboard) → Can use simpler layout, skip SEO
```

### Layout Hierarchy

```
app/
├── layout.tsx              # Root: fonts, analytics, base metadata
├── (marketing)/            # Group: public pages
│   ├── layout.tsx          # Marketing layout with nav/footer
│   ├── page.tsx            # Homepage
│   └── about/
│       └── page.tsx        # Inherits marketing layout
├── (app)/                  # Group: authenticated app
│   ├── layout.tsx          # App layout with sidebar
│   └── dashboard/
│       └── page.tsx
└── (admin)/                # Group: admin only
    ├── layout.tsx          # Admin layout
    └── admin/
        └── page.tsx
```

---

## SEO Requirements (Public Pages)

### Every Public Page MUST Have:

- [ ] **Title** - Unique, descriptive, 50-60 characters
- [ ] **Description** - Compelling, 150-160 characters
- [ ] **OpenGraph image** - 1200x630px (or inherit from layout)
- [ ] **Canonical URL** - Prevent duplicate content

### Metadata Export Options

**Option 1: Static Metadata (simple pages)**

```typescript
// app/about/page.tsx
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'About Us | Vancouver Sublets',
  description: 'Learn about Vancouver Sublets - your trusted source for short-term rentals in Vancouver.',
  openGraph: {
    title: 'About Us | Vancouver Sublets',
    description: 'Learn about Vancouver Sublets...',
    url: 'https://vancouversublets.ca/about',
    images: ['/og/about.png'],
  },
}

export default function AboutPage() {
  return <div>...</div>
}
```

**Option 2: Dynamic Metadata (data-driven pages)**

```typescript
// app/listings/[id]/page.tsx
import { Metadata } from 'next'
import { db } from '@/lib/db'

type Props = {
  params: Promise<{ id: string }>
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const listing = await db.listing.findUnique({ where: { id } })

  if (!listing) {
    return { title: 'Listing Not Found' }
  }

  return {
    title: `${listing.title} | Vancouver Sublets`,
    description: listing.description.slice(0, 160),
    openGraph: {
      title: listing.title,
      description: listing.description.slice(0, 160),
      images: listing.images?.[0] ? [listing.images[0]] : ['/og/default.png'],
    },
  }
}

export default async function ListingPage({ params }: Props) {
  const { id } = await params
  // ...
}
```

**Option 3: Template Metadata (layout-level)**

```typescript
// app/(marketing)/layout.tsx
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: {
    template: '%s | Vancouver Sublets',
    default: 'Vancouver Sublets - Short-Term Rentals',
  },
  openGraph: {
    siteName: 'Vancouver Sublets',
    images: ['/og/default.png'],
  },
}
```

---

## JSON-LD Schema (Structured Data)

### When to Add JSON-LD

| Page Type | Schema Type | Priority |
|-----------|-------------|----------|
| Homepage | Organization, WebSite | High |
| Product/Listing | Product, RealEstateListing | High |
| Article/Blog | Article, BlogPosting | High |
| FAQ page | FAQPage | Medium |
| Contact page | ContactPage | Medium |
| About page | AboutPage | Low |

### JSON-LD Template

```typescript
// app/listings/[id]/page.tsx
import { Metadata } from 'next'

export default async function ListingPage({ params }: Props) {
  const { id } = await params
  const listing = await db.listing.findUnique({ where: { id } })

  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'RealEstateListing',
    name: listing.title,
    description: listing.description,
    url: `https://vancouversublets.ca/listings/${id}`,
    image: listing.images,
    offers: {
      '@type': 'Offer',
      price: listing.price,
      priceCurrency: 'CAD',
    },
    address: {
      '@type': 'PostalAddress',
      addressLocality: 'Vancouver',
      addressRegion: 'BC',
      addressCountry: 'CA',
    },
  }

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      {/* Page content */}
    </>
  )
}
```

---

## Client Components & Layouts

### The Golden Rule

> **Metadata must be in a Server Component.** If your page needs `'use client'`, put metadata in the layout.

### Pattern: Client Page with SEO

```typescript
// app/listings/[id]/layout.tsx (Server Component)
import { Metadata } from 'next'
import { db } from '@/lib/db'

type Props = {
  params: Promise<{ id: string }>
  children: React.ReactNode
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const listing = await db.listing.findUnique({ where: { id } })
  return {
    title: listing?.title || 'Listing',
    description: listing?.description?.slice(0, 160),
  }
}

export default function ListingLayout({ children }: Props) {
  return <>{children}</>
}
```

```typescript
// app/listings/[id]/page.tsx (Client Component)
'use client'

import { useState } from 'react'

export default function ListingPage({ params }: { params: { id: string } }) {
  const [saved, setSaved] = useState(false)
  // Interactive UI...
}
```

---

## Programmatic/Dynamic Pages

### For Large Sets of Pages (pSEO)

```typescript
// app/neighborhoods/[slug]/page.tsx

// Generate all possible paths at build time
export async function generateStaticParams() {
  const neighborhoods = await db.neighborhood.findMany()
  return neighborhoods.map((n) => ({ slug: n.slug }))
}

// Dynamic metadata per page
export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const neighborhood = await db.neighborhood.findUnique({ where: { slug } })
  return {
    title: `${neighborhood.name} Sublets | Vancouver Sublets`,
    description: `Find short-term rentals in ${neighborhood.name}, Vancouver...`,
  }
}
```

---

## Common Mistakes to Avoid

### Don't Do This

```typescript
// ❌ No metadata
export default function AboutPage() {
  return <div>About us...</div>
}

// ❌ Metadata in client component (won't work)
'use client'
export const metadata = { title: 'About' }  // Ignored!

// ❌ Hardcoded OG image URL that doesn't exist
openGraph: { images: ['/og/about.png'] }  // Does this file exist?

// ❌ Same title on every page
title: 'Vancouver Sublets'  // Not unique!
```

### Do This Instead

```typescript
// ✅ Always include metadata
export const metadata: Metadata = {
  title: 'About Us | Vancouver Sublets',
  description: 'Learn about our mission...',
}

// ✅ Use layout for client pages
// layout.tsx has metadata, page.tsx has 'use client'

// ✅ Have a default OG image
// public/og/default.png exists as fallback

// ✅ Unique titles per page
title: 'About Us | Vancouver Sublets'
title: 'Contact | Vancouver Sublets'
title: 'Downtown Vancouver Sublets | Vancouver Sublets'
```

---

## Quick Copy Templates

### Basic Public Page

```typescript
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'PAGE_TITLE | SITE_NAME',
  description: 'PAGE_DESCRIPTION (150-160 chars)',
  openGraph: {
    title: 'PAGE_TITLE | SITE_NAME',
    description: 'PAGE_DESCRIPTION',
    url: 'https://DOMAIN/PATH',
  },
}

export default function PageName() {
  return (
    <main>
      <h1>PAGE_TITLE</h1>
      {/* Content */}
    </main>
  )
}
```

### Dynamic Page with JSON-LD

```typescript
import { Metadata } from 'next'
import { db } from '@/lib/db'
import { notFound } from 'next/navigation'

type Props = {
  params: Promise<{ id: string }>
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const item = await db.item.findUnique({ where: { id } })

  if (!item) return { title: 'Not Found' }

  return {
    title: `${item.title} | SITE_NAME`,
    description: item.description.slice(0, 160),
  }
}

export default async function ItemPage({ params }: Props) {
  const { id } = await params
  const item = await db.item.findUnique({ where: { id } })

  if (!item) notFound()

  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: item.title,
    description: item.description,
  }

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <main>
        <h1>{item.title}</h1>
      </main>
    </>
  )
}
```

---

## Final Checklist

Before committing a new page:

- [ ] Has unique, descriptive `<title>` (50-60 chars)
- [ ] Has compelling `description` (150-160 chars)
- [ ] Has OpenGraph tags (or inherits from layout)
- [ ] If client component, metadata is in layout
- [ ] If content page, has JSON-LD schema
- [ ] Tested with [SEO meta inspector](https://www.seometa.io/)
- [ ] OG image exists at specified path

---

_SEO done right at creation time saves hours of fixes later._
