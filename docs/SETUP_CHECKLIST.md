# SETUP_CHECKLIST.md - First-Time Project Setup

**Follow this checklist when starting a new project from this template.**

---

## Phase 1: Project Context (30 min)

### 1.1 Fill Out Project Origin

Open [PROJECT_ORIGIN.md](PROJECT_ORIGIN.md) and complete:

- [ ] Project name and domain
- [ ] Client information
- [ ] Original brief (copy client's words)
- [ ] Problem being solved
- [ ] Deal structure (pricing, timeline)
- [ ] Initial scope (MVP features)
- [ ] Out of scope (Phase 2+)

### 1.2 Fill Out Business Context

Open [BUSINESS_CONTEXT.md](BUSINESS_CONTEXT.md) and complete:

- [ ] One-liner description
- [ ] User personas (at least primary user)
- [ ] Core workflows
- [ ] Business model basics
- [ ] Success criteria

### 1.3 Update CLAUDE.md

Open [/CLAUDE.md](/CLAUDE.md) and update:

- [ ] Project name in Quick Start section
- [ ] One-liner in Project Overview
- [ ] Any project-specific rules

---

## Phase 2: Infrastructure (1-2 hours)

### 2.1 Database Setup

Follow [services/DATABASE.md](services/DATABASE.md):

- [ ] Choose provider (Neon recommended)
- [ ] Create account and project
- [ ] Get connection strings
- [ ] Add to `.env`
- [ ] Run `pnpm prisma generate`
- [ ] Run `pnpm prisma db push`
- [ ] Test with Prisma Studio

### 2.2 Email Setup

Follow [services/EMAIL.md](services/EMAIL.md):

- [ ] Choose provider (Resend recommended)
- [ ] Create account
- [ ] Add domain (for production)
- [ ] Verify DNS records
- [ ] Get API key
- [ ] Add to `.env`
- [ ] Send test email

### 2.3 Auth Setup

Follow [services/AUTH.md](services/AUTH.md):

- [ ] Choose auth method (magic link recommended)
- [ ] Configure NextAuth
- [ ] Update Prisma schema with User model
- [ ] Push schema changes
- [ ] Test sign-in flow

---

## Phase 3: Development Environment (30 min)

### 3.1 Verify Local Development

- [ ] Run `pnpm install`
- [ ] Run `pnpm dev`
- [ ] Visit `http://localhost:3000`
- [ ] Verify homepage loads
- [ ] Visit `/rollout` page

### 3.2 Verify Services

- [ ] Database connected (check Prisma Studio)
- [ ] Email working (send test)
- [ ] Auth working (sign in)

---

## Phase 4: Deployment (30 min)

### 4.1 Deploy to Vercel

- [ ] Push to GitHub
- [ ] Connect repo to Vercel
- [ ] Add environment variables in Vercel
- [ ] Deploy
- [ ] Verify production URL works

### 4.2 Production Environment Variables

Add these to Vercel:

```env
# Database
DATABASE_URL=
DATABASE_URL_UNPOOLED=

# Auth
NEXTAUTH_URL=https://yourdomain.com
NEXTAUTH_SECRET=  # Generate new for production

# Email
RESEND_API_KEY=
EMAIL_FROM=

# [Others as needed]
```

---

## Phase 5: Documentation (15 min)

### 5.1 Update HANDOFF.md

- [ ] Document all accounts created
- [ ] Note who owns each account
- [ ] List emails used

### 5.2 Update Rollout Page

- [ ] Mark Phase 1 complete in `/deliverables/ROLLOUT.md`
- [ ] Update any pending items

---

## Quick Reference

### Common Commands

```bash
# Development
pnpm dev                    # Start dev server
pnpm build                  # Build for production
pnpm start                  # Start production server

# Database
pnpm prisma studio          # Browse database
pnpm prisma generate        # Generate Prisma client
pnpm prisma db push         # Push schema changes
pnpm prisma migrate dev     # Create migration

# Deployment
git push origin main        # Auto-deploys to Vercel
```

### Environment File Template

Create `.env` in root:

```env
# Database (get from Neon)
DATABASE_URL=""
DATABASE_URL_UNPOOLED=""

# Auth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET=""  # Generate: openssl rand -base64 32

# Email (get from Resend)
RESEND_API_KEY=""
EMAIL_FROM="noreply@yourdomain.com"
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD=""  # Same as RESEND_API_KEY
```

---

## Troubleshooting

### "Module not found"
```bash
pnpm install
```

### "Database connection failed"
- Check DATABASE_URL format
- Ensure Neon project is active
- Use pooled URL for queries

### "Auth not working"
- Check all EMAIL_* variables
- Verify NEXTAUTH_SECRET is set
- Verify NEXTAUTH_URL matches your URL

### "Build fails on Vercel"
- Check all env vars are in Vercel
- Check build logs for specific error

---

## What's Next?

After setup is complete:

1. **Design System** - Set up colors, typography, components
2. **Feature Development** - Build MVP features
3. **Testing** - Test all workflows
4. **Launch Prep** - Final checks before going live

See [/docs/features/](features/) for feature templates.

---

_Estimated total setup time: 2-4 hours_
