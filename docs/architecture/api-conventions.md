# API Conventions

**Read this BEFORE creating any `app/api/**/route.ts` file.**

For general patterns, see [docs/05-coding-standards.md](../05-coding-standards.md).

---

## Pre-Flight Checklist

Before creating an API route:

| Question | Answer | Action |
|----------|--------|--------|
| Is this a public endpoint? | Yes/No | Skip auth check if public |
| What HTTP methods needed? | GET/POST/etc | Export only those |
| What input does it accept? | Body/Query/Params | Define Zod schema |
| Who can access this? | Anyone/Logged in/Admin | Add auth + role check |

### Every API Route MUST Have

- [ ] **Auth check** (unless explicitly public)
- [ ] **Input validation** (Zod schema for body/params)
- [ ] **Proper status codes** (not just 200 for everything)
- [ ] **Error handling** (try/catch, user-friendly messages)
- [ ] **TypeScript types** (no `any`)

---

## Route Structure

```
/api
├── /auth                    # NextAuth (auto-generated)
├── /[resource]              # Resource CRUD
│   ├── route.ts             # GET (list), POST (create)
│   └── /[id]
│       └── route.ts         # GET (one), PATCH (update), DELETE
└── /webhooks                # External service webhooks
    └── /stripe
```

---

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Routes | Plural nouns | `/api/users`, `/api/listings` |
| Dynamic segments | `[id]` | `/api/users/[id]` |
| Nested resources | Parent/child | `/api/listings/[id]/inquiries` |
| Actions | Verb suffix | `/api/users/[id]/activate` |

---

## HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `GET` | Read (list or single) | `GET /api/users` |
| `POST` | Create new | `POST /api/users` |
| `PATCH` | Partial update | `PATCH /api/users/123` |
| `PUT` | Full replace (rare) | `PUT /api/users/123` |
| `DELETE` | Remove | `DELETE /api/users/123` |

---

## Response Format

### Success Responses

```typescript
// Single item
{
  "data": { "id": "123", "name": "..." }
}

// List
{
  "data": [{ "id": "123" }, { "id": "456" }],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 42
  }
}

// Empty success (204 No Content)
// No body
```

### Error Responses

```typescript
// Client error (4xx)
{
  "error": "User-friendly message",
  "code": "VALIDATION_ERROR",  // Optional: machine-readable code
  "details": { ... }           // Optional: field-specific errors
}

// Server error (5xx)
{
  "error": "Something went wrong"
  // Never expose internal details in production
}
```

---

## Status Codes

| Code | Meaning | When to Use |
|------|---------|-------------|
| `200` | OK | Successful GET, PATCH, PUT |
| `201` | Created | Successful POST |
| `204` | No Content | Successful DELETE |
| `400` | Bad Request | Validation failed |
| `401` | Unauthorized | Not logged in |
| `403` | Forbidden | Logged in but not allowed |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Duplicate, race condition |
| `500` | Server Error | Unexpected error |

---

## Authentication

### Protected Routes

```typescript
import { auth } from '@/lib/auth'

export async function GET() {
  const session = await auth()

  if (!session) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // ... continue
}
```

### Role-Based Access

```typescript
if (session.user.role !== 'ADMIN') {
  return Response.json({ error: 'Forbidden' }, { status: 403 })
}
```

---

## Pagination

### Request

```
GET /api/users?page=2&limit=20
```

### Response

```typescript
{
  "data": [...],
  "meta": {
    "page": 2,
    "limit": 20,
    "total": 42,
    "totalPages": 3
  }
}
```

### Implementation

```typescript
const page = Number(searchParams.get('page')) || 1
const limit = Math.min(Number(searchParams.get('limit')) || 20, 100)
const skip = (page - 1) * limit

const [data, total] = await Promise.all([
  db.user.findMany({ skip, take: limit }),
  db.user.count()
])

return Response.json({
  data,
  meta: { page, limit, total, totalPages: Math.ceil(total / limit) }
})
```

---

## Filtering & Sorting

### Request

```
GET /api/users?status=active&sort=createdAt&order=desc
```

### Implementation

```typescript
const status = searchParams.get('status')
const sort = searchParams.get('sort') || 'createdAt'
const order = searchParams.get('order') || 'desc'

const data = await db.user.findMany({
  where: status ? { status } : undefined,
  orderBy: { [sort]: order }
})
```

---

## Validation

Use Zod for request validation:

```typescript
import { z } from 'zod'

const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
})

export async function POST(request: Request) {
  const body = await request.json()

  const result = CreateUserSchema.safeParse(body)
  if (!result.success) {
    return Response.json(
      { error: 'Validation failed', details: result.error.flatten() },
      { status: 400 }
    )
  }

  // Use result.data (typed!)
}
```

---

## Project-Specific Conventions

<!--
PROMPT: Document any conventions specific to this project.

Examples:
- "All listing queries include owner by default"
- "Inquiries are soft-deleted, never hard-deleted"
- "Admin routes require ADMIN role"
-->

| Convention | Applies To | Rationale |
|------------|-----------|-----------|
| _[Convention]_ | _[Routes]_ | _[Why]_ |

---

## API Inventory

Track your API routes as they grow:

| Route | Methods | Auth | Purpose |
|-------|---------|------|---------|
| `/api/auth/*` | Various | - | NextAuth |
| _[Add as you build]_ | | | |

---

## Quick Copy Template

```typescript
// app/api/[resource]/route.ts
import { auth } from '@/lib/auth'
import { db } from '@/lib/db'
import { z } from 'zod'

const CreateSchema = z.object({
  name: z.string().min(1),
  // ... other fields
})

// GET /api/resource - List all
export async function GET() {
  const session = await auth()
  if (!session) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    const items = await db.resource.findMany({
      where: { userId: session.user.id }
    })
    return Response.json({ data: items })
  } catch {
    return Response.json({ error: 'Failed to fetch' }, { status: 500 })
  }
}

// POST /api/resource - Create new
export async function POST(request: Request) {
  const session = await auth()
  if (!session) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    const body = await request.json()
    const result = CreateSchema.safeParse(body)

    if (!result.success) {
      return Response.json(
        { error: 'Validation failed', details: result.error.flatten() },
        { status: 400 }
      )
    }

    const item = await db.resource.create({
      data: { ...result.data, userId: session.user.id }
    })

    return Response.json({ data: item }, { status: 201 })
  } catch {
    return Response.json({ error: 'Failed to create' }, { status: 500 })
  }
}
```

---

## Final Checklist

Before committing an API route:

- [ ] Auth check present (or explicitly marked as public)
- [ ] Input validated with Zod
- [ ] Proper HTTP status codes used
- [ ] Error responses are user-friendly (no stack traces)
- [ ] Added to API Inventory table above
- [ ] Tested with invalid input
- [ ] Tested unauthorized access

---

_Update this file when you add new API patterns._
