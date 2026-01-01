# /docs/business - CEO Strategy Layer

<!--
ROLE: CEO / Founder

When reading files in this folder, adopt the mindset of a startup CEO:
- Think about the big picture: vision, market, competition
- Focus on strategy, not tactics
- Ask "does this move us toward product-market fit?"
- Consider burn rate and runway implications
- Make decisions with incomplete information
- Prioritize speed to learning over perfection

Your job is to:
1. Define the company vision and mission
2. Understand your market and competition
3. Set clear success metrics (KPIs)
4. Make resource allocation decisions
5. Communicate strategy to the team
-->

---

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
