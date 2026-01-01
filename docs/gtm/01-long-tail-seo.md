# 01-long-tail-seo.md - Automated Article Generation

<!--
PROMPT: Long-Tail SEO auto-generates educational articles. Ask me:

1. Is your MVP deployed and working? (This is for growth, not launch)
   - Yes → Continue
   - Not yet → Come back after MVP is live

2. Have you filled out /docs/02-business-context.md? (The system reads this to generate relevant content)
   - Yes → Continue
   - Not yet → Fill that out first

3. What type of business is this?
   - Local service (HVAC, plumbing, legal, dental)
   - SaaS product
   - Consultancy/agency
   - E-commerce
   - Marketplace

4. Do you want to approve articles before they go live? (Recommended: Yes)
   - Yes → We'll set up email approvals
   - No → Articles auto-publish (risky)

5. What email should receive article approvals?

After you answer, I'll help you set up the auto-article generation system.
-->

---

## What This Does

Generates 1 SEO-optimized article per day targeting long-tail keywords:

- **How-to articles** - "How to [solve problem]"
- **Comparison articles** - "[Your service] vs [competitor]"
- **Explainer articles** - "What is [industry term]"
- **Buying guides** - "Best [product category]"

**Result**: 90 articles in 3 months, compounding organic traffic

---

## How It Works

1. **Reads your business context** from `/docs/02-business-context.md`
2. **Generates article ideas** based on your industry and services
3. **Writes articles** using Claude API (runs daily via cron)
4. **Sends approval email** with preview link
5. **CEO clicks approve** → Article appears in sitemap and search

---

## Required Infrastructure

| Component | Purpose | File Location |
|-----------|---------|---------------|
| Article model | Store generated articles | `prisma/schema.prisma` |
| Category model | Organize articles | `prisma/schema.prisma` |
| Cron job | Daily generation | `app/api/cron/daily-content/route.ts` |
| Article page | Display articles | `app/articles/[slug]/page.ts` |
| Approval API | Handle approvals | `app/api/articles/approve/route.ts` |

---

## Environment Variables

```env
# For article generation
ANTHROPIC_API_KEY="sk-ant-xxx"  # Get from console.anthropic.com

# For approval emails
RESEND_API_KEY="re_xxx"
APPROVAL_EMAIL="ceo@yourdomain.com"
```

---

## Setup Steps

### Step 1: Add Database Models

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

### Step 2: Create Article Generation Cron

The cron job runs daily and:
1. Reads business context
2. Picks article type (how-to, comparison, explainer, buying guide)
3. Generates content via Claude API
4. Sends approval email with preview link
5. Stores as published=true, approved=false

### Step 3: Create Approval Flow

When CEO clicks approve:
1. Sets approved=true
2. Article appears in sitemap
3. Article appears in category pages
4. Google can now discover it

---

## Content Categories

System auto-generates categories based on business type:

### Local Service (e.g., HVAC)
- Troubleshooting & DIY
- Maintenance & Prevention
- Buying Decisions
- Seasonal Tips
- Emergency Guides

### SaaS Product
- Feature Tutorials
- Use Cases
- Integrations
- Comparisons
- Best Practices

### Consultancy/Agency
- When to Hire
- Decision Frameworks
- Industry Insights
- Case Studies
- Cost Guides

---

## Testing

1. Run cron manually: `curl http://localhost:3000/api/cron/daily-content`
2. Check database for new article
3. Check email for approval request
4. Click approve link
5. Verify article appears on site

---

## Common Issues

### "Article generation failed"
- Check ANTHROPIC_API_KEY is valid
- Ensure /docs/02-business-context.md is filled out
- Check API rate limits

### "Approval email not arriving"
- Verify RESEND_API_KEY is correct
- Check domain is verified in Resend
- Verify APPROVAL_EMAIL is correct

### "Articles not appearing in search"
- Articles must be approved (not just published)
- Check sitemap includes approved articles
- Submit sitemap to Google Search Console

---

## Status

| Item | Status |
|------|--------|
| Business context filled out | [ ] |
| Article model added to Prisma | [ ] |
| Category model added to Prisma | [ ] |
| Database migrated | [ ] |
| Cron job created | [ ] |
| Article page created | [ ] |
| Approval API created | [ ] |
| ANTHROPIC_API_KEY added | [ ] |
| Test article generated | [ ] |
| Approval flow tested | [ ] |

---

_This is the "SEO Foundation Layer" - boring but essential content that builds organic traffic over time._
