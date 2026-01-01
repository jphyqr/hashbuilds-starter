# Setup

Interactive guided setup for new projects. Walks through all foundation services step-by-step.

## Instructions

When the user runs `/setup`, guide them through initial project configuration.

### Pre-Flight Check

First, verify the basics:

```bash
# Check if .env exists
ls -la .env

# Check if dependencies installed
ls -la node_modules
```

If `.env` doesn't exist:
```
First, copy the example environment file:
  cp .env.example .env

Then run this command again.
```

If `node_modules` doesn't exist:
```
First, install dependencies:
  pnpm install

Then run this command again.
```

### Setup Flow

Guide through services in order (each depends on the previous):

```
📋 PROJECT SETUP WIZARD
=======================

We'll configure these services in order:

1. 📚 Database (PostgreSQL via Neon)
2. 🔐 Auth (NextAuth with magic links)
3. 📧 Email (Resend for transactional email)
4. 💳 Payments (Stripe) - optional
5. 📁 Storage (Vercel Blob) - optional

Let's begin!
```

### Step 1: Database

Read the embedded prompt in `/docs/services/01-database.md` and follow it:

1. Ask which provider (recommend Neon)
2. Verify they have an account
3. Get project name and region
4. Help them get connection strings
5. Add to `.env`:
   ```env
   DATABASE_URL="postgres://..."
   DATABASE_URL_UNPOOLED="postgres://..."
   ```
6. Run `pnpm prisma generate` and `pnpm prisma db push`
7. Test with `pnpm prisma studio`

Mark complete when DATABASE_URL is in `.env` and Prisma works.

### Step 2: Auth

Read the embedded prompt in `/docs/services/02-auth.md`:

1. Ask auth method preference (recommend magic link)
2. Ask about user roles (recommend ADMIN, TEAM, USER)
3. Generate NEXTAUTH_SECRET: `openssl rand -base64 32`
4. Add to `.env`:
   ```env
   NEXTAUTH_URL="http://localhost:3000"
   NEXTAUTH_SECRET="generated-secret"
   ```
5. Note: Email config happens in step 3

Mark complete when NEXTAUTH_SECRET is in `.env`.

### Step 3: Email

Read the embedded prompt in `/docs/services/03-email.md`:

1. Ask if they have a custom domain
2. Help create Resend account
3. If custom domain: guide through DNS verification
4. Get API key
5. Add to `.env`:
   ```env
   RESEND_API_KEY="re_xxx"
   EMAIL_FROM="noreply@domain.com"
   EMAIL_SERVER_HOST="smtp.resend.com"
   EMAIL_SERVER_PORT="587"
   EMAIL_SERVER_USER="resend"
   EMAIL_SERVER_PASSWORD="re_xxx"
   ```
6. Test with Resend dashboard "Send test email"

Mark complete when magic link emails work.

### Step 4: Payments (Optional)

Ask: "Does this project need payments? (y/n)"

If yes, read `/docs/services/04-payments.md`:
1. Guide through Stripe account setup
2. Get API keys (test mode first)
3. Add to `.env`:
   ```env
   STRIPE_SECRET_KEY="sk_test_xxx"
   STRIPE_WEBHOOK_SECRET="whsec_xxx"
   NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_xxx"
   ```

If no: Skip, can add later.

### Step 5: Storage (Optional)

Ask: "Does this project need file uploads? (y/n)"

If yes, read `/docs/services/05-storage.md`:
1. Guide through Vercel Blob setup
2. Get token
3. Add to `.env`:
   ```env
   BLOB_READ_WRITE_TOKEN="vercel_blob_xxx"
   ```

If no: Skip, can add later.

### Completion

After all steps:

```
✅ SETUP COMPLETE!
==================

Services configured:
✅ Database (Neon PostgreSQL)
✅ Auth (NextAuth + Magic Link)
✅ Email (Resend)
⬜ Payments (skipped)
⬜ Storage (skipped)

Next steps:
1. Run `pnpm dev` to start the app
2. Test sign-in at http://localhost:3000/auth/signin
3. Create your first feature spec: `/create-spec [name]`

Your .env is configured. Don't forget to:
- Add these to Vercel Environment Variables for deployment
- Never commit .env to git (it's in .gitignore)
```

### Update Documentation

After setup, update:
1. `/docs/HANDOFF.md` - Add credentials section
2. `/deliverables/progress.md` - Log setup completion

## Error Handling

If any step fails:
- Don't panic
- Read the error message
- Check the "Common Issues" section in the relevant service doc
- Offer to help troubleshoot

## Notes

- Always use test/development credentials first
- Production credentials come at deployment time
- Each service doc has embedded prompts - USE THEM
- The order matters: Database → Auth → Email (dependencies)
