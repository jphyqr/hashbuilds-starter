# Create Spec

Create a detailed feature specification before implementation.

## Instructions

**Argument:** `$ARGUMENTS` (feature name in kebab-case, or backlog ID like "#3")

If no argument provided, ask: "What feature do you want to spec out?"

## Step 0: Check Backlog Integration

First, read `/docs/product/backlog.md`:

**If argument is a backlog ID (e.g., "#3" or "3"):**
- Find that item in the backlog
- Use its description as the starting point
- Will link the spec back to the backlog entry

**If argument is a new feature name:**
- Check if it exists in backlog
- If yes, confirm: "This matches backlog #[ID]. Use that?"
- If no, will add to backlog after spec creation

## Discovery Questions

Before writing the spec, ask these questions ONE AT A TIME:

1. **Problem:** "What problem does this solve for users? Be specific."

2. **Users:** "Who uses this feature? (e.g., all users, admins only, logged-in users)"

3. **Flow:** "Walk me through the user flow step by step. What does the user do, and what happens?"

4. **Data:** "What data needs to be stored? Any new database tables?"

5. **Integrations:** "Does this need external services? (Stripe, email, file storage, etc.)"

6. **Auth:** "What permissions are needed? Public, authenticated, admin-only?"

7. **Priority:** "Is this MVP-critical, Phase 2, or nice-to-have?"

## After Discovery

Create the spec file at `/docs/product/$ARGUMENTS.md` using this structure:

```markdown
# [Feature Name]

**Status:** Ready
**Priority:** [from answer 7]
**Created:** [TODAY'S DATE]
**Last Updated:** [TODAY'S DATE]

---

## Problem Statement

[From answer 1 - expand with context]

---

## User Stories

[Generate 2-4 user stories based on answers]

- As a [user type], I want [action], so that [benefit]

---

## Acceptance Criteria

[Generate specific, testable criteria from the flow]

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

---

## Technical Design

### Database Models

[Generate Prisma models if needed from answer 4]

```prisma
model [ModelName] {
  id        String   @id @default(cuid())
  // fields based on data requirements
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

### API Routes

[Generate API routes based on CRUD needs]

| Method | Route | Purpose | Auth Required |
|--------|-------|---------|---------------|
| GET | /api/[resource] | List items | [from answer 6] |
| POST | /api/[resource] | Create item | [from answer 6] |

### Components

[List components needed for the UI]

- `[Component]List` - Displays list
- `[Component]Form` - Create/edit form
- `[Component]Card` - Individual item display

### External Integrations

[From answer 5 - list any external services]

---

## User Flow

[Expand answer 3 into numbered steps]

1. User [action]
2. System [response]
3. User sees [result]

---

## Edge Cases

[Generate edge cases based on the feature]

| Scenario | Expected Behavior |
|----------|-------------------|
| Empty state | [behavior] |
| Error state | [behavior] |
| Loading state | [behavior] |
| [Feature-specific case] | [behavior] |

---

## Security Considerations

[Based on answer 6]

- [ ] Input validation
- [ ] Authorization checks
- [ ] [Other relevant checks]

---

## Implementation Steps

### Phase 1: Backend
1. [ ] Add Prisma models (if any)
2. [ ] Run migration
3. [ ] Create API routes
4. [ ] Add auth middleware (if needed)

### Phase 2: Frontend
5. [ ] Create components
6. [ ] Add form handling
7. [ ] Connect to API
8. [ ] Handle loading/error states

### Phase 3: Polish
9. [ ] Add validation messages
10. [ ] Responsive design
11. [ ] Accessibility check
12. [ ] Add to test checklist

---

## Testing Checklist

- [ ] [Key user flow] works end-to-end
- [ ] Error states display correctly
- [ ] Loading states show properly
- [ ] [Auth requirement] enforced
- [ ] Mobile responsive

---

## Out of Scope

[List what this feature does NOT include]

---

_Spec created: [DATE]_
```

## After Creating

### Update the Backlog

1. If this was from a backlog item:
   - Update the Spec column with link: `[spec-name.md](spec-name.md)`
   - Change Status from "idea" or "scored" → "spec-ready"

2. If this was a new feature:
   - Add a new row to backlog with status "spec-ready"
   - Include the spec link

### Tell the User

```
✅ Spec created at `/docs/product/$ARGUMENTS.md`

Backlog updated: #[ID] - [feature] → status: spec-ready

Next steps:
1. Review the spec and refine any details
2. When ready, run `/implement-spec $ARGUMENTS` to start building
```

## Tips for Good Specs

- Be specific about data types and field names
- Include all API routes, even obvious CRUD ones
- Think about empty, loading, and error states
- Consider mobile experience
- List what's explicitly out of scope
