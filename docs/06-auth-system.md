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

## Development & Testing

### Seed Users

Create test users for each role. Add to `prisma/seed.ts`:

```typescript
const testUsers = [
  { email: 'user@test.com', name: 'Test User', role: 'USER' },
  { email: 'team@test.com', name: 'Test Team', role: 'TEAM' },
  { email: 'admin@test.com', name: 'Test Admin', role: 'ADMIN' },
]

async function main() {
  for (const user of testUsers) {
    await prisma.user.upsert({
      where: { email: user.email },
      update: {},
      create: user,
    })
  }
  console.log('Seed users created')
}

main()
```

Add to `package.json`:
```json
{
  "prisma": {
    "seed": "tsx prisma/seed.ts"
  }
}
```

Run: `npx prisma db seed`

---

### Dev Sign-In Bypass (Skip Email in Dev)

For rapid testing, bypass email verification in development:

```typescript
// app/api/dev/signin/route.ts
import { db } from "@/lib/db"
import { encode } from "next-auth/jwt"
import { cookies } from "next/headers"

export async function POST(req: Request) {
  if (process.env.NODE_ENV !== 'development') {
    return Response.json({ error: 'Not available' }, { status: 403 })
  }

  const { email } = await req.json()
  const user = await db.user.findUnique({ where: { email } })

  if (!user) {
    return Response.json({ error: 'User not found' }, { status: 404 })
  }

  // Create session token
  const token = await encode({
    token: { sub: user.id, role: user.role, email: user.email, name: user.name },
    secret: process.env.NEXTAUTH_SECRET!,
  })

  // Set session cookie
  cookies().set('next-auth.session-token', token, {
    httpOnly: true,
    secure: false, // dev only
    sameSite: 'lax',
    path: '/',
  })

  return Response.json({ success: true, user })
}
```

---

### Dev Testing Panel

A floating panel for rapid auth testing. Only shows in development.

