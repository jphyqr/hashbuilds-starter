# 06-auth-system.md - Authentication & Authorization

<!--
PROMPT: Auth setup depends on your needs. Ask me:

1. What needs to be protected?
   - Admin dashboard only → Simple admin auth
   - User accounts → Full user auth system
   - API routes → API key or JWT tokens

2. What auth provider do you want?
   - Email/password (magic links or credentials)
   - OAuth (Google, GitHub, etc.)
   - Both email and OAuth

3. What roles do you need?
   - Single role (admin) → Simple boolean check
   - Multiple roles (admin, user, moderator) → Role-based access
   - Permissions-based → Fine-grained access control

4. What's your database?
   - PostgreSQL/MySQL → Prisma adapter
   - MongoDB → MongoDB adapter
   - No database → JWT only (stateless)

After you answer, I'll set up the auth system with:
- NextAuth.js configuration
- Prisma models (if using database)
- Protected route middleware
- Role-based layouts
- Auth helper functions
-->

---

## Auth Decisions (Fill This First)

Before implementing auth, answer these questions. Claude Code will use these to configure the system.

| Decision | Options | Your Choice |
|----------|---------|-------------|
| **What needs protection?** | Admin only / User accounts / API routes | _______________ |
| **Auth provider(s)?** | Magic link / OAuth (Google, GitHub) / Both | _______________ |
| **Roles needed?** | Single (admin) / Multiple (admin, user, team) / Permissions-based | _______________ |
| **Session strategy?** | Database (recommended) / JWT only | _______________ |
| **Who can sign up?** | Anyone / Invite only / Waitlist | _______________ |

### Route Protection Plan

| Route Pattern | Who Can Access | Redirect If Unauthorized |
|--------------|----------------|--------------------------|
| `/admin/*` | _______________ | _______________ |
| `/dashboard/*` | _______________ | _______________ |
| `/api/admin/*` | _______________ | _______________ |
| `/api/*` | _______________ | _______________ |
| `/*` (public) | Everyone | N/A |

### Role Definitions

| Role | Description | Example Users |
|------|-------------|---------------|
| `ADMIN` | _______________ | _______________ |
| `TEAM` | _______________ | _______________ |
| `USER` | _______________ | _______________ |

> **Note:** Fill out the tables above first. The implementation guide below shows how to build what you've decided.

---

## Overview

This guide covers setting up authentication with NextAuth.js (Auth.js) in Next.js 14 App Router.

---

## Quick Start

### 1. Install Dependencies

```bash
pnpm add next-auth @auth/prisma-adapter
pnpm add -D @types/bcryptjs bcryptjs
```

### 2. Environment Variables

```env
# .env.local
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="generate-with-openssl-rand-base64-32"

# OAuth Providers (optional)
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GITHUB_ID=""
GITHUB_SECRET=""

# Email Provider (optional)
EMAIL_SERVER_HOST=""
EMAIL_SERVER_PORT=""
EMAIL_SERVER_USER=""
EMAIL_SERVER_PASSWORD=""
EMAIL_FROM=""
```

Generate secret: `openssl rand -base64 32`

---

## Database Models (Prisma)

Add to `prisma/schema.prisma`:

```prisma
model User {
  id            String    @id @default(cuid())
  name          String?
  email         String?   @unique
  emailVerified DateTime?
  image         String?
  role          String    @default("user") // "user" | "admin" | "moderator"
  accounts      Account[]
  sessions      Session[]
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
}

model Account {
  id                String  @id @default(cuid())
  userId            String
  type              String
  provider          String
  providerAccountId String
  refresh_token     String? @db.Text
  access_token      String? @db.Text
  expires_at        Int?
  token_type        String?
  scope             String?
  id_token          String? @db.Text
  session_state     String?
  user              User    @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerAccountId])
}

model Session {
  id           String   @id @default(cuid())
  sessionToken String   @unique
  userId       String
  expires      DateTime
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model VerificationToken {
  identifier String
  token      String   @unique
  expires    DateTime

  @@unique([identifier, token])
}
```

Run migration:
```bash
pnpm prisma migrate dev --name add-auth
```

---

## NextAuth Configuration

### `lib/auth.ts`

