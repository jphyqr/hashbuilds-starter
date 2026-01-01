# 08-deployment.md - Production Deployment

<!--
PROMPT: Deployment is the final step. Ask me:

1. Where do you want to deploy?
   - Vercel (recommended - zero config for Next.js)
   - Railway (simple, good for full-stack)
   - Render (alternative to Railway)
   - AWS/GCP (complex, for enterprise)

2. Do you have a custom domain? (e.g., yourdomain.com)

3. Have you created a Vercel account? (If not, go to vercel.com now)

4. Have you connected your GitHub repo to Vercel?

5. Do you have production environment variables ready?
   - Production DATABASE_URL
   - Production NEXTAUTH_SECRET
   - Production API keys (not test keys)

After you answer, I'll guide you through the deployment process.
-->

---

## What It Does

Hosts your application on the internet. Makes it accessible to real users.

---

## When You Need It

**At launch.** After your MVP is built and tested locally.

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Where do you want to deploy?"
>
> | Platform | Best For | Pricing |
> |----------|----------|---------|
> | **Vercel** | Next.js apps, zero config | Free tier, then $20/mo |
> | **Railway** | Full-stack, databases included | $5/mo + usage |
> | **Render** | Alternative to Railway | Free tier, then $7/mo |
> | **Fly.io** | Edge deployment, containers | Free tier, then usage |
>
> **Our default recommendation: Vercel**
> - Best Next.js support (they created it)
> - Zero configuration needed
> - Automatic deployments on git push
> - Free SSL certificates
> - Global CDN

---

## Recommended Setup: Vercel

### Step 1: Prerequisites

Before deploying, ensure:

- [ ] Local build passes: `pnpm build`
- [ ] All env vars documented
- [ ] Git repo pushed to GitHub
- [ ] Database is production-ready (not local)

### Step 2: Create Vercel Account

