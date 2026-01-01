# Business Deep-Dives

**When to use this folder:** When the main [02-business-context.md](../02-business-context.md) isn't enough.

---

## Philosophy

Start with **one file** (02-business-context.md). Split into deep-dives when:
- A section exceeds ~50 lines
- You need to reference something frequently
- Multiple team members need to edit different sections

## Available Templates

| File | Purpose | When to Create |
|------|---------|----------------|
| [personas.md](personas.md) | Detailed user research, jobs-to-be-done | Multiple distinct user types, user interviews completed |
| [competitive.md](competitive.md) | Market analysis, feature comparisons | Crowded market, investor pitch prep |
| [pricing.md](pricing.md) | Revenue model, pricing tiers, unit economics | Complex pricing, multiple revenue streams |
| [kpis.md](kpis.md) | Metric definitions, targets, tracking | Beyond basic metrics, team alignment needed |
| [roadmap.md](roadmap.md) | Future planning, phase definitions | Post-MVP planning, stakeholder communication |

## Usage Pattern

```markdown
<!-- In business-context.md -->
## User Personas

### Primary: Solo Creator
[Brief summary here]

_For detailed persona research including jobs-to-be-done and interview quotes, see [business/personas.md](business/personas.md)._
```

## File Organization

```
docs/
├── 02-business-context.md ← Start here (CEO summary)
└── business/              ← Deep-dives (create as needed)
    ├── README.md          ← You are here
    ├── personas.md
    ├── competitive.md
    ├── pricing.md
    ├── kpis.md
    └── roadmap.md
```

---

_Don't create files you don't need. Empty templates are noise._
