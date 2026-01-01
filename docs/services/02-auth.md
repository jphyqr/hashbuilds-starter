# 02-auth.md - Authentication Configuration

<!--
PROMPT: Auth depends on Database being set up. Ask me:

1. How should users authenticate?
   - Email Magic Link (recommended - no passwords, low friction)
   - Email + Password (when users expect passwords)
   - Social OAuth (Google, GitHub - fast onboarding)
   - All of the above

2. What user roles do you need?
   - Single role (all users equal)
   - Admin + User (most common)
   - Custom roles (ADMIN, TEAM, USER)

3. Have you set up Email (03-email.md) yet? (Magic links require email)

4. Do you need any protected routes right away? (e.g., /dashboard, /admin)

After you answer, I'll configure NextAuth with your choices.
-->

---

## What It Does

Handles user sign-up, sign-in, sessions, and access control.

---

## When You Need It

**Almost always.** Skip only if your app is 100% public with no user accounts.

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "How should users authenticate?"
>
> | Method | Best For | Complexity |
> |--------|----------|------------|
> | **Email Magic Link** | Most apps, low friction | Simple |
> | **Email + Password** | When users expect passwords | Medium |
> | **Social OAuth** | Consumer apps, fast onboarding | Medium |
> | **All of the above** | Maximum flexibility | Complex |
>
> **Our default recommendation: Email Magic Link**
> - No passwords to manage
> - Secure (link expires)
> - Works great with Resend
> - Users increasingly expect this

---

## Decision Point 2

> **Claude Code should ask the developer:**
>
> "What user roles do you need?"
>
> | Setup | Use Case |
> |-------|----------|
> | **Single role** | All users are equal |
> | **Admin + User** | Most common (admin manages, users use) |
> | **Custom roles** | Complex permissions (e.g., ADMIN, TEAM, USER) |
>
> **Our default: ADMIN, TEAM, USER**
> - ADMIN: Full access, can manage everything
> - TEAM: Can manage content but not settings
> - USER: Regular end-user

---

## Recommended Setup: NextAuth + Magic Link

### Step 1: Install Dependencies

Already included in starter:
```bash
pnpm add next-auth @auth/prisma-adapter
```

### Step 2: Configure NextAuth

Create `lib/auth.ts`:

```typescript
import { PrismaAdapter } from "@auth/prisma-adapter"
import { NextAuthOptions } from "next-auth"
import EmailProvider from "next-auth/providers/email"
import { db } from "@/lib/db"

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(db),
  providers: [
    EmailProvider({
      server: {
        host: process.env.EMAIL_SERVER_HOST,
        port: Number(process.env.EMAIL_SERVER_PORT),
        auth: {
          user: process.env.EMAIL_SERVER_USER,
          pass: process.env.EMAIL_SERVER_PASSWORD,
        },
      },
      from: process.env.EMAIL_FROM,
    }),
  ],
  callbacks: {
    session: async ({ session, user }) => {
      if (session.user) {
        session.user.id = user.id
        session.user.role = user.role
      }
      return session
    },
  },
  pages: {
    signIn: '/auth/signin',
    verifyRequest: '/auth/verify',
    error: '/auth/error',
  },
}
```

### Step 3: Add API Route

Create `app/api/auth/[...nextauth]/route.ts`:

```typescript
import NextAuth from "next-auth"
import { authOptions } from "@/lib/auth"

const handler = NextAuth(authOptions)
export { handler as GET, handler as POST }
```

### Step 4: Update Prisma Schema

Add to `prisma/schema.prisma`:

```prisma
model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String?
  emailVerified DateTime?
  image         String?
  role          UserRole  @default(USER)
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  accounts      Account[]
  sessions      Session[]
}

model Account {
  id                String  @id @default(cuid())
  userId            String
  type              String
  provider          String
  providerAccountId String
  refresh_token     String?
  access_token      String?
  expires_at        Int?
  token_type        String?
  scope             String?
  id_token          String?
  session_state     String?

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerAccountId])
}

model Session {
  id           String   @id @default(cuid())
  sessionToken String   @unique
  userId       String
  expires      DateTime

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model VerificationToken {
  identifier String
  token      String   @unique
  expires    DateTime

  @@unique([identifier, token])
}

enum UserRole {
  ADMIN
  TEAM
  USER
}
```

### Step 5: Add Environment Variables

```env
# Auth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-here"  # Generate with: openssl rand -base64 32

# Email (for magic links) - see EMAIL.md
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD="re_xxx"
EMAIL_FROM="noreply@yourdomain.com"
```

---

## Environment Variables

```env
# Required
NEXTAUTH_URL="http://localhost:3000"    # Your app URL
NEXTAUTH_SECRET="xxx"                   # Random secret (openssl rand -base64 32)

# For email auth (magic links)
EMAIL_SERVER_HOST="smtp.resend.com"
EMAIL_SERVER_PORT="587"
EMAIL_SERVER_USER="resend"
EMAIL_SERVER_PASSWORD="re_xxx"
EMAIL_FROM="noreply@yourdomain.com"
```

---

## Usage Patterns

### Protect a Page (Server Component)

```typescript
import { getServerSession } from "next-auth"
import { authOptions } from "@/lib/auth"
import { redirect } from "next/navigation"

export default async function ProtectedPage() {
  const session = await getServerSession(authOptions)

  if (!session) {
    redirect('/auth/signin')
  }

  return <div>Welcome, {session.user?.email}</div>
}
```

### Protect an API Route

```typescript
import { getServerSession } from "next-auth"
import { authOptions } from "@/lib/auth"
import { NextResponse } from "next/server"

export async function GET() {
  const session = await getServerSession(authOptions)

  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  return NextResponse.json({ data: 'secret stuff' })
}
```

### Check Role

```typescript
const session = await getServerSession(authOptions)

if (session?.user?.role !== 'ADMIN') {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
}
```

---

## Testing

1. Start dev server: `pnpm dev`
2. Go to `/auth/signin`
3. Enter your email
4. Check email for magic link
5. Click link to complete sign-in

---

## Common Issues

### "Magic link not arriving"
- Check EMAIL.md is configured correctly
- Verify Resend domain is verified
- Check spam folder
- Test with Resend dashboard "Send test email"

### "Session not persisting"
- Check NEXTAUTH_SECRET is set
- Ensure DATABASE_URL is correct
- Verify Prisma schema has Session model

### "Callback URL mismatch"
- Set NEXTAUTH_URL to your actual domain
- In production: NEXTAUTH_URL="https://yourdomain.com"

---

## Status

| Item | Status |
|------|--------|
| Auth method chosen | [ ] |
| User roles defined | [ ] |
| NextAuth configured | [ ] |
| Prisma schema updated | [ ] |
| Email provider connected | [ ] |
| Magic link tested | [ ] |

---

_Last updated: [DATE]_
