# Update Rollout

Sync all deliverables documentation after completing work.

## Instructions

First, run a quick status check by scanning:
- `.env` for configured services
- `specs/` for feature status
- `app/` for routes and components
- `prisma/schema.prisma` for models

Then ask the user: "What did you complete in this session?"

Update the following files:

## 1. Update rollout.md

Open /deliverables/rollout.md and:
- Mark completed tasks with [x] based on actual project state:
  - Database: Check if DATABASE_URL in .env
  - Auth: Check if NEXTAUTH_SECRET in .env
  - Email: Check if RESEND_API_KEY in .env
  - Deployed: Check if production URL is set
- Update phase status if needed (Not Started → In Progress → Complete)
- Update the "Last Updated" date to today
- Update "Next Steps" section with logical next action

## 2. Update progress.md

Open /deliverables/progress.md and:
- Add a new date entry at the top (below the header)
- List completed items under "### Completed"
- Note any decisions under "### Decisions Made"
- Add issues encountered if any
- List next session tasks

Format:
```markdown
## [TODAY'S DATE] - [Brief Title]

### Completed
- Item 1
- Item 2

### Decisions Made
- Decision about X

### Next Session
- [ ] Task 1
- [ ] Task 2

---
```

## 3. Update changelog.md (if releasing)

If this is a release/deployment:
- Add version entry under [Unreleased]
- Or create new version section if shipping to production

## 4. Verify Consistency

Make sure:
- rollout.md phase status matches actual progress
- progress.md entries are clear and dated
- changelog.md captures user-visible changes

## After Updating

Tell the user:
- "✅ Deliverables updated"
- Summary of what changed
- Suggest running `/update-client` if ready to notify client
