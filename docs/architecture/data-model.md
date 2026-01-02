# Data Model

**Source of truth:** `prisma/schema.prisma`

This file documents *why* the data model is structured this way, not *what* it contains.

---

## Entity Relationship Overview

<!--
PROMPT: After setting up your database schema, document the relationships here.

Draw a simple ASCII diagram showing how your main entities relate:

```
User
  └── owns many → Listing
       └── has many → Inquiry (from potential customers)
```

Then explain any non-obvious design decisions below.
-->

```
[Draw your entity relationships here]

Example:
User
  └── Listing (one-to-many)
       └── Inquiry (one-to-many)
```

---

## Design Decisions

Document decisions that aren't obvious from the schema:

### User Roles

| Decision | Rationale |
|----------|-----------|
| _[e.g., "Single role per user"]_ | _[e.g., "Simpler auth, can upgrade later"]_ |

### Soft Deletes

| Model | Strategy | Why |
|-------|----------|-----|
| _[e.g., "User"]_ | _[e.g., "archivedAt field"]_ | _[e.g., "Keep for audit trail"]_ |

### Denormalization

| Field | Why Denormalized |
|-------|-----------------|
| _[e.g., "Order.totalAmount"]_ | _[e.g., "Avoid recalculating from line items"]_ |

---

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Models | PascalCase singular | `User`, `Listing`, `Inquiry` |
| Fields | camelCase | `createdAt`, `firstName` |
| Enums | SCREAMING_SNAKE_CASE | `USER_ROLE`, `ORDER_STATUS` |
| Relations | Named by role | `author` not `userId` |
| Foreign keys | `modelId` | `userId`, `listingId` |

---

## Common Patterns

### Timestamps

All models include:
```prisma
createdAt DateTime @default(now())
updatedAt DateTime @updatedAt
```

### Soft Deletes (when needed)

```prisma
archivedAt DateTime?  // null = active, set = archived
```

Query pattern:
```typescript
// Find active only
db.model.findMany({ where: { archivedAt: null } })

// Find all including archived
db.model.findMany()
```

### Status Enums

```prisma
enum Status {
  DRAFT
  ACTIVE
  ARCHIVED
}
```

---

## Migration Safety

**NEVER run destructively on shared databases:**
- `prisma migrate reset`
- `prisma db push --force-reset`

**Safe migration pattern:**
1. Add new field as nullable: `field String?`
2. Deploy and backfill data
3. Make required in next migration: `field String`

See [docs/services/01-database.md](../services/01-database.md) for full migration guide.

---

## Changelog

| Date | Change | Migration |
|------|--------|-----------|
| _[DATE]_ | Initial schema | `init` |

---

_Update this file when you make significant schema changes._
