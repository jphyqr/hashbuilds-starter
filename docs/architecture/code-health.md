# Code Health & Tech Debt

Track code quality issues, pattern violations, and tech debt.

**Role:** Quality Engineer / Tech Lead
**Updates:** During `/end-session`, code reviews, or when issues are noticed

---

## Health Dashboard

| Metric | Status | Last Checked |
|--------|--------|--------------|
| Unused exports | ⬜ Not checked | - |
| Type coverage | ⬜ Not checked | - |
| Pattern compliance | ⬜ Not checked | - |
| Dead code | ⬜ Not checked | - |
| TODO/FIXME count | ⬜ Not checked | - |

---

## Pattern Violations

Track code that deviates from documented patterns in `/docs/architecture/`.

| Location | Expected Pattern | Actual | Priority | Notes |
|----------|-----------------|--------|----------|-------|
| _[file:line]_ | _[pattern from ui-patterns.md]_ | _[what was done]_ | P1/P2/P3 | _[why/context]_ |

**Priority guide:**
- **P1:** Fix immediately - causes bugs or confusion
- **P2:** Fix soon - inconsistent but works
- **P3:** Fix eventually - minor cosmetic issue

---

## Tech Debt Log

Intentional shortcuts that need to be addressed later.

| ID | Description | Location | Added | Deadline | Status |
|----|-------------|----------|-------|----------|--------|
| TD-001 | _[What was shortcut]_ | _[file]_ | _[date]_ | _[when to fix]_ | Open |

**Status:** Open → In Progress → Resolved

### Template for adding debt:

```markdown
| TD-XXX | [Quick description] | [file.tsx] | [date] | [deadline or "Before launch"] | Open |
```

---

## Unused Code

Results from running dead code detection.

```bash
# Run this periodically:
npx ts-prune  # Finds unused exports
npx unimported  # Finds unused files
```

### Last scan results:

_[Paste results here after running scans]_

### Files to delete:

| File | Reason | Safe to Delete? |
|------|--------|-----------------|
| _[file]_ | _[unused / deprecated]_ | [ ] Verified |

---

## TODO/FIXME Inventory

```bash
# Find all TODOs and FIXMEs:
grep -rn "TODO\|FIXME" --include="*.ts" --include="*.tsx" app/ lib/ components/
```

### Current items:

| Type | Location | Description | Owner |
|------|----------|-------------|-------|
| TODO | _[file:line]_ | _[what needs doing]_ | _[who]_ |
| FIXME | _[file:line]_ | _[what's broken]_ | _[who]_ |

---

## Anti-Patterns Spotted

Patterns we've seen that should NOT be repeated.

| Anti-Pattern | Why It's Bad | Do This Instead |
|--------------|--------------|-----------------|
| `// @ts-ignore` | Hides real type errors | Fix the type or use `as unknown as X` with comment |
| `any` type | Loses type safety | Use `unknown` and narrow, or define proper type |
| Inline styles | Hard to maintain | Use Tailwind classes |
| `console.log` in prod | Leaks info, clutters | Use proper logging or remove |
| Fetching in useEffect | Race conditions, no cache | Use server components or SWR/React Query |

---

## Dependency Audit

```bash
# Check for outdated packages:
pnpm outdated

# Check for security issues:
pnpm audit
```

### Known issues:

| Package | Issue | Action | Status |
|---------|-------|--------|--------|
| _[package]_ | _[vulnerability/outdated]_ | _[upgrade/replace/ignore]_ | Open |

---

## Code Review Checklist

Run through this before major PRs:

### Patterns
- [ ] Forms use react-hook-form + zod (see ui-patterns.md)
- [ ] Toasts use Sonner pattern (see ui-patterns.md)
- [ ] API responses follow format (see api-conventions.md)
- [ ] New models documented (see data-model.md)

### Quality
- [ ] No `any` types
- [ ] No `// @ts-ignore`
- [ ] No `console.log` (use proper logging)
- [ ] No hardcoded strings that should be env vars
- [ ] Error handling in place

### Performance
- [ ] No N+1 queries (use `include` in Prisma)
- [ ] Images use `next/image`
- [ ] Large components use dynamic imports
- [ ] Lists have pagination

---

## Refactoring Queue

Bigger refactoring tasks to do when there's time.

| Task | Effort | Impact | Status |
|------|--------|--------|--------|
| _[What to refactor]_ | S/M/L | High/Med/Low | Backlog |

---

## Health Check Commands

Add scripts to `package.json`:

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx",
    "typecheck": "tsc --noEmit",
    "unused": "npx ts-prune",
    "audit": "pnpm audit",
    "health": "pnpm lint && pnpm typecheck"
  }
}
```

Run `pnpm health` before commits.

---

## Session Audit Notes

During `/end-session`, Claude should note any code health issues here:

### [DATE] - Session Notes

_[Any pattern violations, tech debt added, or quality concerns from this session]_

---

_Keep this file updated. Code health degrades silently - this makes it visible._
