# TECH_STACK.md - Architecture & Conventions

**This file documents the technical architecture and coding conventions.**

---

## Stack Overview

| Layer | Technology | Version | Notes |
|-------|------------|---------|-------|
| **Framework** | Next.js | 15.x | App Router |
| **Language** | TypeScript | 5.x | Strict mode |
| **Styling** | Tailwind CSS | 4.x | With CSS variables |
| **UI Library** | shadcn/ui | Latest | Radix primitives |
| **Database** | Prisma | 6.x | See [services/DATABASE.md](services/DATABASE.md) |
| **Auth** | NextAuth.js | 4.x | See [services/AUTH.md](services/AUTH.md) |
| **Email** | Resend | 4.x | See [services/EMAIL.md](services/EMAIL.md) |
| **Animations** | Framer Motion | 12.x | For complex animations |
| **Forms** | react-hook-form | 7.x | With Zod validation |
| **Icons** | Lucide React | Latest | Tree-shakeable |

---

## Project Structure

```
/app                    # Next.js App Router
  /api                  # API routes
  /(auth)               # Auth-related pages (grouped)
  /(admin)              # Admin pages (grouped)
  /[dynamic]            # Dynamic routes
  layout.tsx            # Root layout
  page.tsx              # Homepage

/components             # React components
  /ui                   # shadcn/ui components
  /[feature]            # Feature-specific components

/lib                    # Utilities & helpers
  db.ts                 # Prisma client
  auth.ts               # NextAuth config
  email.ts              # Email helpers
  utils.ts              # General utilities

/prisma                 # Database
  schema.prisma         # Database schema

/public                 # Static assets

/docs                   # Developer documentation
/deliverables           # Client documentation
/.claude/commands       # Slash commands
```

---

## Coding Conventions

### File Naming

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Utilities | camelCase | `formatDate.ts` |
| API routes | route.ts | `app/api/users/route.ts` |
| Pages | page.tsx | `app/dashboard/page.tsx` |
| Layouts | layout.tsx | `app/dashboard/layout.tsx` |

### Component Structure

```tsx
// 1. Imports
import { useState } from 'react'
import { Button } from '@/components/ui/button'

// 2. Types
type Props = {
  title: string
  onSubmit: () => void
}

// 3. Component
export function MyComponent({ title, onSubmit }: Props) {
  // 3a. Hooks
  const [loading, setLoading] = useState(false)

  // 3b. Handlers
  const handleClick = () => {
    setLoading(true)
    onSubmit()
  }

  // 3c. Render
  return (
    <Button onClick={handleClick} disabled={loading}>
      {title}
    </Button>
  )
}
```

### Import Aliases

```typescript
// Use @ for absolute imports
import { Button } from '@/components/ui/button'
import { db } from '@/lib/db'
import { cn } from '@/lib/utils'
```

---

## Database Conventions

### Model Naming
- Models: PascalCase singular (`User`, `Listing`, `Inquiry`)
- Tables: Created automatically by Prisma

### Common Fields
Every model should have:
```prisma
model Example {
  id        String   @id @default(cuid())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  // ... other fields
}
```

### Enum Naming
```prisma
enum UserRole {
  ADMIN
  TEAM
  USER
}
```

---

## API Conventions

### Route Structure
```
/api
  /auth           # NextAuth routes
  /users          # User CRUD
    /route.ts     # GET (list), POST (create)
    /[id]
      /route.ts   # GET (one), PATCH (update), DELETE
```

### Response Format
```typescript
// Success
return Response.json({ data: result })

// Error
return Response.json({ error: 'Message' }, { status: 400 })

// With pagination
return Response.json({
  data: items,
  meta: { page, limit, total }
})
```

---

## Environment Variables

### Required
```env
# Database
DATABASE_URL=

# Auth
NEXTAUTH_URL=
NEXTAUTH_SECRET=

# Email
RESEND_API_KEY=
```

### Optional (add as needed)
```env
# Payments
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# Storage
BLOB_READ_WRITE_TOKEN=

# Analytics
NEXT_PUBLIC_POSTHOG_KEY=
```

---

## Git Conventions

### Branch Naming
```
main              # Production
feat/feature-name # New features
fix/bug-name      # Bug fixes
```

### Commit Messages
```
feat: add user authentication
fix: resolve login redirect issue
docs: update README
chore: update dependencies
```

---

## Performance Guidelines

1. **Images**: Use `next/image` with proper sizing
2. **Fonts**: Use `next/font` for optimal loading
3. **Components**: Use dynamic imports for heavy components
4. **Data**: Implement pagination for lists
5. **Caching**: Use appropriate cache headers

---

## Security Guidelines

1. **Auth**: All API routes require authentication by default
2. **Validation**: Use Zod for all user input
3. **SQL**: Never use raw queries (Prisma only)
4. **Secrets**: Never commit `.env` files
5. **CORS**: Configure appropriately for production

---

## Changelog

| Date | Change |
|------|--------|
| _[YYYY-MM-DD]_ | Initial stack documented |

---

_Last updated: [DATE]_
