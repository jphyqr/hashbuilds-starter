# End Session

Wrap up this development session by documenting what was accomplished.

## Instructions

When the user runs `/end-session`, follow these steps:

### Step 1: Gather Session Summary

Ask the user (or review conversation if clear):
- "What did we accomplish this session?"
- "Any decisions made I should document?"
- "Any issues encountered?"
- "What should we tackle next session?"

If the conversation makes these obvious, don't ask—just summarize.

### Step 2: Update Progress Log

Add a new entry to `/deliverables/progress.md` with today's date:

```markdown
## [YYYY-MM-DD] - [Brief Title Based on Work]

### Completed
- Item 1
- Item 2
- Item 3

### Decisions Made
- Decision about X because Y (if any)

### Issues Encountered
- Issue with Z, resolved by doing W (if any)

### Next Session
- [ ] Task 1
- [ ] Task 2

---
```

**Important:** Add new entries at the TOP of the file (after the header), not at the bottom.

### Step 3: Update Spec Status (If Applicable)

If we were implementing a spec from `/docs/product/`:
1. Update the spec's `Status:` field (In Progress → Complete, or note progress)
2. Add any implementation notes to the spec

### Step 4: Code Health Check

Before wrapping up, do a quick code health scan:

1. **Pattern violations:** Did we deviate from documented patterns in `/docs/architecture/`?
   - If yes, ask: "Should we update the pattern docs, or was this a one-off?"

2. **Tech debt introduced:** Did we take any shortcuts?
   - If yes, log to `/docs/architecture/code-health.md` under Tech Debt Log

3. **New patterns established:** Did we create a reusable pattern?
   - If yes, ask: "Should I add this to the architecture docs?"

4. **Anti-patterns spotted:** Did we do anything that shouldn't be repeated?
   - If yes, add to Anti-Patterns section in code-health.md

Only ask about these if they actually occurred during the session.

### Step 5: Quick Status Report

After updating, give the user a summary:

```
✅ Session Logged: [Date] - [Title]

Completed: X items
Next session: Y tasks planned

Files updated:
- deliverables/progress.md
- [any specs updated]

Code health:
- [any pattern notes, or "✓ No issues"]
```

### Step 6: Offer Client Update (Optional)

Ask: "Should I also update the client-facing rollout? (y/n)"

If yes, run the logic from `/update-client` to refresh `/deliverables/rollout.md`.

## Example Output

```
📝 Session Summary

Date: 2025-01-15
Title: Database & Auth Setup

### Completed
- Set up PostgreSQL with Neon
- Configured Prisma schema with User model
- Implemented NextAuth with magic links
- Created protected admin routes

### Decisions
- Using Neon for serverless PostgreSQL (free tier works for MVP)
- Magic link auth only (no passwords to manage)

### Next Session
- [ ] Set up email service (Resend)
- [ ] Create first feature spec
- [ ] Build landing page

✅ Progress log updated!

Update client rollout? (y/n)
```

## Notes

- Keep entries concise—this is a log, not a novel
- Use past tense for completed items
- Use imperative for next session tasks
- If nothing notable happened, it's okay to skip the entry
