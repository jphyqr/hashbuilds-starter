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
├── CLAUDE.md              # Start here - project command center
├── docs/                  # Developer documentation
│   ├── PROJECT_ORIGIN.md  # Static project brief
│   ├── BUSINESS_CONTEXT.md # Business model
│   ├── SETUP_CHECKLIST.md # First-time setup guide
│   └── services/          # Service configuration guides
├── deliverables/          # Client-facing documentation
│   └── ROLLOUT.md         # Progress tracker (powers /rollout)
├── .claude/commands/      # Claude Code slash commands
├── app/                   # Next.js app directory
├── components/ui/         # shadcn/ui components
├── lib/                   # Utilities and helpers
└── prisma/               # Database schema
```

## Setup Guide

1. **Read CLAUDE.md** - Understand the project structure
2. **Fill out docs/PROJECT_ORIGIN.md** - Document what you're building
3. **Follow docs/SETUP_CHECKLIST.md** - Set up database, email, auth
4. **Start building!**

## Included Slash Commands

| Command | Purpose |
|---------|---------|
| `/update-rollout` | Sync progress documentation |
| `/update-client` | Generate client update message |

## Documentation

Each service has its own setup guide in `/docs/services/`:

- **DATABASE.md** - PostgreSQL setup (Neon recommended)
- **AUTH.md** - NextAuth configuration
- **EMAIL.md** - Resend setup
- **STORAGE.md** - File uploads
- **PAYMENTS.md** - Stripe integration
- **ANALYTICS.md** - Analytics setup

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
