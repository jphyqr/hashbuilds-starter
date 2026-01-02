# claude.md - Project Command Center

<!--
CLAUDE CODE: This is your entry point for new projects.

## New Project Setup (Phases 1-4)

Follow the numbered files in /docs/:
1. Read and fill out 01-project-origin.md (ask the embedded prompt questions)
2. Read and fill out 02-business-context.md (ask the embedded prompt questions)
3. Read and fill out 03-design-system.md (ask the embedded prompt questions)
4. Confirm/customize 04-tech-stack.md
5. Review 05-coding-standards.md (coding conventions)
6. Set up auth using 06-auth-system.md (when needed)
7. Set up testing using 07-integration-test.md

## Services Setup (Phase 5)

Set up services in /docs/services/:
1. 01-database.md → Required
2. 02-auth.md → Required
3. 03-email.md → Usually required (for magic links)
4. 04-payments.md → Optional
5. 05-storage.md → Optional
6. 06-sms.md → Optional
7. 07-analytics.md → Before launch

## Feature Development (Phase 6)

Use the backlog-first workflow for features:
1. /add-idea [description] → Capture idea to backlog
2. /prioritize → Score and rank all ideas
3. Small/Medium: /new-feature [name] → Build directly
4. Large: /create-spec [name] → Spec first, then /implement-spec

All ideas go through /docs/product/backlog.md (VP of Product role-primed).

**Product Setup (do once):**
1. docs/product/north-star.md → Define your ONE success metric
2. docs/product/framework.md → Choose prioritization method (ICE/RICE/etc)

## GTM (Phase 7 - After MVP is Live)

Set up go-to-market in /docs/gtm/:
1. 01-long-tail-seo.md → Auto-generate SEO articles (TWO-STEP PROCESS)
2. 02-json-ld.md → Get found by AI assistants
3. 03-backlinks.md → Build domain authority

Each file has an embedded PROMPT at the top - ask those questions to the user and fill in the answers.
-->

---

## Quick Start

```bash
pnpm install
pnpm run dev        # Starts on port 3000
```

**First time here?** Run `/help` to get guided to the right starting point.

**Paths:**
- **Full setup** → `/help` (choose path A)
- **Tech-first** → `/setup` (database, auth, email)
- **Business-first** → Start with [docs/01-project-origin.md](docs/01-project-origin.md)
- **Already running** → `/check-progress` or `/add-idea`

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | _[Set in docs/01-project-origin.md]_ |
| **Client** | _[Set in docs/01-project-origin.md]_ |
| **Domain** | _[Set in docs/handoff.md]_ |
| **Status** | Phase 1: Foundation |

**What is this?** _[Set in docs/02-business-context.md]_

---

## Workflow: New Project Setup

Follow the numbered files in order:

### Phase 1: Context (Do First)

| # | File | Purpose |
|---|------|---------|
| 1 | [01-project-origin.md](docs/01-project-origin.md) | Client info, brief, timeline |
| 2 | [02-business-context.md](docs/02-business-context.md) | Business model, personas |
| 3 | [03-design-system.md](docs/03-design-system.md) | Colors, fonts, aesthetic |
| 4 | [04-tech-stack.md](docs/04-tech-stack.md) | Confirm the stack |
| 5 | [05-coding-standards.md](docs/05-coding-standards.md) | Coding conventions |
| 6 | [06-auth-system.md](docs/06-auth-system.md) | Auth setup guide |
| 7 | [07-integration-test.md](docs/07-integration-test.md) | Testing strategy |

### Phase 2: Services (Set Up Infrastructure)

| # | File | Required? |
|---|------|-----------|
| 1 | [services/01-database.md](docs/services/01-database.md) | Yes |
| 2 | [services/02-auth.md](docs/services/02-auth.md) | Yes |
| 3 | [services/03-email.md](docs/services/03-email.md) | Usually |
| 4 | [services/04-payments.md](docs/services/04-payments.md) | Sometimes |
| 5 | [services/05-storage.md](docs/services/05-storage.md) | Sometimes |
| 6 | [services/06-sms.md](docs/services/06-sms.md) | Rarely |
| 7 | [services/07-analytics.md](docs/services/07-analytics.md) | Before launch |
| 8 | [services/08-deployment.md](docs/services/08-deployment.md) | At launch |

### Phase 3: GTM (After MVP is Live)

| # | File | Purpose |
|---|------|---------|
| 1 | [gtm/01-long-tail-seo.md](docs/gtm/01-long-tail-seo.md) | Auto-generate articles |
| 2 | [gtm/02-json-ld.md](docs/gtm/02-json-ld.md) | AI discoverability |
| 3 | [gtm/03-backlinks.md](docs/gtm/03-backlinks.md) | Domain authority |

---

## Directory Map

