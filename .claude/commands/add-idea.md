# Add Idea

Capture a feature idea, bug, or task to the product backlog.

## Instructions

**Argument:** `$ARGUMENTS` (the idea description)

If no argument provided, ask: "What's the idea? (One sentence)"

## Steps

### 1. Read the Backlog

Open `/docs/product/backlog.md` and find the highest existing ID number.

### 2. Gather Quick Details

Ask these questions quickly (don't overthink):

1. **Size estimate:**
   - S (< 1 hour) - bug fix, copy change, simple tweak
   - M (1-4 hours) - new page, API endpoint, form
   - L (> 4 hours) - needs a full spec

2. **Any context?** (optional - origin, requester, deadline)

### 3. Add to Backlog

Add a new row to the backlog table in `/docs/product/backlog.md`:

```markdown
| [next ID] | [idea description] | [S/M/L] | ? | idea | - | [context if any] |
```

### 4. Update Quick Stats

Increment the "Ideas (unscored)" count in the Quick Stats section.

### 5. Confirm

Tell the user:

```
✅ Added to backlog: #[ID] - [idea]

Size: [S/M/L]
Status: idea (unscored)

Next steps:
- Run /prioritize to score all ideas
- Or /create-spec [ID] if this is urgent and needs a spec
```

## Examples

**Input:** `/add-idea dark mode toggle`

**Output:**
```
Quick questions:

1. Size estimate?
   - S (< 1 hour)
   - M (1-4 hours)  ← [user picks M]
   - L (> 4 hours)

2. Any context? (optional)
   → "User requested on Twitter"

✅ Added to backlog: #4 - Dark mode toggle

Size: M
Status: idea (unscored)
Context: User requested on Twitter

Next steps:
- Run /prioritize to score all ideas
- Or /create-spec 4 if this is urgent
```

## Notes

- Every idea goes through the backlog - no exceptions
- Don't score during capture (that's what /prioritize is for)
- L-sized items will need a spec before implementation
- Keep descriptions to one line - details go in the spec
