# New Feature

Quick feature addition that integrates with the product backlog.

## Instructions

**Argument:** `$ARGUMENTS` (feature name or description)

If no argument provided, ask: "What feature do you want to add?"

## Step 1: Check the Backlog

First, read `/docs/product/backlog.md` and check if this idea already exists.

**If it exists:**
```
This is already in the backlog as #[ID]: [idea]

Current status: [status]
Score: [score]

Would you like to:
1. Work on it now
2. Update it
3. Add a different idea
```

**If it doesn't exist:**
Continue to Step 2.

## Step 2: Quick Triage

Ask: "How complex is this?"
- **Small (S)** - < 1 hour, no database changes, straightforward
- **Medium (M)** - 1-4 hours, may need new components or API
- **Large (L)** - > 4 hours, needs a full spec

## Step 3: Route by Size

### Small Features (S)

1. Add to backlog with high score (since we're doing it now)
2. Implement directly
3. Update backlog status to "done"
4. Move to "Recently Completed"

```
✅ Added and completed: #[ID] - [feature]

What was done:
- [list of changes]

Updated backlog.md
```

### Medium Features (M)

1. Add to backlog
2. Quick confirmation: "This will take 1-4 hours. Build now or add to backlog for later?"

**If build now:**
- Implement directly
- Update backlog to "done"

**If later:**
- Leave in backlog with status "idea"
- Suggest running `/prioritize`

### Large Features (L)

1. Add to backlog with status "idea"
2. Redirect to spec workflow:

```
This is a larger feature that needs a spec.

Added to backlog: #[ID] - [feature]

Next: Run /create-spec [ID] to create the specification.
```

## Quick Implementation Checklist

For S/M features being built immediately:

- [ ] Database changes needed? (If yes, add migration)
- [ ] API routes needed? (Add to app/api/)
- [ ] Auth required? (Check permissions)
- [ ] What components? (Add to components/)
- [ ] Any edge cases? (Handle errors, empty states)

## After Implementation

Update the backlog:

1. Change status from "idea" → "done"
2. Move row to "Recently Completed" section
3. Update Quick Stats counts

Tell the user:
```
✅ Feature complete: #[ID] - [feature]

Changes:
- [file 1]
- [file 2]

Test at: [URL or action]

Backlog updated.
```

## Related Commands

- `/add-idea [description]` - Just capture, don't build
- `/create-spec [name]` - Create detailed spec for complex features
- `/implement-spec [name]` - Implement from existing spec
- `/prioritize` - Score and rank backlog items
