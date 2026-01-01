# /docs/gtm - Go-To-Market

<!--
HOW TO USE THIS FOLDER:

GTM (Go-To-Market) strategies for getting discovered. Set these up AFTER your MVP works.

**The order:**
1. 01-long-tail-seo.md → Auto-generate SEO articles (1/day)
2. 02-json-ld.md → Get found by ChatGPT/Perplexity
3. 03-backlinks.md → Build authority

**When to do this:**
- MVP is functional and deployed
- You have business context filled out (02-business-context.md)
- You're ready to focus on traffic/growth

**Long-Tail SEO is a TWO-STEP process:**
1. Run PROMPT_KEYWORD_RESEARCH.txt (generates 100 briefs with real search volume)
2. Run PROMPT_LONG_TAIL_SEO.txt (builds the daily article system)
-->

---

## GTM Strategies

| # | File | Purpose | Effort |
|---|------|---------|--------|
| 1 | [01-long-tail-seo.md](01-long-tail-seo.md) | Auto-generate 1 SEO article/day | Medium (two prompts) |
| 2 | [02-json-ld.md](02-json-ld.md) | Get discovered by AI assistants | Low (one-time) |
| 3 | [03-backlinks.md](03-backlinks.md) | Build domain authority | Medium (ongoing) |

---

## Prerequisites

Before adding GTM strategies, ensure you have:

- [ ] MVP deployed and working
- [ ] `/docs/02-business-context.md` filled out
- [ ] Domain verified for email (for article approval emails)
- [ ] Basic analytics set up (to track results)

---

## Long-Tail SEO Overview

**This is NOT a simple one-step setup.** The SEO Foundation Layer requires:

### Step 1: Keyword Research
- Uses Keywords Everywhere MCP for real search volume data
- Generates 100 article briefs with titles, keywords, and intent
- Creates SEO_KEYWORDS.md memory file
- Seeds SEOBrief database table

### Step 2: System Build
- Creates database schema (SEOPillar, SEOBrief, SEOArticle, SEORule)
- Sets up daily cron job that executes briefs in priority order
- Builds article renderer and approval flow
- Integrates with sitemap

**Prompt files** (40k+ tokens each):
- `PROMPT_KEYWORD_RESEARCH.txt` - Run first
- `PROMPT_LONG_TAIL_SEO.txt` - Run second

Get prompts from: https://hashbuilds.com/claude-code-long-tail-seo

---

## What Each Strategy Does

### Long-Tail SEO (01-long-tail-seo.md)
Auto-generates educational content targeting long-tail keywords:
- "How to [solve problem]"
- "[Your service] vs [competitor]"
- "What is [industry term]"

**Result**: 100 articles in ~3 months, organic traffic growth

### JSON-LD Schema (02-json-ld.md)
Structured data that helps AI assistants understand your site:
- Organization schema
- FAQ schema
- Service/Product schema

**Result**: Appear in ChatGPT, Perplexity, and Google AI summaries

### Backlinks (03-backlinks.md)
Strategies for building domain authority:
- Guest posting
- Podcast appearances
- Tool/resource attribution

**Result**: Higher rankings, more referral traffic

---

_Start with Long-Tail SEO - it's the foundation everything else builds on._
