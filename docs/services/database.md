# DATABASE.md - PostgreSQL Configuration

---

## What It Does

The database stores all application data: users, content, relationships, configurations.

---

## When You Need It

**Always.** Every non-trivial app needs persistent data storage.

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Which database provider do you want to use?"
>
> | Provider | Best For | Pricing |
> |----------|----------|---------|
> | **Neon** | Serverless, auto-scaling, branching | Free tier, then usage-based |
> | **Supabase** | Postgres + Auth + Storage bundle | Free tier, then $25/mo |
> | **PlanetScale** | MySQL, branching, no foreign keys | Free tier, then $29/mo |
> | **Railway** | Simple, predictable pricing | $5/mo + usage |
> | **Vercel Postgres** | Tight Vercel integration | $0.10/GB + compute |
>
> **Our default recommendation: Neon**
> - Best free tier (10GB storage, unlimited databases)
> - Serverless = no cold starts
> - Database branching for safe migrations
> - Works great with Prisma

---

## Recommended Setup: Neon

### Step 1: Create Neon Account

1. Go to [neon.tech](https://neon.tech)
2. Sign up (GitHub OAuth recommended)
3. Create new project (name it after your app)
4. Select region closest to your users (us-west-2 for West Coast)

### Step 2: Get Connection Strings

Neon provides two connection strings:

| Type | Use For | Example |
|------|---------|---------|
| **Pooled** | Application queries (via pgbouncer) | `postgres://user:pass@ep-xxx.us-west-2.aws.neon.tech/db?sslmode=require` |
| **Unpooled** | Migrations, Prisma Studio | `postgres://user:pass@ep-xxx.us-west-2.aws.neon.tech/db?sslmode=require` (direct) |

### Step 3: Configure Prisma

Update `prisma/schema.prisma`:

```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DATABASE_URL_UNPOOLED")
}
```

### Step 4: Add Environment Variables

Add to `.env`:

```env
# Database (Neon PostgreSQL)
DATABASE_URL="postgres://user:pass@ep-xxx-pooler.us-west-2.aws.neon.tech/neondb?sslmode=require"
DATABASE_URL_UNPOOLED="postgres://user:pass@ep-xxx.us-west-2.aws.neon.tech/neondb?sslmode=require"
```

### Step 5: Initialize Database

```bash
# Generate Prisma client
pnpm prisma generate

# Push schema to database (for new projects)
pnpm prisma db push

# Or create migration (for existing projects)
pnpm prisma migrate dev --name init
```

---

## Environment Variables

```env
# Required
DATABASE_URL="postgres://..."           # Pooled connection (for queries)
DATABASE_URL_UNPOOLED="postgres://..."  # Direct connection (for migrations)
```

---

## Testing

```bash
# Open Prisma Studio to browse data
pnpm prisma studio

# Or create a test API route
# app/api/test/database/route.ts
```

```typescript
import { db } from '@/lib/db'
import { NextResponse } from 'next/server'

export async function GET() {
  try {
    // Try a simple query
    const result = await db.$queryRaw`SELECT 1 as test`
    return NextResponse.json({ status: 'connected', result })
  } catch (error) {
    return NextResponse.json({ status: 'error', error: String(error) }, { status: 500 })
  }
}
```

---

## Common Issues

### "Can't reach database server"
- Check DATABASE_URL is correct
- Ensure Neon project is awake (free tier sleeps after 5 min inactivity)
- Verify IP is not blocked (Neon allows all IPs by default)

### "Prepared statement already exists"
- You're using pooled connection for migrations
- Use `DATABASE_URL_UNPOOLED` for `prisma migrate`

### "Too many connections"
- Use pooled connection string
- Check for connection leaks (ensure `db.$disconnect()` in serverless)

---

## Migration Safety

```
CRITICAL RULES:
1. NEVER run `prisma migrate reset` in production
2. NEVER use `--force-reset` flags
3. Add nullable fields first, then make required later
4. Always backup before major migrations
```

**Safe migration pattern:**
```prisma
// Step 1: Add nullable field
model User {
  newField String?  // nullable first
}

// Step 2: Deploy, seed data

// Step 3: Make required
model User {
  newField String   // now required
}
```

---

## Status

| Item | Status |
|------|--------|
| Provider chosen | [ ] |
| Account created | [ ] |
| Connection string added | [ ] |
| Schema pushed | [ ] |
| Test query works | [ ] |
| Added to HANDOFF.md | [ ] |

---

_Last updated: [DATE]_
