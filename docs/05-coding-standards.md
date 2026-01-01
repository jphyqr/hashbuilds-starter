# 05-coding-standards.md - Code Conventions

<!--
PROMPT: Coding standards ensure consistency. Ask me:

1. Is this a solo project or team project?
   - Solo → Lighter standards, focus on consistency
   - Team → Stricter standards, focus on readability

2. What's your experience level with Next.js/React?
   - Beginner → I'll explain patterns as I use them
   - Intermediate → Standard patterns, brief explanations
   - Advanced → Minimal explanations, focus on edge cases

3. Any specific patterns you want to enforce?
   - Naming conventions (camelCase, PascalCase, etc.)
   - File organization preferences
   - Component structure preferences

4. Do you have existing code I should match?
   - Yes → I'll analyze and follow existing patterns
   - No → I'll use these standards as the baseline

After you answer, I'll customize this file and follow these standards in all code I write.
-->

---

## File Organization

### Directory Structure

```
app/
├── (auth)/                    # Auth-required route group
│   ├── dashboard/
│   └── settings/
├── (public)/                  # Public route group
│   ├── about/
│   └── pricing/
├── api/                       # API routes
│   ├── auth/
│   └── [resource]/
├── components/                # Shared components
│   ├── ui/                    # shadcn/ui components
│   └── [feature]/             # Feature-specific components
└── lib/                       # Utilities, helpers, types

docs/                          # Developer documentation
specs/                         # Feature specifications
prisma/                        # Database schema
public/                        # Static assets
```

### File Naming

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Pages | lowercase | `app/dashboard/page.tsx` |
| API routes | lowercase | `app/api/users/route.ts` |
| Utilities | camelCase | `lib/formatDate.ts` |
| Types | PascalCase | `types/User.ts` |
| Specs | kebab-case | `specs/user-authentication.md` |

---

## Component Patterns

### Component Structure

```tsx
// 1. Imports (external, then internal, then types)
import { useState } from 'react'
import { Button } from '@/components/ui/button'
import type { User } from '@/types'

// 2. Types (if not imported)
type UserCardProps = {
  user: User
  onEdit?: (user: User) => void
}

// 3. Component
export function UserCard({ user, onEdit }: UserCardProps) {
  // State
  const [isEditing, setIsEditing] = useState(false)

  // Handlers
  const handleEdit = () => {
    setIsEditing(true)
    onEdit?.(user)
  }

  // Render
  return (
    <div className="...">
      {/* JSX */}
    </div>
  )
}
```

### Server vs Client Components

```tsx
// Server Component (default) - NO 'use client' directive
// Use for: Data fetching, static content, SEO
export default async function UsersPage() {
  const users = await db.user.findMany()
  return <UserList users={users} />
}

// Client Component - Add 'use client' at top
// Use for: Interactivity, hooks, browser APIs
'use client'
export function UserSearch() {
  const [query, setQuery] = useState('')
  return <input value={query} onChange={(e) => setQuery(e.target.value)} />
}
```

### Server Actions Pattern

```tsx
// actions.ts - Server Actions
'use server'

import { revalidatePath } from 'next/cache'
import { db } from '@/lib/db'

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string

  await db.user.create({ data: { name } })

  revalidatePath('/users')
}

// ClientForm.tsx - Client imports action directly
'use client'
import { createUser } from './actions'

export function ClientForm() {
  return (
    <form action={createUser}>
      <input name="name" />
      <button type="submit">Create</button>
    </form>
  )
}
```

---

## Database Patterns

### Prisma Query Patterns

```typescript
// Good: Select only needed fields
const users = await db.user.findMany({
  select: {
    id: true,
    name: true,
    email: true,
  }
})

// Good: Include relations when needed
const userWithPosts = await db.user.findUnique({
  where: { id },
  include: { posts: true }
})

// Good: Use transactions for multiple operations
await db.$transaction([
  db.user.update({ where: { id }, data: { status: 'deleted' } }),
  db.post.deleteMany({ where: { authorId: id } }),
])
```

### Safe Migration Pattern

