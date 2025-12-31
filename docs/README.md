# /docs - Developer Documentation

This folder contains all internal developer documentation. These files are NOT client-facing.

---

## Core Context Files

| File | Type | Purpose |
|------|------|---------|
| [project-origin.md](project-origin.md) | Static | Original brief, client info, timeline, deal structure. **Never changes after initial setup.** |
| [business-context.md](business-context.md) | Living | Business model, user personas, workflows. Updates as understanding evolves. |
| [tech-stack.md](tech-stack.md) | Living | Architecture decisions, conventions, dependencies. |
| [handoff.md](handoff.md) | Living | Account ownership, credentials, transfer checklist. |
| [setup-checklist.md](setup-checklist.md) | Reference | First-time setup guide for new developers. |

---

## Subfolders

### `/business/` - CEO Layer Deep-Dives

Detailed business documentation when summaries aren't enough. See [business/README.md](business/README.md).

| File | When to Create |
|------|----------------|
| [personas.md](business/personas.md) | Detailed user research, jobs-to-be-done |
| [competitive.md](business/competitive.md) | Market analysis, feature comparisons |
| [pricing.md](business/pricing.md) | Revenue model, unit economics |
| [kpis.md](business/kpis.md) | Metric definitions, tracking |
| [roadmap.md](business/roadmap.md) | Future planning beyond MVP |

### `/services/` - External Integrations

Configuration and setup docs for each external service. Each file includes:
- What the service does
- When you need it
- Decision prompts for opinionated choices
- Setup instructions
- Troubleshooting

| File | Service | Status |
|------|---------|--------|
| [database.md](services/database.md) | PostgreSQL (Neon/Supabase) | Decision needed |
| [auth.md](services/auth.md) | NextAuth.js | Decision needed |
| [email.md](services/email.md) | Resend | Decision needed |
| [storage.md](services/storage.md) | Vercel Blob / S3 | Decision needed |
| [payments.md](services/payments.md) | Stripe | Not started |
| [sms.md](services/sms.md) | Twilio | Not started |
| [analytics.md](services/analytics.md) | Vercel Analytics / PostHog | Not started |

### `/features/` - Feature Specifications

Detailed specs for each feature. Use the template in [features/README.md](features/README.md).

### `/plans/` - Implementation Roadmaps

Phase-based implementation plans. Use the template in [plans/README.md](plans/README.md).

---

## How to Use This Folder

### When Starting the Project
1. Fill out `project-origin.md` with client info
2. Fill out `business-context.md` with what you're building
3. Go through `setup-checklist.md` to set up services

### When Adding a Service
1. Open the relevant `/services/*.md` file
2. Follow the decision prompts
3. Add credentials to `.env`
4. Update `handoff.md` with account ownership

### When Adding a Feature
1. Create a spec in `/features/feature-name.md`
2. Reference the spec while implementing
3. Update the spec with any changes

### When Handing Off the Project
1. Review `handoff.md` for account transfer list
2. Ensure all credentials are documented
3. Update `tech-stack.md` with final architecture

---

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Core context | lowercase-kebab.md | business-context.md |
| Service docs | lowercase.md | database.md |
| Feature specs | lowercase-kebab.md | user-authentication.md |
| Plan docs | phase-name.md | mvp-phase1.md |

---

_All files in /docs are for developer reference only. Client-facing docs go in /deliverables._
