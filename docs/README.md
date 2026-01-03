# /docs - Developer Documentation

<!--
HOW TO USE THIS FOLDER:

Files are numbered in the order you should complete them.
Each file has a PROMPT section at the top - Claude Code will ask you questions and fill in the answers.

**The order:**
1. 01-project-origin.md → Who's the client? What are we building?
2. 02-business-context.md → Business model, personas, workflows
3. 03-design-system.md → Colors, fonts, aesthetic
4. 04-tech-stack.md → Confirm/customize the stack (usually just confirm)

**Then services (in /services folder):**
1. 01-database.md → Set up Neon/PostgreSQL
2. 03-email.md → Set up Resend
3. 04-payments.md → (Optional) Set up Stripe
4. 05-storage.md → (Optional) Set up file uploads
5. 06-sms.md → (Optional) Set up Twilio
6. 07-analytics.md → Set up before launch

**Note:** Auth is in 06-auth-system.md (core docs, not services)

**Skip files you don't need.** Come back to optional ones later.
-->

---

## Core Files (In Order)

| # | File | Purpose | Type |
|---|------|---------|------|
| 1 | [01-project-origin.md](01-project-origin.md) | Client info, brief, deal structure | Static (never changes) |
| 2 | [02-business-context.md](02-business-context.md) | Business model, personas, workflows | Living |
| 3 | [03-design-system.md](03-design-system.md) | Colors, fonts, aesthetic | Living |
| 4 | [04-tech-stack.md](04-tech-stack.md) | Architecture, conventions | Reference |

---

## Services (In Order)

See [services/README.md](services/README.md) for details.

| # | File | Required? | Purpose |
|---|------|-----------|---------|
| 1 | [01-database.md](services/01-database.md) | Yes | PostgreSQL (Neon) |
| 2 | [03-email.md](services/03-email.md) | Usually | Resend (for magic links) |
| 3 | [04-payments.md](services/04-payments.md) | Sometimes | Stripe |
| 4 | [05-storage.md](services/05-storage.md) | Sometimes | Vercel Blob |
| 5 | [06-sms.md](services/06-sms.md) | Rarely | Twilio |
| 6 | [07-analytics.md](services/07-analytics.md) | Before launch | Vercel Analytics |

> **Auth:** See [06-auth-system.md](06-auth-system.md) - it's architecture, not an external service.

---

## Other Folders

### `/business/` - CEO Layer Deep-Dives

Create these when you need more detail than `02-business-context.md` provides:

| File | When to Create |
|------|----------------|
| [personas.md](business/personas.md) | Detailed user research |
| [competitive.md](business/competitive.md) | Market analysis |
| [pricing.md](business/pricing.md) | Revenue model details |
| [kpis.md](business/kpis.md) | Metric definitions |
| [roadmap.md](business/roadmap.md) | Future planning |

### `/product/` - Feature Specifications

Feature specs live in `/docs/product/`.
Use `/create-spec` and `/implement-spec` commands for spec-first development.
See [product/README.md](product/README.md) for the VP of Product role-priming.

---

## Handoff

When ready to hand off the project, see [handoff.md](handoff.md) for:
- Account ownership
- Credential locations
- Transfer checklist

---

_All files in /docs are for developer reference. Client-facing docs go in /deliverables._