```
NEVER run:
- prisma migrate reset
- prisma db push --force-reset

ALWAYS:
1. Add nullable field first: field String?
2. Deploy, seed data if needed
3. Make required in next migration: field String
```

---

## API Route Patterns

### Route Handler Structure

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { db } from '@/lib/db'

export async function GET(request: NextRequest) {
  try {
    const users = await db.user.findMany()
    return NextResponse.json(users)
  } catch (error) {
    console.error('Failed to fetch users:', error)
    return NextResponse.json(
      { error: 'Failed to fetch users' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // Validate input
    if (!body.name || !body.email) {
      return NextResponse.json(
        { error: 'Name and email required' },
        { status: 400 }
      )
    }

    const user = await db.user.create({ data: body })
    return NextResponse.json(user, { status: 201 })
  } catch (error) {
    console.error('Failed to create user:', error)
    return NextResponse.json(
      { error: 'Failed to create user' },
      { status: 500 }
    )
  }
}
```

### Dynamic Route Pattern

```typescript
// app/api/users/[id]/route.ts
import { NextRequest, NextResponse } from 'next/server'

type Params = { params: Promise<{ id: string }> }

export async function GET(request: NextRequest, { params }: Params) {
  const { id } = await params
  // ...
}
```

---

## Error Handling

### Try-Catch Pattern

```typescript
// Always wrap async operations
try {
  const result = await riskyOperation()
  return { success: true, data: result }
} catch (error) {
  console.error('Operation failed:', error)
  return { success: false, error: 'Something went wrong' }
}
```

### Error Boundaries

```tsx
// app/error.tsx - Catches errors in route segment
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error
  reset: () => void
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

---

## TypeScript Patterns

### Type Definitions

```typescript
// types/index.ts - Centralized types
export type User = {
  id: string
  name: string
  email: string
  role: 'admin' | 'user'
  createdAt: Date
}

// Infer from Prisma
import type { User as PrismaUser } from '@prisma/client'
export type User = PrismaUser
```

### Avoid `any`

```typescript
// Bad
function processData(data: any) { ... }

// Good
function processData(data: unknown) {
  if (typeof data === 'string') {
    // Now TypeScript knows it's a string
  }
}

// Better - Define the type
type ProcessableData = { id: string; value: number }
function processData(data: ProcessableData) { ... }
```

---

## Styling Patterns

### Tailwind Conventions

```tsx
// Use className for styling
<div className="flex items-center gap-4 p-4 bg-white rounded-lg shadow">

// Use cn() helper for conditional classes
import { cn } from '@/lib/utils'

<button className={cn(
  "px-4 py-2 rounded",
  isActive && "bg-blue-500 text-white",
  isDisabled && "opacity-50 cursor-not-allowed"
)}>
```

### Component Variants

```tsx
// Use cva for variant-based styling
import { cva, type VariantProps } from 'class-variance-authority'

const buttonVariants = cva(
  "px-4 py-2 rounded font-medium transition",
  {
    variants: {
      variant: {
        primary: "bg-blue-500 text-white hover:bg-blue-600",
        secondary: "bg-gray-200 text-gray-800 hover:bg-gray-300",
        ghost: "hover:bg-gray-100",
      },
      size: {
        sm: "text-sm px-3 py-1",
        md: "text-base px-4 py-2",
        lg: "text-lg px-6 py-3",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
)
```

---

## Git Conventions

### Commit Messages

```
feat: Add user authentication
fix: Resolve login redirect issue
docs: Update API documentation
refactor: Simplify user service logic
test: Add integration tests for auth
chore: Update dependencies
```

### Branch Naming

```
feature/user-authentication
fix/login-redirect
docs/api-update
refactor/user-service
```

---

## Code Review Checklist

Before submitting code:

- [ ] No `console.log` statements (use proper logging)
- [ ] No hardcoded secrets or credentials
- [ ] Error handling in place
- [ ] Types are explicit (no implicit `any`)
- [ ] Components are properly memoized if needed
- [ ] Database queries are optimized (select only needed fields)
- [ ] No unused imports or variables
- [ ] Follows file naming conventions
- [ ] Has appropriate comments for complex logic

---

_These standards evolve. Update this file as patterns emerge._
