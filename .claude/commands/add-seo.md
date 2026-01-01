# Add SEO

Set up the Long-Tail SEO system for this project.

## Prerequisites Check

First, verify:
1. Is `/docs/02-business-context.md` filled out? (Required - system reads this)
2. Is the MVP deployed? (SEO is for growth, not launch)
3. Is email set up? (Required for approval emails)

If any are missing, tell the user what to complete first.

## Instructions

If prerequisites are met, guide the user through `/docs/gtm/01-long-tail-seo.md`:

1. Read the embedded PROMPT at the top
2. Ask those questions
3. Fill in the file as you go

## Key Questions to Ask

1. What type of business is this?
   - Local service
   - SaaS product
   - Consultancy/agency
   - E-commerce
   - Marketplace

2. What email should receive article approvals?

3. What are your main products/services? (for content categories)

4. Who are your competitors? (for comparison articles)

## Implementation Steps

After gathering info:

### 1. Add Database Models

Add to `prisma/schema.prisma`:

```prisma
model Article {
  id          String   @id @default(cuid())
  title       String
  slug        String   @unique
  content     String   @db.Text
  excerpt     String?
  published   Boolean  @default(true)
  approved    Boolean  @default(false)
  categoryId  String?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  category    Category? @relation(fields: [categoryId], references: [id])
}

model Category {
  id          String    @id @default(cuid())
  name        String
  slug        String    @unique
  description String?
  articles    Article[]
}
```

### 2. Run Migration

```bash
pnpm prisma migrate dev --name add-articles
```

### 3. Add Environment Variables

```env
ANTHROPIC_API_KEY="sk-ant-xxx"
APPROVAL_EMAIL="ceo@yourdomain.com"
```

### 4. Create Cron Job

Create `app/api/cron/daily-content/route.ts` for daily article generation.

### 5. Create Article Routes

- `app/articles/page.tsx` - Article listing
- `app/articles/[slug]/page.tsx` - Individual article
- `app/api/articles/approve/route.ts` - Approval endpoint

## After Setup

Tell the user:
- "✅ SEO system configured"
- "Run `curl http://localhost:3000/api/cron/daily-content` to generate first article"
- "Check email for approval link"
- "Articles will auto-generate daily via Vercel cron"

## Update GTM Status

Mark items complete in `/docs/gtm/01-long-tail-seo.md`.
