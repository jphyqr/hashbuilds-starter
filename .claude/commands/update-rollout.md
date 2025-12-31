# Update Rollout

Sync all deliverables documentation after completing work.

## Instructions

Ask the user: "What did you complete in this session?"

Then update the following files:

## 1. Update ROLLOUT.md

Open /deliverables/ROLLOUT.md and:
- Mark completed tasks with [x]
- Update phase status if needed (Not Started → In Progress → Complete)
- Update the "Last Updated" date
- Update "Next Steps" section

## 2. Update PROGRESS.md

Open /deliverables/PROGRESS.md and:
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

## 3. Update CHANGELOG.md (if releasing)

If this is a release/deployment:
- Add version entry under [Unreleased]
- Or create new version section if shipping to production

## 4. Verify Consistency

Make sure:
- ROLLOUT.md phase status matches actual progress
- PROGRESS.md entries are clear and dated
- CHANGELOG.md captures user-visible changes

## After Updating

Tell the user:
- "✅ Deliverables updated"
- Summary of what changed
- Suggest running `/update-client` if ready to notify client
