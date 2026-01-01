# hashbuilds-starter

A production-ready Next.js starter template optimized for Claude Code development. Built by [HashBuilds](https://hashbuilds.com).

## Features

- **Next.js 15** - App Router, React 19, TypeScript
- **Tailwind CSS 4** - Utility-first styling
- **shadcn/ui** - Beautiful, accessible components
- **Prisma** - Type-safe database ORM
- **NextAuth.js** - Authentication (magic link ready)
- **Resend** - Transactional email
- **Framer Motion** - Animations
- **Vercel Analytics** - Built-in analytics

## Quick Start

```bash
# Clone the template
git clone https://github.com/jphyqr/hashbuilds-starter.git my-project
cd my-project

# Remove git history and start fresh
rm -rf .git
git init

# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env

# Start development
pnpm dev
```

## Project Structure

```
├── claude.md              # Start here - project command center
├── docs/                  # Developer documentation
│   ├── 01-project-origin.md   # Static project brief
│   ├── 02-business-context.md # Business model (CEO layer)
│   ├── 03-design-system.md    # Colors, fonts, aesthetic
│   ├── 04-tech-stack.md       # Architecture reference
│   ├── 05-coding-standards.md # Coding conventions
│   ├── 06-auth-system.md      # Auth setup guide
│   ├── 07-integration-test.md # Testing strategy
│   ├── business/              # CEO strategy layer
│   ├── product/               # Feature specifications (VP Product)
│   ├── services/              # Service configuration (DevOps)
│   └── gtm/                   # Go-to-market (Growth)
├── deliverables/          # Client-facing documentation
│   └── rollout.md             # Progress tracker
├── .claude/
│   ├── commands/              # Slash commands
│   ├── hooks/                 # Automation hooks
│   └── settings.json          # Hook configuration
├── app/                   # Next.js app directory
├── components/ui/         # shadcn/ui components
├── lib/                   # Utilities and helpers
└── prisma/               # Database schema
```

## Setup Guide

**New here?** Run `/help` to get guided to the right starting point based on your situation.

**Paths:**
- **Full guided tour** → `/help` (path A)
- **Tech-first** → `/setup` (just database, auth, email)
- **Business-first** → Start with `docs/01-project-origin.md`
- **Already know the template** → `/add-idea` or `/check-progress`

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/help` | Smart router - guides to right starting point |
| `/setup` | Guided initial project setup (tech services) |
| `/add-idea [description]` | Capture idea to backlog |
| `/prioritize` | Score and rank all backlog items |
| `/new-feature [name]` | Build feature (routes through backlog) |
| `/create-spec [name]` | Create detailed spec for complex feature |
| `/implement-spec [name]` | Build feature from spec |
| `/check-progress` | Scan project and show current status |
| `/add-seo` | Set up Long-Tail SEO system |
| `/deploy` | Guide deployment to Vercel |
| `/end-session` | Wrap up session and log progress |

## Session Start Hook

When you start a new Claude Code session, a hook automatically scans the project and shows:
- Which docs are filled vs empty
- Which services are configured
- Product backlog status and top priorities
- Feature spec status
- Suggested next step

This means Claude always knows where the project is at, no manual context needed.

## Development Workflow

### Backlog-First Development

All ideas go through the product backlog:

```bash
# 1. Capture an idea
/add-idea user authentication

# 2. Score and prioritize
/prioritize

# 3a. For simple features (S/M size):
/new-feature user-auth

# 3b. For complex features (L size):
/create-spec user-authentication
# Then implement:
/implement-spec user-authentication
```

### Product Setup (Do Once)

Before prioritizing, configure your product strategy:

1. `docs/product/north-star.md` - Define your ONE success metric
2. `docs/product/framework.md` - Choose prioritization method (ICE/RICE/etc)

## Documentation

### Core Docs (docs/)

| File | Purpose |
|------|---------|
| 01-project-origin.md | Client info, brief, timeline |
| 02-business-context.md | Business model, personas |
| 03-design-system.md | Colors, fonts, aesthetic |
| 04-tech-stack.md | Architecture reference |
| 05-coding-standards.md | Coding conventions |
| 06-auth-system.md | Auth setup guide |
| 07-integration-test.md | Testing strategy |

### Service Guides (docs/services/)

- **01-database.md** - PostgreSQL setup (Neon recommended)
- **02-auth.md** - NextAuth configuration
- **03-email.md** - Resend setup
- **04-payments.md** - Stripe integration
- **05-storage.md** - File uploads
- **06-sms.md** - SMS integration
- **07-analytics.md** - Analytics setup
- **08-deployment.md** - Vercel deployment

### GTM Strategies (docs/gtm/)

- **01-long-tail-seo.md** - Auto-generate SEO articles
- **02-json-ld.md** - AI discoverability
- **03-backlinks.md** - Domain authority

## Why This Template?

Built from experience building 50+ client projects with Claude Code:

- **Organized context** - Claude knows where everything is
- **Spec-first workflow** - Better features through specifications
- **Decision prompts** - Guides through opinionated choices
- **Client communication** - Built-in progress tracking
- **Production ready** - Not a toy, ships to real users

## Learn More

- [HashBuilds Patterns](https://hashbuilds.com/patterns) - UI inspiration
- [Claude Code Starter](https://hashbuilds.com/claude-code-starter) - Template guide
- [Next.js Docs](https://nextjs.org/docs) - Framework documentation

## License

MIT - Use freely for any project.

---

Built by [HashBuilds](https://hashbuilds.com)
