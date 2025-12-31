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
│   ├── project-origin.md  # Static project brief
│   ├── business-context.md # Business model (CEO layer)
│   ├── setup-checklist.md # First-time setup guide
│   ├── business/          # Deep-dive business docs
│   └── services/          # Service configuration guides
├── deliverables/          # Client-facing documentation
│   └── rollout.md         # Progress tracker (powers /rollout)
├── .claude/commands/      # Claude Code slash commands
├── app/                   # Next.js app directory
├── components/ui/         # shadcn/ui components
├── lib/                   # Utilities and helpers
└── prisma/               # Database schema
```

## Setup Guide

1. **Read claude.md** - Understand the project structure
2. **Fill out docs/project-origin.md** - Document what you're building
3. **Follow docs/setup-checklist.md** - Set up database, email, auth
4. **Start building!**

## Included Slash Commands

| Command | Purpose |
|---------|---------|
| `/update-rollout` | Sync progress documentation |
| `/update-client` | Generate client update message |

## Documentation

Each service has its own setup guide in `/docs/services/`:

- **database.md** - PostgreSQL setup (Neon recommended)
- **auth.md** - NextAuth configuration
- **email.md** - Resend setup
- **storage.md** - File uploads
- **payments.md** - Stripe integration
- **analytics.md** - Analytics setup

## Why This Template?

Built from experience building 50+ client projects with Claude Code:

- **Organized context** - Claude knows where everything is
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
