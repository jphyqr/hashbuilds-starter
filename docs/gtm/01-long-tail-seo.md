# 01-long-tail-seo.md - SEO Foundation Layer

<!--
PROMPT: Long-Tail SEO auto-generates educational articles. This is a TWO-STEP process.

**Before we start, ask me:**

1. Is your MVP deployed and working? (This is for growth, not launch)
   - Yes → Continue
   - Not yet → Come back after MVP is live

2. Have you filled out /docs/02-business-context.md? (The system reads this to generate relevant content)
   - Yes → Continue
   - Not yet → Fill that out first

3. Do you have Keywords Everywhere MCP installed? (Required for keyword research)
   - Test: Call mcp__keywords-everywhere__get_credits
   - If not installed: Get API key at keywordseverywhere.com

**After prerequisites confirmed, guide user through:**

1. STEP 1: Read and run `/prompts/PROMPT_KEYWORD_RESEARCH.txt`
   - Generates 100 article briefs with real search volume data
   - Creates SEO_KEYWORDS.md memory file
   - Seeds SEOBrief database table

2. STEP 2: Read and run `/prompts/PROMPT_LONG_TAIL_SEO.txt`
   - Builds the daily article generation system
   - Sets up cron job, approval flow, article renderer

These prompts are large (40k+ tokens) so they live in `/prompts/`.
-->

---

## What This Does

**The SEO Foundation Layer** - autonomous article generation:

- Generates 1 SEO-optimized article per day
- Uses Claude API with pre-researched keywords (not AI guessing)
- Targets long-tail keywords with real search volume data
- CEO reviews via email, one-click approve
- Articles auto-publish after approval

**Result**: 100 articles in ~3 months, compounding organic traffic

---

## Two-Step Workflow

### Step 1: Keyword Research (Run Once)

**Prompt File**: `/prompts/PROMPT_KEYWORD_RESEARCH.txt`

This prompt:
1. Analyzes your BUSINESS-CONTEXT.md
2. Uses Keywords Everywhere MCP for real search volume
3. Generates 100 article briefs (title, keyword, volume, intent)
4. Creates SEO_KEYWORDS.md memory file
5. Seeds SEOBrief database table

**Output**:
- 4-8 content pillars based on your business type
- 100 article briefs prioritized by search volume
- Database seeded and ready for Step 2

### Step 2: System Build (Run Once)

**Prompt File**: `/prompts/PROMPT_LONG_TAIL_SEO.txt`

This prompt builds:
1. Database schema (SEOPillar, SEOBrief, SEOArticle, SEORule)
2. Daily cron job (generates from briefs, not AI guessing)
3. Article renderer component
4. Email approval flow (CEO reviews before publish)
5. Sitemap integration
6. /seo-debug admin dashboard

---

## Architecture Overview

### Database Models

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
  status          String   @default("pending") // pending | published | skipped
  articleId       String?  @unique
  article         SEOArticle? @relation(fields: [articleId], references: [id])
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt

  @@index([status])
  @@index([priority])
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

  @@index([pillarId])
  @@index([approved])
}

model SEORule {
  id          String   @id @default(cuid())
  type        String   // "voice" | "format" | "link" | "avoid"
  content     String
  active      Boolean  @default(true)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}
```

### Key Files Created

| File | Purpose |
|------|---------|
| `app/api/cron/daily-content/route.ts` | Daily article generation cron |
| `app/articles/[slug]/page.tsx` | Article display page |
| `app/articles/category/[slug]/page.tsx` | Category listing |
| `components/ArticleRenderer.tsx` | Article content renderer |
| `lib/seo-article-generator.ts` | Article generation logic |
| `app/(admin)/seo-debug/page.tsx` | Admin dashboard |
| `SEO_KEYWORDS.md` | Memory file with all 100 briefs |

---

## Environment Variables

```env
# Required for article generation
ANTHROPIC_API_KEY="sk-ant-xxx"

# Required for approval emails
RESEND_API_KEY="re_xxx"
ADMIN_EMAIL="ceo@yourdomain.com"

# Required for sitemap/canonical URLs
NEXT_PUBLIC_BASE_URL="https://yourdomain.com"

# Required for cron authentication
CRON_SECRET="random-secret-string"
```

---

## How Daily Generation Works

1. **Cron runs daily** (configured in vercel.json)
2. **Picks next pending brief** by priority (lowest = first)
3. **Generates article** using Claude API with brief's keywords/intent
4. **Stores as published=true, approved=false**
5. **Sends approval email** with preview link
6. **CEO clicks approve** → Article appears in sitemap

**Key insight**: Articles are accessible via direct URL immediately (for CEO review), but only approved articles appear in sitemap and category pages.

---

## Content Quality Rules (Built-In)

The system enforces these rules automatically:

**Never invents:**
- Fictional case studies or testimonials
- Made-up statistics
- Fake scenarios presented as real

**Always uses:**
- Direct definitions ("X is a [thing] that [does Y]")
- Factual explanations
- Third-person educational tone
- Answer search query in first paragraph

---

## Getting the Prompts

The prompts are included in this starter template:
- `/prompts/PROMPT_KEYWORD_RESEARCH.txt`
- `/prompts/PROMPT_LONG_TAIL_SEO.txt`

Use `/add-seo` command to run through the full setup.

---

## Testing

1. Run keyword research: Have Claude Code read `/prompts/PROMPT_KEYWORD_RESEARCH.txt`
2. Verify SEO_KEYWORDS.md created with 100 briefs
3. Verify SEOBrief records in database
4. Run system build: Have Claude Code read `/prompts/PROMPT_LONG_TAIL_SEO.txt`
5. Test cron manually: `curl http://localhost:3000/api/cron/daily-content?secret=YOUR_CRON_SECRET`
6. Check email for approval link
7. Approve article, verify it appears on site

---

## Common Issues

### "Keywords Everywhere MCP not found"
- Install the MCP: Get API key at keywordseverywhere.com
- Add to your Claude Code config

### "No briefs to generate from"
- Run PROMPT_KEYWORD_RESEARCH.txt first
- Check SEOBrief table has records with status="pending"

### "Approval email not arriving"
- Verify RESEND_API_KEY is correct
- Check domain is verified in Resend
- Verify ADMIN_EMAIL is correct

### "Articles not in Google"
- Articles must be approved (not just published)
- Check sitemap at /sitemap.xml includes article
- Submit sitemap to Google Search Console

---

## Status Checklist

| Step | Status |
|------|--------|
| **Prerequisites** | |
| BUSINESS-CONTEXT.md filled out | [ ] |
| Keywords Everywhere MCP installed | [ ] |
| **Step 1: Keyword Research** | |
| PROMPT_KEYWORD_RESEARCH.txt run | [ ] |
| SEO_KEYWORDS.md created | [ ] |
| 100 SEOBrief records in database | [ ] |
| **Step 2: System Build** | |
| PROMPT_LONG_TAIL_SEO.txt run | [ ] |
| Database schema applied | [ ] |
| Cron job created | [ ] |
| Article pages created | [ ] |
| Email approval working | [ ] |
| **Post-Setup** | |
| First article generated | [ ] |
| Approval flow tested | [ ] |
| /seo-debug dashboard working | [ ] |

---

_This is the "SEO Foundation Layer" - boring but essential content that compounds over time._