```typescript
import { PrismaAdapter } from "@auth/prisma-adapter"
import { type NextAuthOptions } from "next-auth"
import GoogleProvider from "next-auth/providers/google"
import GitHubProvider from "next-auth/providers/github"
import EmailProvider from "next-auth/providers/email"
import { db } from "@/lib/db"

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(db),
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/auth/signin",
    error: "/auth/error",
    verifyRequest: "/auth/verify",
  },
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
    GitHubProvider({
      clientId: process.env.GITHUB_ID!,
      clientSecret: process.env.GITHUB_SECRET!,
    }),
    EmailProvider({
      server: {
        host: process.env.EMAIL_SERVER_HOST,
        port: process.env.EMAIL_SERVER_PORT,
        auth: {
          user: process.env.EMAIL_SERVER_USER,
          pass: process.env.EMAIL_SERVER_PASSWORD,
        },
      },
      from: process.env.EMAIL_FROM,
    }),
  ],
  callbacks: {
    async session({ session, token }) {
      if (token && session.user) {
        session.user.id = token.sub!
        session.user.role = token.role as string
      }
      return session
    },
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role
      }
      return token
    },
  },
}
```

### `app/api/auth/[...nextauth]/route.ts`

```typescript
import NextAuth from "next-auth"
import { authOptions } from "@/lib/auth"

const handler = NextAuth(authOptions)

export { handler as GET, handler as POST }
```

---

## Type Extensions

### `types/next-auth.d.ts`

```typescript
import { DefaultSession, DefaultUser } from "next-auth"
import { DefaultJWT } from "next-auth/jwt"

declare module "next-auth" {
  interface Session {
    user: {
      id: string
      role: string
    } & DefaultSession["user"]
  }

  interface User extends DefaultUser {
    role: string
  }
}

declare module "next-auth/jwt" {
  interface JWT extends DefaultJWT {
    role: string
  }
}
```

---

## Auth Helper Functions

### `lib/auth-helpers.ts`

```typescript
import { getServerSession } from "next-auth"
import { redirect } from "next/navigation"
import { authOptions } from "@/lib/auth"

// Get current session (server component)
export async function getCurrentUser() {
  const session = await getServerSession(authOptions)
  return session?.user
}

// Require authentication
export async function requireAuth() {
  const user = await getCurrentUser()
  if (!user) {
    redirect("/auth/signin")
  }
  return user
}

// Require specific role
export async function requireRole(role: string) {
  const user = await requireAuth()
  if (user.role !== role) {
    redirect("/403")
  }
  return user
}

// Require admin
export async function requireAdmin() {
  return requireRole("admin")
}

// Check if user has role (without redirect)
export async function hasRole(role: string) {
  const user = await getCurrentUser()
  return user?.role === role
}

// Check if user is admin
export async function isAdmin() {
  return hasRole("admin")
}
```

---

## Protected Routes

### Route Group Layout: `app/(auth)/layout.tsx`

```tsx
import { requireAuth } from "@/lib/auth-helpers"

export default async function AuthLayout({
  children,
}: {
  children: React.ReactNode
}) {
  await requireAuth()

  return <>{children}</>
}
```

### Admin Layout: `app/(admin)/layout.tsx`

```tsx
import { requireAdmin } from "@/lib/auth-helpers"

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  await requireAdmin()

  return (
    <div className="min-h-screen bg-gray-50">
      <AdminNav />
      <main className="container mx-auto py-8">
        {children}
      </main>
    </div>
  )
}
```

---

## Middleware Protection

### `middleware.ts`

```typescript
import { withAuth } from "next-auth/middleware"
import { NextResponse } from "next/server"

export default withAuth(
  function middleware(req) {
    const token = req.nextauth.token
    const isAdmin = token?.role === "admin"
    const isAdminRoute = req.nextUrl.pathname.startsWith("/admin")

    if (isAdminRoute && !isAdmin) {
      return NextResponse.redirect(new URL("/403", req.url))
    }

    return NextResponse.next()
  },
  {
    callbacks: {
      authorized: ({ token }) => !!token,
    },
  }
)

export const config = {
  matcher: [
    "/dashboard/:path*",
    "/admin/:path*",
    "/settings/:path*",
  ],
}
```

---

## Auth UI Components

### Sign In Button: `components/auth/SignInButton.tsx`

```tsx
"use client"

import { signIn } from "next-auth/react"
import { Button } from "@/components/ui/button"

export function SignInButton() {
  return (
    <Button onClick={() => signIn()}>
      Sign In
    </Button>
  )
}
```

### Sign Out Button: `components/auth/SignOutButton.tsx`

```tsx
"use client"

import { signOut } from "next-auth/react"
import { Button } from "@/components/ui/button"

export function SignOutButton() {
  return (
    <Button variant="ghost" onClick={() => signOut()}>
      Sign Out
    </Button>
  )
}
```

