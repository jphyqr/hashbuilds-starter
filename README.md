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

1. **Read claude.md** - Understand the project structure
2. **Fill out docs/01-project-origin.md** - Document what you're building
3. **Fill out docs/02-business-context.md** - Define business model
4. **Configure docs/03-design-system.md** - Set up your aesthetic
5. **Follow docs/services/** - Set up database, email, auth
6. **Start building!**

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/setup` | Guided initial project setup (database, auth, email) |
| `/check-progress` | Scan project and show current status |
| `/create-spec [name]` | Create detailed feature specification |
| `/implement-spec [name]` | Build feature from spec |
| `/new-feature [name]` | Quick feature or redirect to spec |
| `/add-seo` | Set up Long-Tail SEO system |
| `/deploy` | Guide deployment to Vercel |
| `/end-session` | Wrap up session and log progress |
| `/update-rollout` | Sync progress documentation |
| `/update-client` | Generate client update message |

## Session Start Hook

When you start a new Claude Code session, a hook automatically scans the project and shows:
- Which docs are filled vs empty
- Which services are configured
- Feature spec status
- Last session notes
- Suggested next step

This means Claude always knows where the project is at, no manual context needed.

## Development Workflow

### Spec-First Development

For complex features, use the spec-first workflow:

```bash
# 1. Create a spec
/create-spec user-authentication

# 2. Review and refine the spec in /docs/product/user-authentication.md

# 3. Implement from the spec
/implement-spec user-authentication
```

### Quick Features

For simple features (< 1 hour):

```bash
/new-feature add-contact-form
```

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
