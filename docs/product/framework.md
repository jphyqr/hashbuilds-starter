# Prioritization Framework

<!--
PROMPT: Configure the prioritization framework for this project.

Ask these questions:

1. **Team Size:** "How many people are building this?"
   - Solo founder
   - 2-3 people
   - Small team (4-10)
   - Larger team (10+)

2. **Stage:** "What's more important right now?"
   - Speed to market (ship fast, learn fast)
   - Feature depth (build it right)
   - Scale (handle growth)

3. **Constraints:** "What's your biggest constraint?"
   - Time (deadline-driven)
   - Money (budget-limited)
   - People (resource-limited)
   - Technical debt (need to fix things)

Based on answers, recommend a framework:

| Situation | Recommended Framework |
|-----------|----------------------|
| Solo/small + speed focus | **ICE** (simple, fast decisions) |
| Growth stage + data available | **RICE** (data-driven) |
| Fixed deadline/scope | **MoSCoW** (scope management) |
| Resource-constrained | **Value vs Effort** (ROI focus) |
| Complex stakeholders | **Weighted Scoring** (transparent) |

Ask: "I recommend [framework] because [reason]. Does that work, or would you prefer a different approach?"

Then explain the chosen framework and have them confirm the weights.
-->

---

## Selected Framework

**Framework:** _[ICE / RICE / MoSCoW / Value vs Effort / Weighted Scoring]_

**Why:** _[1 sentence on why this fits]_

---

## Framework Details

### ICE Scoring (Simple & Fast)

Best for: Solo founders, early-stage, moving fast

| Factor | Scale | Weight |
|--------|-------|--------|
| **I**mpact | 1-10 (how much does it move the North Star?) | 1x |
| **C**onfidence | 1-10 (how sure are we this works?) | 1x |
| **E**ase | 1-10 (how easy to implement?) | 1x |

**Score = (I + C + E) / 3**

Quick reference:
- 8-10: Do immediately
- 5-7: Strong candidate
- 3-4: Maybe later
- 1-2: Probably not

---

### RICE Scoring (Data-Driven)

Best for: Growth stage, when you have usage data

| Factor | Definition | Scale |
|--------|------------|-------|
| **R**each | Users affected per quarter | Actual number |
| **I**mpact | Effect on North Star | 0.25 (minimal) to 3 (massive) |
| **C**onfidence | How sure are we? | 50% (low) to 100% (high) |
| **E**ffort | Person-weeks to build | Actual estimate |

**Score = (Reach × Impact × Confidence) / Effort**

---

### MoSCoW (Scope Management)

Best for: Fixed deadlines, client projects, MVPs

| Category | Definition | Rule |
|----------|------------|------|
| **Must** | Ship fails without this | Max 60% of capacity |
| **Should** | Important but not critical | 20% of capacity |
| **Could** | Nice to have | 10% of capacity |
| **Won't** | Explicitly out of scope | Document why |

---

### Value vs Effort (Quick ROI)

Best for: Resource-constrained, need quick wins

```
        │ High Value
        │
   ★★★  │  ★★
  Do    │  Plan
  First │  Carefully
────────┼────────
   ★    │  ✗
  Fill  │  Don't
  Time  │  Do
        │
        └─────────────
          Low    High
          Effort
```

---

## Current Configuration

**Active Framework:** _[name]_

**Scoring Weights (if applicable):**

| Factor | Weight | Notes |
|--------|--------|-------|
| _[Factor 1]_ | _[1x]_ | _[why]_ |
| _[Factor 2]_ | _[1x]_ | _[why]_ |
| _[Factor 3]_ | _[1x]_ | _[why]_ |

**Tie-breaker:** _[When scores are equal, prioritize: speed / quality / user impact]_

---

## Decision Log

Track major prioritization decisions:

| Date | Decision | Rationale |
|------|----------|-----------|
| _[date]_ | _[chose X over Y]_ | _[why]_ |

---

_Framework selected: [DATE]_
_Last reviewed: [DATE]_
