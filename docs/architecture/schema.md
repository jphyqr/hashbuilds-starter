# Schema Change Checklist

**Read this BEFORE modifying `prisma/schema.prisma`.**

---

## Pre-Flight Checklist

Before making any schema change:

| Question | Answer | Impact |
|----------|--------|--------|
| Is this a breaking change? | Yes/No | Migration strategy |
| Does prod have data in this table? | Yes/No | Data preservation |
| Am I adding a required field? | Yes/No | Need default or backfill |
| Am I deleting/renaming? | Yes/No | Need multi-step migration |

---

## The Golden Rules

### 1. NEVER Run Destructive Commands on Shared DBs

```bash
# ❌ NEVER on dev/prod shared database
prisma migrate reset
prisma db push --force-reset
prisma migrate dev --create-only && prisma db push  # risky

# ✅ Safe commands
prisma migrate dev      # Creates migration file, applies it
prisma migrate deploy   # Applies pending migrations (prod)
prisma generate         # Just regenerates client
```

### 2. Additive Changes Are Safe

```prisma
# ✅ Safe - adding optional field
model User {
  newField String?  // Optional, no data required
}

# ✅ Safe - adding new model
model NewThing {
  id String @id
}

# ✅ Safe - adding new enum value
enum Status {
  ACTIVE
  INACTIVE
  PENDING  // New value, existing rows unaffected
}
```

### 3. Breaking Changes Need Multi-Step Migrations

```prisma
# ❌ Dangerous - required field with no default
model User {
  requiredField String  // Existing rows will fail!
}

# ✅ Safe - add with default
model User {
  requiredField String @default("unknown")
}

# ⚠️ Careful - renaming
# Old: firstName → New: givenName
# This deletes data! Use multi-step instead.
```

---

## Migration Patterns

### Adding a Required Field (Safe Pattern)

**Step 1: Add as optional**
```prisma
model User {
  bio String?
}
```
```bash
prisma migrate dev --name add_optional_bio
```

**Step 2: Backfill data**
```typescript
// scripts/backfill-bio.ts
await db.user.updateMany({
  where: { bio: null },
  data: { bio: '' }
})
```

**Step 3: Make required**
```prisma
model User {
  bio String @default("")
}
```
```bash
prisma migrate dev --name make_bio_required
```

### Renaming a Field (Safe Pattern)

**Step 1: Add new field**
```prisma
model User {
  firstName String    // Old
  givenName String?   // New (optional for now)
}
```

**Step 2: Copy data**
```typescript
const users = await db.user.findMany()
for (const user of users) {
  await db.user.update({
    where: { id: user.id },
    data: { givenName: user.firstName }
  })
}
```

**Step 3: Update code to use new field**
- Find all references to `firstName`
- Update to `givenName`
- Deploy

**Step 4: Remove old field**
```prisma
model User {
  givenName String
  // firstName removed
}
```

### Deleting a Model (Safe Pattern)

1. Remove all code references first
2. Deploy code changes
3. Then remove from schema
4. Keep data backup for 30 days

---

## Index Strategy

### When to Add Indexes

| Query Pattern | Index Needed |
|--------------|--------------|
| `findMany({ where: { status: 'ACTIVE' } })` | `@@index([status])` |
| `findMany({ where: { userId: x }, orderBy: { createdAt: 'desc' } })` | `@@index([userId, createdAt])` |
| `findUnique({ where: { email: x } })` | `@unique` (implicit index) |
| `findFirst({ where: { slug: x, type: y } })` | `@@unique([slug, type])` |

### Index Template

```prisma
model Listing {
  id          String   @id @default(cuid())
  status      String
  ownerId     String
  createdAt   DateTime @default(now())
  neighborhood String

  owner User @relation(fields: [ownerId], references: [id])

  // Indexes for common queries
  @@index([status])                    // Filter by status
  @@index([ownerId])                   // User's listings
  @@index([neighborhood, status])      // Browse by area
  @@index([createdAt(sort: Desc)])     // Recent listings
}
```

---

## Relation Cascades

### Define Delete Behavior Explicitly

```prisma
model Listing {
  id      String @id
  owner   User   @relation(fields: [ownerId], references: [id], onDelete: Cascade)
  ownerId String
  // When user deleted → listings deleted
}

model Inquiry {
  id        String  @id
  listing   Listing @relation(fields: [listingId], references: [id], onDelete: Cascade)
  listingId String
  // When listing deleted → inquiries deleted
}
```

### Cascade Options

| Option | Behavior | Use When |
|--------|----------|----------|
| `Cascade` | Delete children | Owned data (user's posts) |
| `SetNull` | Set FK to null | Optional relationships |
| `Restrict` | Block delete | Preserve referential data |
| `NoAction` | Database decides | Rarely used |

---

## Common Mistakes

### Don't Do This

```prisma
# ❌ Required field without default (breaks existing rows)
model User {
  newRequired String
}

# ❌ Enum value removed (breaks rows with that value)
enum Status {
  ACTIVE
  // INACTIVE removed - will break!
}

# ❌ No index on frequently filtered field
model Listing {
  status String  // Queried constantly, no index
}

# ❌ No cascade defined (orphaned data)
model Comment {
  post   Post @relation(fields: [postId], references: [id])
  postId String
  // Delete post → orphaned comments!
}
```

### Do This Instead

```prisma
# ✅ Default value for new required fields
model User {
  newRequired String @default("unknown")
}

# ✅ Mark enum values deprecated, don't remove
enum Status {
  ACTIVE
  INACTIVE
  LEGACY_STATUS  // renamed from DEPRECATED, kept for data
}

# ✅ Index on filtered fields
model Listing {
  status String
  @@index([status])
}

# ✅ Explicit cascade behavior
model Comment {
  post   Post @relation(fields: [postId], references: [id], onDelete: Cascade)
  postId String
}
```

---

## Quick Templates

### New Model with Best Practices

```prisma
model NewModel {
  id        String   @id @default(cuid())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // Required fields
  name      String
  status    Status   @default(DRAFT)

  // Optional fields
  description String?

  // Relations
  owner   User   @relation(fields: [ownerId], references: [id], onDelete: Cascade)
  ownerId String

  // Indexes
  @@index([ownerId])
  @@index([status])
}

enum Status {
  DRAFT
  ACTIVE
  ARCHIVED
}
```

### Adding Soft Delete

```prisma
model User {
  // ... existing fields

  archivedAt DateTime?  // null = active

  @@index([archivedAt])  // Query active users efficiently
}
```

---

## Final Checklist

Before running `prisma migrate dev`:

- [ ] No destructive changes without multi-step plan
- [ ] New required fields have defaults
- [ ] Indexes added for query patterns
- [ ] Cascade rules defined for relations
- [ ] Tested on local DB first
- [ ] Rollback plan documented (if complex)

Before running `prisma migrate deploy` (prod):

- [ ] Database backed up
- [ ] Migration tested in staging
- [ ] No downtime required (or scheduled)
- [ ] Team notified of schema change

---

_Schema mistakes are expensive. Take the extra 5 minutes to do it right._
