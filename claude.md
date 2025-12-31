# claude.md - Project Command Center

**Start Here.** This file is the single source of truth for this project.

---

## Quick Start

```bash
pnpm install
pnpm run dev        # Starts on port 3000
```

**First-time setup?** See [docs/setup-checklist.md](docs/setup-checklist.md) for the complete onboarding flow.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | _[Set in docs/project-origin.md]_ |
| **Client** | _[Set in docs/project-origin.md]_ |
| **Domain** | _[Set in docs/handoff.md]_ |
| **Status** | Phase 1: Foundation |

**What is this?** _[Brief 1-sentence description - set in docs/business-context.md]_

---

## Directory Map

```
/claude.md                    ← You are here (entry point)
/README.md                    ← GitHub README

/docs/                        ← Developer documentation (internal)
  ├── project-origin.md       ← Static: original brief, timeline, deal structure
  ├── business-context.md     ← Living: business model, personas, workflows
  ├── tech-stack.md           ← Architecture decisions, conventions
  ├── handoff.md              ← Account ownership, credentials, transfer checklist
  ├── setup-checklist.md      ← First-time setup guide
  │
  ├── business/               ← CEO layer deep-dives (create as needed)
  │   ├── personas.md         ← Detailed user research
  │   ├── competitive.md      ← Market analysis
  │   ├── pricing.md          ← Revenue model
  │   ├── kpis.md             ← Metric definitions
  │   └── roadmap.md          ← Future planning
  │
  ├── services/               ← External service integrations
  │   ├── database.md         ← PostgreSQL/Neon configuration
  │   ├── auth.md             ← NextAuth setup
  │   ├── email.md            ← Resend/transactional email
  │   ├── storage.md          ← File uploads (Vercel Blob/S3)
  │   ├── payments.md         ← Stripe integration (when needed)
  │   ├── sms.md              ← Twilio/SMS (when needed)
  │   └── analytics.md        ← Analytics setup (when needed)
  │
  ├── features/               ← Feature specifications
  │   └── README.md           ← Feature spec template
  │
  └── plans/                  ← Implementation roadmaps
      └── README.md           ← Plan template

/deliverables/                ← Client-facing documentation
  ├── rollout.md              ← Public progress tracker (powers /rollout page)
  ├── progress.md             ← Completed work log
  ├── changelog.md            ← Release notes
  └── client-update.txt       ← Latest message to send client

/.claude/commands/            ← Slash commands
  ├── update-client.md        ← Generate client WhatsApp/email update
  └── update-rollout.md       ← Sync deliverables after completing work
```

---

## Critical Rules

### Database Safety (IMPORTANT)

```
NEVER run:
- prisma migrate reset
- prisma db push --force-reset
- Any command that drops tables

WHY: We often share dev/prod database. One wrong command = data loss.
```

**Safe migration pattern:**
1. Add nullable field first (`field String?`)
2. Deploy, seed data
3. Make required (`field String`) in next migration

### Environment Variables

```
Use ONE .env file only.
Never: .env.local, .env.development, .env.production
Why: Reduces confusion, single source of truth.
```

### Port Convention

Dev server runs on **port 3000** by default. If you need a different port, update `package.json`:
```json
"dev": "next dev --port 3006"
```

### File Organization

| Type | Location | Naming |
|------|----------|--------|
| Context docs | `/docs/` | lowercase-kebab.md |
| Service configs | `/docs/services/` | lowercase.md |
| Feature specs | `/docs/features/` | feature-name.md |
| Client docs | `/deliverables/` | lowercase.md |
| Components | `/components/` | PascalCase.tsx |
| Utilities | `/lib/` | camelCase.ts |
| API routes | `/app/api/` | route.ts |

---

## Tech Stack

| Layer | Technology | Status |
|-------|------------|--------|
| Framework | Next.js 15 (App Router) | Installed |
| Styling | Tailwind CSS 4 | Installed |
| UI Components | shadcn/ui (Radix) | Installed |
| Database | Prisma + PostgreSQL | Template ready |
| Auth | NextAuth.js | Template ready |
| Email | Resend | Template ready |
| Storage | Vercel Blob | Template ready |
| Animations | Framer Motion | Installed |

**Decision needed?** See individual `/docs/services/*.md` files for setup guidance.

---

## Common Workflows

### Adding a New Feature

1. Create spec in `/docs/features/feature-name.md`
2. Implement the feature
3. Run `/update-rollout` to sync progress
4. Run `/update-client` to notify client

### Setting Up a New Service

1. Read `/docs/services/service-name.md`
2. Follow the decision prompts
3. Add credentials to `.env`
4. Update `/docs/handoff.md` with account info

### Deploying Changes

```bash
git add . && git commit -m "feat: description"
git push origin main
# Vercel auto-deploys from main
```

---

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/update-client` | Generate client update message |
| `/update-rollout` | Sync rollout.md, progress.md, changelog.md |

---

## Links

- **Progress Tracker:** `/rollout` (public page)
- **Design Patterns:** https://hashbuilds.com/patterns
- **Starter Templates:** https://hashbuilds.com/claude-code-starter

---

## Getting Help

**Stuck on a decision?** Each `/docs/services/*.md` file includes:
- What this service does
- When you need it
- Recommended providers
- Setup instructions
- Decision prompts for opinionated choices

**Need a feature spec?** Copy the template from `/docs/features/README.md`

---

_Template by [HashBuilds](https://hashbuilds.com) | Built for Claude Code_
