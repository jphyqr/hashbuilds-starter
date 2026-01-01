# Product Backlog

<!--
This is the SINGLE SOURCE OF TRUTH for what to build.

Every idea, feature request, and bug goes here first.
Use /add-idea to add items, /prioritize to score them.

Workflow:
1. Idea captured → Added here with status "idea"
2. /prioritize run → Gets a score based on framework.md
3. Top items reviewed → Decide: build now, spec first, or defer
4. Small items → Build directly, update status to "done"
5. Complex items → /create-spec, link back here, status "spec-ready"
6. After implementation → Status "done"
-->

---

## Quick Stats

| Status | Count |
|--------|-------|
| Ideas (unscored) | 0 |
| Scored (ready to decide) | 0 |
| In Progress | 0 |
| Spec Ready | 0 |
| Done | 0 |

---

## Backlog

<!--
Column definitions:
- ID: Auto-increment, used for reference
- Idea: Short description (1 line)
- Size: S (< 1hr), M (1-4hr), L (> 4hr / needs spec)
- Score: From /prioritize command (or ? if unscored)
- Status: idea | scored | in-progress | spec-ready | done | wont-do
- Spec: Link to spec file if L-sized
- Notes: Brief context
-->

| ID | Idea | Size | Score | Status | Spec | Notes |
|----|------|------|-------|--------|------|-------|
| _1_ | _[Example: User authentication]_ | _L_ | _85_ | _spec-ready_ | _[user-auth.md](user-auth.md)_ | _MVP critical_ |
| _2_ | _[Example: Contact form]_ | _S_ | _72_ | _done_ | _-_ | _Shipped 1/1_ |
| _3_ | _[Example: Dark mode]_ | _M_ | _?_ | _idea_ | _-_ | _User requested_ |

---

## Recently Completed

<!-- Move items here when done, keeps main backlog clean -->

| ID | Idea | Completed | Notes |
|----|------|-----------|-------|
| _-_ | _-_ | _-_ | _-_ |

---

## Won't Do (Documented)

<!-- Important to track what we decided NOT to build and why -->

| ID | Idea | Reason | Date |
|----|------|--------|------|
| _-_ | _-_ | _-_ | _-_ |

---

## Size Guidelines

| Size | Time | Spec Needed? | Examples |
|------|------|--------------|----------|
| **S** | < 1 hour | No | Bug fix, copy change, simple component |
| **M** | 1-4 hours | Optional | New page, API endpoint, form |
| **L** | > 4 hours | Yes | New feature, integration, refactor |

---

## How to Use

**Add an idea:**
```
/add-idea [description]
```
Adds to backlog with status "idea" and score "?"

**Score all ideas:**
```
/prioritize
```
Reads framework.md, scores unscored items, re-sorts backlog

**Promote to spec:**
```
/create-spec [id or name]
```
Creates spec file, links it here, updates status to "spec-ready"

**Mark done:**
Update status to "done" and move to "Recently Completed"

---

_Last prioritized: [DATE]_
_Total items: 0_