```tsx
// components/dev/DevTestingPanel.tsx
"use client"

import { useState } from "react"
import { useSession, signOut } from "next-auth/react"
import { useRouter, usePathname } from "next/navigation"
import { cn } from "@/lib/utils"

const TEST_USERS = [
  { email: 'user@test.com', role: 'USER' },
  { email: 'team@test.com', role: 'TEAM' },
  { email: 'admin@test.com', role: 'ADMIN' },
]

const ROUTE_TESTS = [
  { name: 'Home', path: '/', access: 'public' },
  { name: 'Sign In', path: '/auth/signin', access: 'public' },
  { name: 'Dashboard', path: '/dashboard', access: 'authenticated' },
  { name: 'Settings', path: '/settings', access: 'authenticated' },
  { name: 'Admin', path: '/admin', access: 'admin' },
  { name: 'Admin Users', path: '/admin/users', access: 'admin' },
]

const API_TESTS = [
  { name: 'My Profile', method: 'GET', path: '/api/user/profile', access: 'authenticated' },
  { name: 'Admin Users', method: 'GET', path: '/api/admin/users', access: 'admin' },
]

export function DevTestingPanel() {
  const [isOpen, setIsOpen] = useState(false)
  const [activeTab, setActiveTab] = useState<'users' | 'routes' | 'api'>('users')
  const [apiResults, setApiResults] = useState<Record<string, string>>({})
  const { data: session } = useSession()
  const router = useRouter()
  const pathname = usePathname()

  if (process.env.NODE_ENV !== 'development') return null

  const switchUser = async (email: string) => {
    await signOut({ redirect: false })
    await fetch('/api/dev/signin', {
      method: 'POST',
      body: JSON.stringify({ email }),
    })
    router.refresh()
  }

  const getRouteColor = (access: string) => {
    if (access === 'public') return 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30'
    if (!session) return 'bg-red-500/20 text-red-400 border-red-500/30'
    if (access === 'authenticated') return 'bg-green-500/20 text-green-400 border-green-500/30'
    if (access === 'admin' && session.user.role === 'ADMIN') return 'bg-green-500/20 text-green-400 border-green-500/30'
    if (access === 'team' && ['TEAM', 'ADMIN'].includes(session.user.role)) return 'bg-green-500/20 text-green-400 border-green-500/30'
    return 'bg-red-500/20 text-red-400 border-red-500/30'
  }

  const testApi = async (path: string, method: string) => {
    try {
      const res = await fetch(path, { method })
      setApiResults(prev => ({ ...prev, [path]: `${res.status} ${res.statusText}` }))
    } catch (e) {
      setApiResults(prev => ({ ...prev, [path]: 'Error' }))
    }
  }

  return (
    <div className="fixed bottom-4 right-4 z-50">
      {/* Toggle Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="absolute bottom-0 right-0 bg-yellow-500 text-black px-3 py-1 rounded-full text-xs font-bold"
      >
        {isOpen ? '✕' : 'DEV'}
      </button>

      {isOpen && (
        <div className="mb-10 w-80 bg-zinc-900 border border-zinc-700 rounded-lg shadow-xl overflow-hidden">
          {/* Header */}
          <div className="p-3 border-b border-zinc-700 flex justify-between items-center">
            <span className="text-xs text-zinc-400">
              {session ? `${session.user.email} (${session.user.role})` : 'Not signed in'}
            </span>
            {session && (
              <button onClick={() => signOut({ redirect: false })} className="text-xs text-red-400">
                Sign Out
              </button>
            )}
          </div>

          {/* Tabs */}
          <div className="flex border-b border-zinc-700">
            {(['users', 'routes', 'api'] as const).map(tab => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={cn(
                  "flex-1 px-3 py-2 text-xs uppercase",
                  activeTab === tab ? "bg-zinc-800 text-white" : "text-zinc-500"
                )}
              >
                {tab}
              </button>
            ))}
          </div>

          {/* Content */}
          <div className="p-3 max-h-64 overflow-y-auto space-y-2">
            {activeTab === 'users' && (
              <>
                <p className="text-xs text-zinc-500 mb-2">Click to switch user:</p>
                {TEST_USERS.map(user => (
                  <button
                    key={user.email}
                    onClick={() => switchUser(user.email)}
                    className={cn(
                      "w-full p-2 rounded text-left text-sm border",
                      session?.user.email === user.email
                        ? "bg-green-500/20 border-green-500/30 text-green-400"
                        : "bg-zinc-800 border-zinc-700 text-zinc-300 hover:bg-zinc-700"
                    )}
                  >
                    <div className="font-medium">{user.email}</div>
                    <div className="text-xs opacity-70">{user.role}</div>
                  </button>
                ))}
              </>
            )}

            {activeTab === 'routes' && (
              <>
                <p className="text-xs text-zinc-500 mb-2">
                  🟢 Should access | 🔴 Should block | 🟡 Public
                </p>
                {ROUTE_TESTS.map(route => (
                  <button
                    key={route.path}
                    onClick={() => router.push(route.path)}
                    className={cn(
                      "w-full p-2 rounded text-left text-sm border",
                      getRouteColor(route.access),
                      pathname === route.path && "ring-2 ring-white/50"
                    )}
                  >
                    <div className="font-medium">{route.name}</div>
                    <div className="text-xs opacity-70">{route.path} • {route.access}</div>
                  </button>
                ))}
              </>
            )}

            {activeTab === 'api' && (
              <>
                <p className="text-xs text-zinc-500 mb-2">Click to test API endpoints:</p>
                {API_TESTS.map(api => (
                  <button
                    key={api.path}
                    onClick={() => testApi(api.path, api.method)}
                    className={cn(
                      "w-full p-2 rounded text-left text-sm border",
                      getRouteColor(api.access)
                    )}
                  >
                    <div className="font-medium">{api.name}</div>
                    <div className="text-xs opacity-70">
                      {api.method} {api.path}
                      {apiResults[api.path] && ` → ${apiResults[api.path]}`}
                    </div>
                  </button>
                ))}
              </>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
```

Add to root layout (dev only):
```tsx
// app/layout.tsx
import { DevTestingPanel } from "@/components/dev/DevTestingPanel"

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <Providers>
          {children}
          {process.env.NODE_ENV === 'development' && <DevTestingPanel />}
        </Providers>
      </body>
    </html>
  )
}
```

---

### 403 Forbidden Page

```tsx
// app/403/page.tsx
import Link from "next/link"
import { Button } from "@/components/ui/button"

export default function ForbiddenPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center space-y-4">
        <h1 className="text-4xl font-bold">403</h1>
        <p className="text-muted-foreground">You don't have permission to access this page.</p>
        <Button asChild>
          <Link href="/dashboard">Go to Dashboard</Link>
        </Button>
      </div>
    </div>
  )
}
```

---

### Auth Testing Checklist

Before shipping, test these scenarios:

**As Guest (not signed in):**
- [ ] Public pages load correctly
- [ ] Protected pages redirect to sign-in
- [ ] Admin routes redirect to sign-in
- [ ] Protected APIs return 401

**As USER:**
- [ ] Can access dashboard
- [ ] Cannot access admin routes (redirects to 403)
- [ ] Admin APIs return 403
- [ ] User-specific data shows correctly

**As ADMIN:**
- [ ] Can access all authenticated routes
- [ ] Can access admin routes
- [ ] Admin APIs return data

**Edge Cases:**
- [ ] Expired session redirects to sign-in
- [ ] Invalid magic link shows error
- [ ] Sign out clears session completely
- [ ] Role change takes effect on next request

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
