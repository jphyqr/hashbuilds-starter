# Deploy

Guide deployment to Vercel with environment variables, database, and production checklist.

## Instructions

When the user runs `/deploy`, walk through deployment preparation and execution.

### Pre-Flight Checklist

First, verify the project is ready:

```
🚀 DEPLOYMENT CHECKLIST
=======================

Let me verify your project is ready for deployment...
```

**Check these items:**

1. **Git status clean?**
   ```bash
   git status
   ```
   If uncommitted changes: "Commit your changes first, or they won't be deployed."

2. **Build passes?**
   ```bash
   pnpm build
   ```
   If build fails: Fix errors before deploying.

3. **Environment variables documented?**
   Check `.env` has all required values:
   - DATABASE_URL
   - NEXTAUTH_SECRET
   - NEXTAUTH_URL (will change for production)
   - RESEND_API_KEY
   - EMAIL_FROM

4. **Database migrated?**
   ```bash
   pnpm prisma migrate status
   ```

### Deployment Options

Ask: "How do you want to deploy?"

| Option | Best For | Command |
|--------|----------|---------|
| **Vercel CLI** | Quick, from terminal | `vercel` |
| **Vercel Dashboard** | Visual, first-time setup | vercel.com |
| **Git Push** | CI/CD (after initial setup) | `git push` |

**Recommended for first deploy: Vercel Dashboard**

### First-Time Vercel Setup

If they don't have Vercel set up:

1. **Create Vercel Account**
   - Go to [vercel.com](https://vercel.com)
   - Sign up with GitHub (recommended)

2. **Import Repository**
   - Click "Add New Project"
   - Import from GitHub
   - Select this repository

3. **Configure Project**
   - Framework: Next.js (auto-detected)
   - Root Directory: `./` (default)
   - Build Command: `pnpm build` (or `npm run build`)
   - Install Command: `pnpm install`

4. **Add Environment Variables**

   Go to Project Settings → Environment Variables and add:

   ```
   # Database (use PRODUCTION connection strings from Neon)
   DATABASE_URL=postgres://...
   DATABASE_URL_UNPOOLED=postgres://...

   # Auth
   NEXTAUTH_URL=https://your-domain.vercel.app
   NEXTAUTH_SECRET=your-production-secret

   # Email
   RESEND_API_KEY=re_xxx
   EMAIL_FROM=noreply@yourdomain.com
   EMAIL_SERVER_HOST=smtp.resend.com
   EMAIL_SERVER_PORT=587
   EMAIL_SERVER_USER=resend
   EMAIL_SERVER_PASSWORD=re_xxx

   # Payments (if using)
   STRIPE_SECRET_KEY=sk_live_xxx
   STRIPE_WEBHOOK_SECRET=whsec_xxx
   NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_xxx

   # Storage (if using)
   BLOB_READ_WRITE_TOKEN=vercel_blob_xxx
   ```

   **IMPORTANT:** Use production API keys, not test keys!

5. **Deploy**
   - Click "Deploy"
   - Wait for build to complete
   - Test the deployment URL

### Subsequent Deploys

After initial setup, deploys are automatic on `git push`:

```bash
git add .
git commit -m "feat: new feature"
git push
```

Vercel will automatically:
- Detect the push
- Run the build
- Deploy if successful
- Keep previous version if build fails

### Production Database

**Neon Production Branch:**

1. Go to Neon Dashboard
2. Create a production branch (or use main)
3. Get production connection strings
4. Update Vercel env vars with production URLs

**Run Migrations:**
```bash
# Set production DATABASE_URL temporarily
export DATABASE_URL="postgres://production-url..."
pnpm prisma migrate deploy
```

### Custom Domain

After deployment works:

1. Go to Vercel Project → Settings → Domains
2. Add your domain
3. Update DNS:
   - A record: `76.76.21.21`
   - CNAME: `cname.vercel-dns.com`
4. Wait for SSL certificate (automatic)
5. Update `NEXTAUTH_URL` to your domain

### Post-Deploy Verification

After deploying, verify:

```
✅ DEPLOYMENT VERIFICATION
==========================

Test these items on your production URL:

[ ] Homepage loads
[ ] Sign-in page works
[ ] Magic link email arrives
[ ] Protected routes redirect to sign-in
[ ] API routes respond correctly
[ ] Database queries work
[ ] Payments process (if applicable)
```

### Webhook Setup (If Using Stripe)

1. Go to Stripe Dashboard → Webhooks
2. Add endpoint: `https://your-domain.com/api/webhooks/stripe`
3. Select events: `checkout.session.completed`, `invoice.paid`, etc.
4. Copy webhook signing secret
5. Update `STRIPE_WEBHOOK_SECRET` in Vercel

### Completion

```
🎉 DEPLOYED!
============

Production URL: https://your-project.vercel.app
Custom Domain: https://yourdomain.com (if configured)

Remember:
- Vercel auto-deploys on git push
- Check Vercel dashboard for deployment status
- Monitor logs: Vercel → Project → Logs
- Rollback if needed: Vercel → Deployments → ... → Rollback

Update /docs/HANDOFF.md with:
- Production URL
- Vercel project name
- Any deployment notes
```

### Update Documentation

After successful deploy:
1. Update `/docs/HANDOFF.md` with production URLs
2. Update `/deliverables/progress.md` with deployment date
3. Mark deployment-related items complete

## Troubleshooting

### Build Fails on Vercel
- Check build logs in Vercel dashboard
- Common: Missing env vars, TypeScript errors, dependency issues
- Local build should match: `pnpm build`

### 500 Errors in Production
- Check Vercel Logs
- Likely: Database connection or env var issue
- Verify DATABASE_URL uses production connection string

### Auth Not Working
- Check NEXTAUTH_URL matches production domain
- Verify email env vars are set in Vercel
- Check Resend domain is verified for production

### Prisma "Can't reach database"
- Use pooled connection string for queries
- Ensure Neon project is in same region as Vercel
- Check IP allowlisting (Neon allows all by default)