```
/claude.md                    ← You are here (entry point)

/docs/                        ← Developer documentation
  ├── 01-project-origin.md    ← Static: client, brief, deal
  ├── 02-business-context.md  ← Living: business model, personas
  ├── 03-design-system.md     ← Living: colors, fonts, aesthetic
  ├── 04-tech-stack.md        ← Reference: architecture
  ├── 05-coding-standards.md  ← Coding conventions
  ├── 06-auth-system.md       ← Auth setup guide
  ├── 07-integration-test.md  ← Testing strategy
  ├── handoff.md              ← Account ownership, credentials
  │
  ├── architecture/           ← System architecture (grows with app)
  │   ├── README.md           ← Overview + pattern sync rules
  │   ├── data-model.md       ← Entity relationships, design decisions
  │   ├── api-conventions.md  ← REST patterns, auth, response formats
  │   ├── components.md       ← Component inventory
  │   ├── ui-patterns.md      ← Forms, toasts, errors, loading states
  │   └── code-health.md      ← Tech debt, pattern violations, audits
  │
  ├── business/               ← CEO strategy layer (Role: CEO/Founder)
  │   └── README.md           ← Role-priming + deep-dive templates
  │
  ├── product/                ← Product management (Role: VP of Product)
  │   ├── README.md           ← Role-priming + workflow guide
  │   ├── north-star.md       ← ONE metric that defines success
  │   ├── framework.md        ← Prioritization method (ICE/RICE/etc)
  │   ├── backlog.md          ← ALL ideas with scores (source of truth)
  │   ├── _template.md        ← Blank spec template
  │   └── [feature-name].md   ← Individual specs (L-sized features)
  │
  ├── services/               ← External integrations (Role: DevOps)
  │   ├── README.md           ← Role-priming
  │   ├── 01-database.md
  │   ├── 02-auth.md
  │   ├── 03-email.md
  │   ├── 04-payments.md
  │   ├── 05-storage.md
  │   ├── 06-sms.md
  │   ├── 07-analytics.md
  │   └── 08-deployment.md
  │
  └── gtm/                    ← Go-to-market (Role: Head of Growth)
      ├── README.md           ← Role-priming
      ├── 01-long-tail-seo.md
      ├── 02-json-ld.md
      └── 03-backlinks.md

/prompts/                     ← Large system prompts
  ├── README.md               ← Prompt usage guide
  ├── keyword-research.txt    ← SEO keyword research
  └── long-tail-seo.txt       ← SEO article system

/deliverables/                ← Client-facing documentation
  ├── rollout.md              ← Public progress tracker
  ├── progress.md             ← Completed work log
  ├── changelog.md            ← Release notes
  └── client-update.txt       ← Message to send client

/.claude/commands/            ← Slash commands
  ├── help.md                 ← Smart router (start here)
  ├── setup.md                ← Guided initial project setup
  ├── add-idea.md             ← Capture idea to backlog
  ├── prioritize.md           ← Score and rank backlog
  ├── new-feature.md          ← Quick feature addition
  ├── create-spec.md          ← Create feature specification
  ├── implement-spec.md       ← Build from specification
  ├── check-progress.md       ← Scan and report project status
  ├── add-seo.md              ← Set up SEO system
  ├── deploy.md               ← Deployment guide
  ├── end-session.md          ← Wrap up and log session
  ├── update-client.md        ← Generate client message
  └── update-rollout.md       ← Sync deliverables

/.claude/hooks/               ← Automation hooks
  └── session-start.sh        ← Auto-shows status on new chat

/.claude/settings.json        ← Hook configuration
```

---

## Critical Rules

### Database Safety

```
NEVER run:
- prisma migrate reset
- prisma db push --force-reset
- Any command that drops tables

WHY: We often share dev/prod database.
```

**Safe migration pattern:**
1. Add nullable field first (`field String?`)
2. Deploy, seed data
3. Make required (`field String`) in next migration

### Environment Variables

```
Use ONE .env file only.
Never: .env.local, .env.development, .env.production
```

### Port Convention

Dev server runs on **port 3000**. Change in `package.json` if needed.

---

## Tech Stack

| Layer | Technology | Status |
|-------|------------|--------|
| Framework | Next.js 15 (App Router) | Installed |
| Styling | Tailwind CSS 4 | Installed |
| UI | shadcn/ui (Radix) | Installed |
| Database | Prisma + PostgreSQL | Ready |
| Auth | NextAuth.js | Ready |
| Email | Resend | Ready |
| Storage | Vercel Blob | Ready |
| Animations | Framer Motion | Installed |

---

## Slash Commands

### Product Management
| Command | Purpose |
|---------|---------|
| `/add-idea [description]` | Capture idea to backlog |
| `/prioritize` | Score and rank all backlog items |
| `/new-feature [name]` | Build feature (routes through backlog) |
| `/create-spec [name or #ID]` | Create detailed spec for complex feature |
| `/implement-spec [name]` | Build from existing spec |

### Project Setup & Status
| Command | Purpose |
|---------|---------|
| `/help` | Smart router - guides to right starting point |
| `/setup` | Guided initial project setup (database, auth, email) |
| `/check-progress` | Scan project and show current status |
| `/deploy` | Guide deployment to Vercel |

### Session Management
| Command | Purpose |
|---------|---------|
| `/end-session` | Wrap up session and log progress |
| `/update-client` | Generate client update message |
| `/update-rollout` | Sync deliverables after work |

### Growth
| Command | Purpose |
|---------|---------|
| `/add-seo` | Set up Long-Tail SEO system |

**Note:** A session-start hook automatically shows project status when you start a new chat.

---

## Links

- **Progress Tracker:** `/rollout`
- **Design Patterns:** https://hashbuilds.com/patterns
- **Starter Templates:** https://hashbuilds.com/claude-code-starter

---

_Template by [HashBuilds](https://hashbuilds.com) | Built for Claude Code_
