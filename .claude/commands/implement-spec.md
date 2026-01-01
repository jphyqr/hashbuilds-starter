# Implement Spec

Implement a feature from its specification file.

## Instructions

**Argument:** `$ARGUMENTS` (spec name, e.g., "user-authentication")

If no argument provided, list available specs from `/docs/product/*.md` and ask which one to implement.

## Before Starting

1. **Read the spec file:** `/docs/product/$ARGUMENTS.md`
2. **Check status:** If status is "Planning", tell user to finalize the spec first
3. **Review implementation steps:** Understand the full scope before coding

## Implementation Process

### Step 1: Update Status

Change the spec status to "In Progress":

```markdown
**Status:** In Progress
```

### Step 2: Follow Implementation Steps

Work through each step in the spec's "Implementation Steps" section:

1. Check off each step as you complete it
2. Follow the phase order (Backend → Frontend → Polish)
3. Test each phase before moving to the next

### Step 3: For Each Step

Before coding, announce what you're doing:
- "Implementing Step 1: Adding Prisma models..."
- "Implementing Step 5: Creating components..."

After completing each step:
- Update the checkbox in the spec: `- [x] Step completed`
- Verify it works before moving on

### Step 4: Check Acceptance Criteria

After implementation, verify each acceptance criterion:
- Test each criterion manually or with automated tests
- Check off criteria that pass: `- [x] Criterion met`
- Note any issues found

### Step 5: Run Testing Checklist

Go through the Testing Checklist in the spec:
- Check each item
- Note any failures
- Fix issues before marking complete

### Step 6: Update Status

When all steps and criteria are complete:

```markdown
**Status:** Complete
**Last Updated:** [TODAY'S DATE]
```

## During Implementation

### If You Encounter Issues

1. Note the issue in the spec under a new "## Issues Found" section
2. Ask the user how to proceed if it's a blocker
3. Document the solution once resolved

### If Scope Changes

1. Stop and discuss with user
2. Update spec if changes are approved
3. Continue implementation

### Progress Updates

Keep the user informed:
- "Completed Phase 1 (Backend). Moving to Phase 2 (Frontend)..."
- "5 of 12 implementation steps complete..."
- "Found an edge case not in spec: [description]. Adding handling..."

## After Implementation

Tell the user:

1. "✅ Feature implemented: $ARGUMENTS"
2. Summary of what was built:
   - Files created/modified
   - Database changes (if any)
   - Components added
3. "Test the feature at [relevant URL/action]"
4. Any follow-up items or known limitations

## Quality Checks

Before marking complete, verify:

- [ ] All implementation steps checked off
- [ ] All acceptance criteria met
- [ ] Testing checklist passed
- [ ] No console errors
- [ ] Mobile responsive (if applicable)
- [ ] Edge cases handled
- [ ] Security considerations addressed

## Example Flow

```
User: /implement-spec user-authentication

Claude:
1. Reads /docs/product/user-authentication.md
2. Updates status to "In Progress"
3. "Implementing Step 1: Adding Prisma models..."
   - Creates User, Account, Session models
   - Runs migration
   - "✓ Step 1 complete"
4. "Implementing Step 2: Create API routes..."
   - Creates auth routes
   - "✓ Step 2 complete"
5. [Continues through all steps]
6. "Verifying acceptance criteria..."
   - Tests each criterion
7. "✅ Feature implemented: user-authentication"
   - Lists what was created
   - Provides testing instructions
```

## Tips

- Read the ENTIRE spec before starting
- Follow the phase order - backend before frontend
- Test frequently, not just at the end
- Update the spec as you go
- Ask questions if spec is unclear
