# /docs/features - Feature Specifications

This folder contains detailed specifications for each feature in the application.

---

## How to Use

1. **Before building a feature:** Create a spec file
2. **During development:** Reference the spec
3. **After changes:** Update the spec

---

## Feature Spec Template

Create a new file: `feature-name.md`

```markdown
# Feature: [Feature Name]

## Overview

Brief description of what this feature does.

## User Stories

- As a [user type], I want to [action] so that [benefit]
- As a [user type], I want to [action] so that [benefit]

## Requirements

### Must Have (MVP)
- [ ] Requirement 1
- [ ] Requirement 2

### Nice to Have (Phase 2)
- [ ] Requirement 3
- [ ] Requirement 4

## Data Model

```prisma
model Example {
  id        String   @id @default(cuid())
  field     String
  createdAt DateTime @default(now())
}
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/examples | List all |
| POST | /api/examples | Create new |
| GET | /api/examples/[id] | Get one |
| PATCH | /api/examples/[id] | Update |
| DELETE | /api/examples/[id] | Delete |

## UI Components

- `ExampleList` - Displays all examples
- `ExampleForm` - Create/edit form
- `ExampleCard` - Single item display

## Edge Cases

- What happens when X?
- What happens when Y?

## Testing

- [ ] Unit tests for helpers
- [ ] API route tests
- [ ] E2E tests for user flows

## Status

| Item | Status |
|------|--------|
| Spec complete | [ ] |
| Data model done | [ ] |
| API routes done | [ ] |
| UI done | [ ] |
| Tests done | [ ] |

---

_Created: [DATE]_
_Last updated: [DATE]_
```

---

## Feature Status

| Feature | Spec | Data | API | UI | Tests |
|---------|------|------|-----|----|----|
| _[Feature 1]_ | [ ] | [ ] | [ ] | [ ] | [ ] |
| _[Feature 2]_ | [ ] | [ ] | [ ] | [ ] | [ ] |

---

## Tips

### Good Specs
- Written before coding
- Focused on WHAT not HOW
- Include edge cases
- Have clear acceptance criteria

### Bad Specs
- Too vague ("make it work")
- Too detailed (implementation steps)
- Missing edge cases
- No success criteria

---

_Add new feature specs as .md files in this folder._
