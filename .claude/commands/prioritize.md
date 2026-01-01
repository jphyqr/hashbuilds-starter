# Prioritize

Score and rank all backlog items using the configured prioritization framework.

## Instructions

### 1. Read Configuration

First, read these files:
- `/docs/product/north-star.md` - What metric are we optimizing for?
- `/docs/product/framework.md` - What scoring framework are we using?
- `/docs/product/backlog.md` - What items need scoring?

### 2. Check Prerequisites

**If north-star.md is empty:**
```
⚠️ North Star metric not defined.

Before prioritizing, you need to define what success looks like.
Run the embedded prompt in /docs/product/north-star.md first.
```

**If framework.md is empty:**
```
⚠️ Prioritization framework not configured.

Before scoring, choose a framework that fits your situation.
Run the embedded prompt in /docs/product/framework.md first.
```

### 3. Find Unscored Items

Look for items in backlog.md where Score = "?"

If no unscored items:
```
✅ All backlog items are scored.

Top 3 priorities:
1. #[ID] - [idea] (Score: [X])
2. #[ID] - [idea] (Score: [X])
3. #[ID] - [idea] (Score: [X])

What would you like to do?
- /create-spec [ID] - Spec out a complex item
- Build #[ID] directly - For small items
- /add-idea - Capture a new idea
```

### 4. Score Each Unscored Item

For each item with "?" score, apply the configured framework:

#### ICE Scoring (if framework = ICE)

For each item, assess:

**Impact (1-10):** "How much will this move the North Star metric?"
- 10: Directly drives the metric significantly
- 7-9: Strong positive effect
- 4-6: Moderate effect
- 1-3: Minimal effect

**Confidence (1-10):** "How sure are we this will work?"
- 10: Proven pattern, done it before
- 7-9: High confidence, low risk
- 4-6: Reasonable confidence, some unknowns
- 1-3: Experimental, high uncertainty

**Ease (1-10):** "How easy is this to implement?"
- 10: Trivial, < 1 hour
- 7-9: Straightforward, few dependencies
- 4-6: Moderate complexity
- 1-3: Complex, many dependencies

**Score = (I + C + E) / 3 × 10** (gives 0-100 scale)

#### RICE Scoring (if framework = RICE)

**Reach:** How many users per quarter?
**Impact:** 0.25 (minimal) to 3 (massive)
**Confidence:** 50% to 100%
**Effort:** Person-weeks

**Score = (Reach × Impact × Confidence) / Effort**

Normalize to 0-100 scale for comparison.

#### MoSCoW (if framework = MoSCoW)

Assign category: Must (100), Should (75), Could (50), Won't (0)

#### Value vs Effort (if framework = Value/Effort)

**Value:** 1-10
**Effort:** 1-10
**Score = (Value / Effort) × 10** (0-100 scale)

### 5. Present Scores for Review

Show the scoring for each item:

```
📊 Scoring #[ID]: [idea]

Framework: ICE
- Impact: [X] - [brief reason]
- Confidence: [X] - [brief reason]
- Ease: [X] - [brief reason]

Score: [calculated] → [rounded to nearest 5]

Accept this score? (y/n/adjust)
```

If user wants to adjust, let them override.

### 6. Update Backlog

After all items scored:
1. Update the Score column for each item
2. Change Status from "idea" to "scored"
3. Re-sort the table by Score (highest first)
4. Update "Last prioritized" date
5. Update Quick Stats counts

### 7. Present Results

```
✅ Prioritization complete!

## Updated Rankings

| Rank | ID | Idea | Score | Size | Recommendation |
|------|-----|------|-------|------|----------------|
| 1 | #[X] | [idea] | [score] | [S/M/L] | [Build now / Spec first / Defer] |
| 2 | #[X] | [idea] | [score] | [S/M/L] | [recommendation] |
| 3 | #[X] | [idea] | [score] | [S/M/L] | [recommendation] |

## Recommendations

**Build Now (High score + Small):**
- #[ID] - [idea]

**Spec First (High score + Large):**
- #[ID] - [idea] → /create-spec [ID]

**Defer (Low score):**
- #[ID] - [idea]

What would you like to work on?
```

### Recommendation Logic

| Score | Size | Recommendation |
|-------|------|----------------|
| 70+ | S | Build now |
| 70+ | M | Build now or quick spec |
| 70+ | L | Spec first |
| 50-69 | S/M | Build if time permits |
| 50-69 | L | Defer until higher priorities done |
| < 50 | Any | Defer or reconsider |

## Notes

- Scoring is meant to be fast, not perfect
- Trust gut instinct + data when available
- Re-prioritize when context changes (new info, pivot, etc.)
- Items can be re-scored if circumstances change
