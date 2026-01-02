# /docs/architecture - System Architecture

This folder documents architectural decisions that evolve as the app grows.

**Source of truth:** Code is always the source of truth. These docs capture *intent* and *patterns*, not duplicate code.

---

## Files

| File | Purpose | When to Update |
|------|---------|----------------|
| [data-model.md](data-model.md) | Entity relationships, design decisions | When adding/changing Prisma models |
| [api-conventions.md](api-conventions.md) | REST patterns, auth, response formats | When adding new API patterns |
| [components.md](components.md) | Key component inventory, usage patterns | When building reusable components |
| [ui-patterns.md](ui-patterns.md) | Forms, toasts, errors, loading states | When changing core UI patterns |
| [code-health.md](code-health.md) | Tech debt, pattern violations, code quality | During /end-session or code reviews |

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
| data-model.md | → | `prisma/schema.prisma` is the source of truth; this explains *why* |
| api-conventions.md | → | `05-coding-standards.md` has patterns; this has project-specific conventions |
| components.md | → | `03-design-system.md` has aesthetics; this has component inventory |
| ui-patterns.md | → | `05-coding-standards.md` has general patterns; this has ready-to-use code |

---

## Pattern Sync

**When Claude notices a new pattern:**

If you're implementing something differently than what's documented in this folder, Claude should ask:

> "I notice you're using [new pattern] instead of the documented [old pattern]. Should I:
> 1. **Use the documented pattern** - Keep consistency
> 2. **Use your new pattern this once** - One-off exception
> 3. **Update the docs** - This is the new standard going forward"

This keeps patterns consistent across the project while allowing evolution.

**When to update patterns:**
- The new approach is clearly better (simpler, more maintainable)
- It will be used in multiple places
- The old pattern should no longer be used

---

_These docs grow with your app. Start minimal, add as patterns emerge._
