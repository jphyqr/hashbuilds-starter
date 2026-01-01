# New Feature

Create a feature specification and scaffold the implementation.

## Instructions

Ask the user: "What feature do you want to add?"

Then gather details:
1. What problem does this solve for users?
2. What's the user flow? (step by step)
3. Does this need new database models?
4. Does this need new API routes?
5. Does this need authentication/authorization?
6. What's the priority? (MVP, Phase 2, Nice-to-have)

## Create Feature Spec

After gathering info, create `/docs/features/[feature-name].md`:

```markdown
# [Feature Name]

**Status:** Planning
**Priority:** [MVP/Phase 2/Nice-to-have]
**Added:** [TODAY'S DATE]

---

## Problem

[What problem this solves]

---

## User Flow

1. User [action]
2. System [response]
3. User sees [result]

---

## Technical Requirements

### Database Models

[List any new Prisma models needed]

### API Routes

| Method | Route | Purpose |
|--------|-------|---------|
| [GET/POST/etc] | /api/... | [Description] |

### Components

- [ ] [Component name] - [Purpose]

---

## Implementation Steps

1. [ ] Add database models
2. [ ] Create API routes
3. [ ] Build UI components
4. [ ] Test flow
5. [ ] Update /deliverables/rollout.md

---

## Edge Cases

- [Edge case 1]
- [Edge case 2]

---

_Spec created: [DATE]_
```

## After Creating Spec

Tell the user:
- "✅ Feature spec created at /docs/features/[name].md"
- "Ready to start implementation?"
- If yes, begin with the first implementation step