### User Menu: `components/auth/UserMenu.tsx`

```tsx
"use client"

import { useSession } from "next-auth/react"
import { SignInButton } from "./SignInButton"
import { SignOutButton } from "./SignOutButton"

export function UserMenu() {
  const { data: session, status } = useSession()

  if (status === "loading") {
    return <div className="h-8 w-8 animate-pulse bg-gray-200 rounded-full" />
  }

  if (!session) {
    return <SignInButton />
  }

  return (
    <div className="flex items-center gap-4">
      <span className="text-sm">{session.user.name}</span>
      <SignOutButton />
    </div>
  )
}
```

---

## Session Provider

### `app/providers.tsx`

```tsx
"use client"

import { SessionProvider } from "next-auth/react"

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <SessionProvider>
      {children}
    </SessionProvider>
  )
}
```

### `app/layout.tsx`

```tsx
import { Providers } from "./providers"

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
```

---

## Auth Pages

### Sign In: `app/auth/signin/page.tsx`

```tsx
import { getProviders } from "next-auth/react"
import { SignInForm } from "./SignInForm"

export default async function SignInPage() {
  const providers = await getProviders()

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md w-full space-y-8 p-8">
        <h1 className="text-2xl font-bold text-center">Sign In</h1>
        <SignInForm providers={providers} />
      </div>
    </div>
  )
}
```

### Verify Request: `app/auth/verify/page.tsx`

```tsx
export default function VerifyPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md text-center space-y-4">
        <h1 className="text-2xl font-bold">Check your email</h1>
        <p className="text-muted-foreground">
          A sign in link has been sent to your email address.
        </p>
      </div>
    </div>
  )
}
```

### Error Page: `app/auth/error/page.tsx`

```tsx
"use client"

import { useSearchParams } from "next/navigation"

export default function AuthErrorPage() {
  const searchParams = useSearchParams()
  const error = searchParams.get("error")

  const errorMessages: Record<string, string> = {
    Configuration: "Server configuration error.",
    AccessDenied: "Access denied.",
    Verification: "Token expired or already used.",
    Default: "An error occurred.",
  }

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md text-center space-y-4">
        <h1 className="text-2xl font-bold text-red-600">
          Authentication Error
        </h1>
        <p>{errorMessages[error || "Default"]}</p>
      </div>
    </div>
  )
}
```

---

## API Route Protection

### Protected API Route

```typescript
// app/api/protected/route.ts
import { getServerSession } from "next-auth"
import { NextResponse } from "next/server"
import { authOptions } from "@/lib/auth"

export async function GET() {
  const session = await getServerSession(authOptions)

  if (!session) {
    return NextResponse.json(
      { error: "Unauthorized" },
      { status: 401 }
    )
  }

  return NextResponse.json({ data: "Protected data" })
}
```

### Admin-Only API Route

```typescript
// app/api/admin/route.ts
import { getServerSession } from "next-auth"
import { NextResponse } from "next/server"
import { authOptions } from "@/lib/auth"

export async function GET() {
  const session = await getServerSession(authOptions)

  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  if (session.user.role !== "admin") {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 })
  }

  return NextResponse.json({ data: "Admin data" })
}
```

---

## Common Patterns

### Check Auth in Server Component

```tsx
import { getCurrentUser } from "@/lib/auth-helpers"

export default async function ProfilePage() {
  const user = await getCurrentUser()

  if (!user) {
    return <SignInPrompt />
  }

  return <UserProfile user={user} />
}
```

### Conditional UI Based on Role

```tsx
import { getCurrentUser } from "@/lib/auth-helpers"

export default async function Navigation() {
  const user = await getCurrentUser()

  return (
    <nav>
      <Link href="/">Home</Link>
      {user && <Link href="/dashboard">Dashboard</Link>}
      {user?.role === "admin" && <Link href="/admin">Admin</Link>}
    </nav>
  )
}
```

---

## Security Checklist

- [ ] `NEXTAUTH_SECRET` is set and secure (32+ chars)
- [ ] `NEXTAUTH_URL` matches your deployment URL
- [ ] OAuth callback URLs configured in provider dashboards
- [ ] CSRF protection enabled (default in NextAuth)
- [ ] Session expiry configured appropriately
- [ ] Rate limiting on auth endpoints
- [ ] Secure cookies in production (automatic with HTTPS)
- [ ] No sensitive data in JWT payload

---

_Auth system evolves with your needs. Start simple, add complexity as required._
