# /docs/architecture - Build Checklists & Patterns

This folder contains **guardrails for creating new files** and architectural patterns.

**Source of truth:** Code is always the source of truth. These docs capture *intent* and *patterns*, not duplicate code.

---

## BEFORE YOU CREATE (Read First!)

| Creating This... | Read First | Why |
|------------------|------------|-----|
| `app/**/page.tsx` | [pages.md](pages.md) | SEO, metadata, layouts |
| `app/**/layout.tsx` | [pages.md](pages.md) | Metadata inheritance |
| `app/api/**/route.ts` | [api-conventions.md](api-conventions.md) | Auth, validation, errors |
| `prisma/schema.prisma` changes | [schema.md](schema.md) | Migration safety |

**These are NON-NEGOTIABLE.** Every page needs SEO. Every API needs auth. Every schema change needs safety.

---

## Files

| File | Purpose | When to Read |
|------|---------|--------------|
| [pages.md](pages.md) | **Checklist:** SEO, meta, OpenGraph, layouts | Before creating pages |
| [schema.md](schema.md) | **Checklist:** Migrations, indexes, cascades | Before schema changes |
| [api-conventions.md](api-conventions.md) | **Checklist:** Auth, validation, response formats | Before creating APIs |
| [data-model.md](data-model.md) | Entity relationships, design decisions | After schema changes |
| [components.md](components.md) | Component inventory, usage patterns | When building reusable components |
| [ui-patterns.md](ui-patterns.md) | Forms, toasts, errors, loading states | When changing core UI patterns |
| [code-health.md](code-health.md) | Tech debt, pattern violations | During /end-session or code reviews |

---

## Quick Reference

### Every Page Needs:
- [ ] Unique `<title>` (50-60 chars)
- [ ] `description` meta (150-160 chars)
- [ ] OpenGraph tags (or inherit from layout)
- [ ] JSON-LD if content page

### Every API Route Needs:
- [ ] Auth check (unless explicitly public)
- [ ] Zod input validation
- [ ] Proper status codes
- [ ] Error handling

### Every Schema Change Needs:
- [ ] Safe migration path (no data loss)
- [ ] Indexes for query patterns
- [ ] Cascade rules defined
- [ ] Tested locally first

---

## When to Document Here

**Document when:**
- You make a decision that isn't obvious from the code
- A pattern emerges that should be followed consistently
- Future-you (or a teammate) would ask "why did we do it this way?"

**Don't document:**
- Things that are obvious from reading the code
- Implementation details that change frequently
- One-off solutions that won't be reused

---

## Relationship to Other Docs

| This Folder | vs | Other Docs |
|-------------|----|-----------|
| pages.md | → | `03-design-system.md` has aesthetics; this has SEO rules |
| schema.md | → | `prisma/schema.prisma` is source of truth; this explains safety |
| api-conventions.md | → | `05-coding-standards.md` has general patterns; this has API specifics |
| data-model.md | → | `prisma/schema.prisma` is source of truth; this explains *why* |
| components.md | → | `03-design-system.md` has aesthetics; this has component inventory |

---

## Pattern Sync

**When Claude notices a new pattern:**

If you're implementing something differently than what's documented in this folder, Claude should ask:

> "I notice you're using [new pattern] instead of the documented [old pattern]. Should I:
> 1. **Use the documented pattern** - Keep consistency
> 2. **Use your new pattern this once** - One-off exception
> 3. **Update the docs** - This is the new standard going forward"

This keeps patterns consistent across the project while allowing evolution.

---

_These checklists exist because fixing SEO/security/data issues after the fact is 10x harder than doing it right the first time._
