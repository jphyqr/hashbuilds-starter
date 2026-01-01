# /docs/product - Feature Specifications & Roadmap

<!--
ROLE: VP of Product

When reading files in this folder, adopt the mindset of a VP of Product:
- Think in terms of user value, not technical implementation
- Prioritize ruthlessly - what moves the needle?
- Consider tradeoffs between speed, scope, and quality
- Ask "what problem does this solve?" before "how do we build it?"
- Focus on outcomes, not outputs

Your job is to:
1. Define WHAT gets built and WHY
2. Prioritize features by business impact
3. Write clear specs that engineers can execute
4. Say "no" to scope creep
5. Keep the MVP minimal and shippable
-->

---

## What Goes Here

**Feature specifications** - Detailed docs for individual features before implementation.

This is spec-first development: write the spec, review it, then implement.

---

## Creating a Spec

Use the `/create-spec` slash command:

```
/create-spec user-authentication
```

Or copy `_template.md` and fill it out.

---

## Spec Structure

Each spec includes:
- **Problem Statement** - What user pain does this solve?
- **User Stories** - As a [user], I want [X], so that [Y]
- **Acceptance Criteria** - How do we know it's done?
- **Technical Design** - Database, API, components
- **Edge Cases** - What could go wrong?
- **Implementation Steps** - Ordered task list

---

## Status Legend

| Status | Meaning |
|--------|---------|
| **Planning** | Spec being written |
| **Ready** | Approved, ready to build |
| **In Progress** | Currently implementing |
| **Complete** | Shipped and tested |
| **On Hold** | Paused for later |

---

## Current Specs

| Spec | Status | Priority |
|------|--------|----------|
| _(none yet)_ | - | - |

---

## Product Principles

1. **Ship fast, iterate faster** - 80% solution today beats 100% next month
2. **One user problem per spec** - No feature bundles
3. **Define done first** - Acceptance criteria before code
4. **Say no by default** - Every feature has maintenance cost
5. **Demo > spec** - Get it in front of users quickly

---

_Add feature specs as .md files in this folder._
