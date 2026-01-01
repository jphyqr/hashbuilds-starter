# /specs - Feature Specifications

<!--
HOW TO USE THIS FOLDER:

This folder contains detailed feature specifications. The spec-first workflow ensures Claude Code has complete context before implementation.

**The Workflow:**
1. Create spec with `/create-spec` command
2. Review and refine the spec
3. Implement with `/implement-spec [spec-name]` command
4. Update spec status as you build

**Why Specs First:**
- Complete context = better implementation
- Edge cases considered upfront
- Clear acceptance criteria
- Trackable progress
- Documentation built-in
-->

---

## Spec-First Development

Before building features, write specifications. This gives Claude Code the full picture.

---

## Creating a Spec

Use the `/create-spec` slash command:

```
/create-spec user-authentication
```

This will:
1. Ask clarifying questions about the feature
2. Generate a complete specification
3. Save to `/specs/[feature-name].md`

---

## Spec Structure

Each spec includes:

```markdown
# Feature Name

**Status:** Planning | In Progress | Complete
**Priority:** MVP | Phase 2 | Nice-to-have
**Created:** YYYY-MM-DD

---

## Problem Statement
What problem this solves for users.

---

## User Stories
- As a [user], I want [action], so that [benefit]

---

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

---

## Technical Design

### Database Models
Prisma schema additions.

### API Routes
| Method | Route | Purpose |
|--------|-------|---------|

### Components
- ComponentName - Purpose

---

## Edge Cases
- What happens when...

---

## Implementation Steps
1. [ ] Step 1
2. [ ] Step 2

---

## Testing Checklist
- [ ] Test case 1
- [ ] Test case 2
```

---

## Implementing a Spec

Once a spec is complete, implement with:

```
/implement-spec user-authentication
```

This will:
1. Read the spec file
2. Follow implementation steps in order
3. Update status as it progresses
4. Check off acceptance criteria

---

## Spec Status Legend

| Status | Meaning |
|--------|---------|
| **Planning** | Spec being written, not ready for implementation |
| **Ready** | Spec complete, ready to implement |
| **In Progress** | Implementation started |
| **Complete** | Feature fully implemented and tested |
| **On Hold** | Paused for later |

---

## Example Specs

Use `_TEMPLATE.md` as your starting point for new specs.

After creating a few specs, this folder will contain real examples to reference.

---

## Tips

1. **Be specific** - Vague specs = vague implementations
2. **Include edge cases** - Think about what could go wrong
3. **Define done** - Clear acceptance criteria
4. **Consider testing** - How will you verify it works?
5. **Keep updated** - Mark progress as you build

---

_Spec-first development produces better features. Take time upfront to save time later._
