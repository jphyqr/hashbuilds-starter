# /docs/product - Product Management

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

## Files in This Folder

| File | Purpose | When to Fill |
|------|---------|--------------|
| [north-star.md](north-star.md) | ONE metric that defines success | First - before prioritizing |
| [framework.md](framework.md) | Prioritization method (ICE/RICE/etc) | Second - choose your scoring system |
| [backlog.md](backlog.md) | ALL ideas with scores and status | Living doc - single source of truth |
| [_template.md](_template.md) | Blank spec template | Reference for new specs |
| `[feature].md` | Individual feature specs | When building complex (L-sized) features |

---

## The Workflow

```
  Idea → Backlog → Score → Decide → Build or Spec → Done
    ↓        ↓        ↓        ↓           ↓          ↓
 /add-idea  backlog.md  /prioritize  S/M: build   /create-spec  Update
                                     L: spec      /implement    backlog
```

### 1. Capture Everything

Every idea goes to the backlog first:
```
/add-idea dark mode toggle
```

### 2. Prioritize

Score all unscored items using your chosen framework:
```
/prioritize
```

### 3. Decide and Execute

| Size | Action |
|------|--------|
| **S** (< 1hr) | Build directly with `/new-feature` |
| **M** (1-4hr) | Build or quick spec, your call |
| **L** (> 4hr) | Create spec first with `/create-spec` |

### 4. Track Completion

Update backlog status as you work. Move done items to "Recently Completed".

---

## Commands

| Command | Purpose |
|---------|---------|
| `/add-idea [description]` | Capture idea to backlog |
| `/prioritize` | Score and rank all backlog items |
| `/new-feature [name]` | Build feature (routes through backlog) |
| `/create-spec [name or #ID]` | Create detailed spec for complex feature |
| `/implement-spec [name]` | Build from existing spec |

---

## Quick Start

**New project?**
1. Fill out [north-star.md](north-star.md) - what's your ONE metric?
2. Fill out [framework.md](framework.md) - how will you prioritize?
3. Start adding ideas with `/add-idea`

**Ready to build?**
1. Run `/prioritize` to score your backlog
2. Pick the top item
3. Build (S/M) or spec first (L)

---

## Product Principles

1. **Ship fast, iterate faster** - 80% solution today beats 100% next month
2. **One user problem per spec** - No feature bundles
3. **Define done first** - Acceptance criteria before code
4. **Say no by default** - Every feature has maintenance cost
5. **Demo > spec** - Get it in front of users quickly
6. **Backlog is the source of truth** - If it's not in backlog, it doesn't exist

---

## Spec Status Legend

| Status | Meaning |
|--------|---------|
| **Planning** | Spec being written |
| **Ready** | Approved, ready to build |
| **In Progress** | Currently implementing |
| **Complete** | Shipped and tested |
| **On Hold** | Paused for later |

---

_Think like a VP of Product. Prioritize ruthlessly. Ship what matters._