1. Go to [vercel.com](https://vercel.com)
2. Sign up with GitHub (recommended for easy repo connection)
3. Complete onboarding

### Step 3: Import Project

1. Click "Add New Project"
2. Select "Import Git Repository"
3. Choose your repository
4. Vercel auto-detects Next.js

### Step 4: Configure Build Settings

Vercel usually auto-detects correctly:

| Setting | Value |
|---------|-------|
| Framework | Next.js |
| Root Directory | `./` |
| Build Command | `pnpm build` or `npm run build` |
| Output Directory | `.next` |
| Install Command | `pnpm install` |

### Step 5: Add Environment Variables

**Critical:** Add ALL env vars from `.env` with production values.

Go to Project Settings → Environment Variables:

```env
# Database (PRODUCTION values from Neon)
DATABASE_URL="postgres://user:pass@ep-xxx-pooler.region.aws.neon.tech/db?sslmode=require"
DATABASE_URL_UNPOOLED="postgres://user:pass@ep-xxx.region.aws.neon.tech/db?sslmode=require"

# Auth
NEXTAUTH_URL="https://your-project.vercel.app"
NEXTAUTH_SECRET="production-secret-here"

# Email (Resend - same API key works in production)
RESEND_API_KEY="re_xxx"
EMAIL_FROM="noreply@yourdomain.com"
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD="re_xxx"

# Payments (LIVE keys, not test)
STRIPE_SECRET_KEY="sk_live_xxx"
STRIPE_WEBHOOK_SECRET="whsec_xxx"
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_live_xxx"

# Storage
BLOB_READ_WRITE_TOKEN="vercel_blob_xxx"

# Cron (if using scheduled jobs)
CRON_SECRET="random-secret-for-cron"
```

**Environment Scopes:**
- Production: Live site
- Preview: Pull request previews
- Development: `vercel dev` locally

### Step 6: Deploy

Click "Deploy" and wait for:
1. Install dependencies
2. Build application
3. Deploy to CDN

First deploy takes 2-5 minutes.

### Step 7: Test Production

After deploy completes:

1. Visit deployment URL
2. Test critical paths:
   - [ ] Homepage loads
   - [ ] Sign-in works
   - [ ] Magic link arrives
   - [ ] Protected routes work
   - [ ] Database queries work

---

## Custom Domain

### Add Domain to Vercel

1. Go to Project → Settings → Domains
2. Add your domain (e.g., `yourdomain.com`)
3. Also add `www.yourdomain.com` (redirects to apex)

### Configure DNS

Add these records at your domain registrar:

| Type | Name | Value |
|------|------|-------|
| A | @ | `76.76.21.21` |
| CNAME | www | `cname.vercel-dns.com` |

**OR** use nameservers (recommended for Vercel):
- `ns1.vercel-dns.com`
- `ns2.vercel-dns.com`

### Wait for SSL

Vercel automatically provisions SSL certificate (5-30 minutes).

### Update NEXTAUTH_URL

After domain is live, update in Vercel:
```env
NEXTAUTH_URL="https://yourdomain.com"
```

---

## Database Migrations

### Production Migrations

Never run `prisma migrate dev` in production. Use:

```bash
# Run migrations against production
DATABASE_URL="production-url" pnpm prisma migrate deploy
```

### Safe Migration Pattern

1. Add nullable fields first
2. Deploy
3. Backfill data
4. Make fields required
5. Deploy again

---

## Continuous Deployment

After initial setup, Vercel deploys automatically:

```bash
git add .
git commit -m "feat: new feature"
git push origin main
```

Vercel will:
- Detect the push
- Run build
- Deploy if successful
- Keep previous version if build fails

### Preview Deployments

Pull requests get automatic preview URLs:
- `your-pr-name-projectname.vercel.app`
- Share with team for review

---

## Environment Variables

```env
# Required for production
DATABASE_URL="postgres://..."
DATABASE_URL_UNPOOLED="postgres://..."
NEXTAUTH_URL="https://yourdomain.com"
NEXTAUTH_SECRET="production-secret"
RESEND_API_KEY="re_xxx"
EMAIL_FROM="noreply@yourdomain.com"
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD="re_xxx"

# Optional
STRIPE_SECRET_KEY="sk_live_xxx"
STRIPE_WEBHOOK_SECRET="whsec_xxx"
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_live_xxx"
BLOB_READ_WRITE_TOKEN="vercel_blob_xxx"
CRON_SECRET="xxx"
```

---

## Vercel Cron Jobs

For scheduled tasks (daily SEO generation, etc.):

1. Create `vercel.json`:
```json
{
  "crons": [
    {
      "path": "/api/cron/daily-content",
      "schedule": "0 2 * * *"
    }
  ]
}
```

2. Add `CRON_SECRET` to env vars
3. Protect endpoint:
```typescript
export async function GET(request: Request) {
  const authHeader = request.headers.get('authorization')
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return new Response('Unauthorized', { status: 401 })
  }
  // ... cron logic
}
```

---

## Monitoring

### Vercel Dashboard

- **Deployments**: Build history, rollback
- **Analytics**: Traffic, performance
- **Logs**: Real-time function logs
- **Speed Insights**: Core Web Vitals

### Error Tracking (Optional)

Add Sentry for error tracking:
```bash
pnpm add @sentry/nextjs
```

---

## Common Issues

### Build Fails

- Check Vercel build logs
- Run `pnpm build` locally to reproduce
- Common: TypeScript errors, missing env vars

### 500 Errors

- Check Vercel → Logs
- Usually: Database connection or missing env var
- Verify production DATABASE_URL works

### Auth Redirect Issues

- Ensure NEXTAUTH_URL matches production domain
- Check cookies work (same-site settings)

### Database Timeouts

- Use pooled connection for queries
- Increase timeout in Prisma schema:
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  relationMode = "prisma"
}
```

### "Module not found" in Production

- Dependency in devDependencies that should be in dependencies
- Case sensitivity issues (Mac vs Linux)

---

## Rollback

If a deployment breaks:

1. Go to Vercel → Deployments
2. Find last working deployment
3. Click `...` → "Promote to Production"

Or revert git commit:
```bash
git revert HEAD
git push
```

---

## Status

| Item | Status |
|------|--------|
| Vercel account created | [ ] |
| Project imported | [ ] |
| Env vars added | [ ] |
| First deploy successful | [ ] |
| Custom domain added | [ ] |
| SSL working | [ ] |
| All features tested | [ ] |
| Added to HANDOFF.md | [ ] |

---

_Last updated: [DATE]_
