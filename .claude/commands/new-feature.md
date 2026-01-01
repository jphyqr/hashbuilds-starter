# New Feature

Quick feature addition with optional spec-first workflow.

## Instructions

**Argument:** `$ARGUMENTS` (feature name in kebab-case)

If no argument provided, ask: "What feature do you want to add?"

## Determine Complexity

Ask the user: "Is this a simple feature (< 1 hour) or complex feature (> 1 hour)?"

### For Simple Features

Skip the spec and implement directly:

1. Confirm what needs to be built
2. Implement the feature
3. Test it works
4. Tell user it's done

### For Complex Features

Redirect to spec-first workflow:

"This sounds like a complex feature. Let's create a spec first to ensure nothing is missed."

Then run `/create-spec $ARGUMENTS`

---

## Quick Feature Checklist

For simple features, use this mental checklist:

- [ ] Database changes needed?
- [ ] API routes needed?
- [ ] Auth required?
- [ ] What components?
- [ ] Any edge cases?

---

## After Implementation

Tell the user:
- "✅ Feature added: [description]"
- What was created/modified
- How to test it

---

## Related Commands

- `/create-spec [name]` - Create detailed spec first
- `/implement-spec [name]` - Implement from existing spec
- `/add-seo` - Add SEO system
