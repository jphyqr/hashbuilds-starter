# Add SEO

Set up the Long-Tail SEO Foundation Layer for this project.

## Prerequisites Check

First, verify:
1. Is `/docs/02-business-context.md` filled out? (Required - system reads this)
2. Is the MVP deployed? (SEO is for growth, not launch)
3. Is email set up? (Required for approval emails)
4. Is Keywords Everywhere MCP installed? (Required for keyword research)
   - Test by calling: `mcp__keywords-everywhere__get_credits`

If any are missing, tell the user what to complete first.

## This is a TWO-STEP process

**Step 1: Keyword Research** (`/prompts/keyword-research.txt`)
- Uses Keywords Everywhere MCP for real search volume
- Generates 100 article briefs (title, keyword, volume, intent)
- Creates SEO_KEYWORDS.md memory file
- Seeds SEOBrief database table

**Step 2: System Build** (`/prompts/long-tail-seo.txt`)
- Creates database schema (SEOPillar, SEOBrief, SEOArticle, SEORule)
- Sets up daily cron job
- Builds article renderer and approval flow
- Integrates with sitemap

## Instructions

If prerequisites are met, run both steps in order.

### Step 1: Run Keyword Research

1. Read `/prompts/keyword-research.txt`
2. Follow the prompt's instructions to:
   - Analyze 02-business-context.md
   - Ask discovery questions about pillars and future content
   - Use Keywords Everywhere MCP for real search volume
   - Generate 100 article briefs
   - Create SEO_KEYWORDS.md
   - Seed database with SEOBrief records

### Step 2: Run System Build

1. Read `/prompts/long-tail-seo.txt`
2. Follow the prompt's instructions to:
   - Add Prisma models (SEOPillar, SEOBrief, SEOArticle, SEORule)
   - Create daily cron job
   - Build article pages and renderer
   - Set up email approval flow
   - Integrate with sitemap

## Database Schema (For Reference)

```prisma
model SEOPillar {
  id          String   @id @default(cuid())
  name        String
  slug        String   @unique
  description String?
  active      Boolean  @default(true)
  briefs      SEOBrief[]
  articles    SEOArticle[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model SEOBrief {
  id              String   @id @default(cuid())
  pillarId        String
  pillar          SEOPillar @relation(fields: [pillarId], references: [id])
  title           String
  primaryKeyword  String
  primaryVolume   Int
  secondaryKeywords String[]
  searchIntent    String
  linkTargets     String[]
  priority        Int      @default(50)
  status          String   @default("pending")
  articleId       String?  @unique
  article         SEOArticle? @relation(fields: [articleId], references: [id])
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
}

model SEOArticle {
  id          String   @id @default(cuid())
  pillarId    String
  pillar      SEOPillar @relation(fields: [pillarId], references: [id])
  title       String
  slug        String   @unique
  content     String   @db.Text
  excerpt     String?
  published   Boolean  @default(true)
  approved    Boolean  @default(false)
  brief       SEOBrief?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}
```

## Environment Variables Needed

```env
ANTHROPIC_API_KEY="sk-ant-xxx"
RESEND_API_KEY="re_xxx"
ADMIN_EMAIL="ceo@yourdomain.com"
NEXT_PUBLIC_BASE_URL="https://yourdomain.com"
CRON_SECRET="random-secret-string"
```

## After Setup

Tell the user:
- "✅ SEO system configured"
- "Test cron: `curl http://localhost:3000/api/cron/daily-content?secret=YOUR_CRON_SECRET`"
- "Check email for approval link"
- "Articles will auto-generate daily via Vercel cron"

## Update GTM Status

Mark items complete in `/docs/gtm/01-long-tail-seo.md`.
