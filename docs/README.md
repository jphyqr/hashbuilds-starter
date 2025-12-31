# /docs - Developer Documentation

This folder contains all internal developer documentation. These files are NOT client-facing.

---

## Core Context Files

| File | Type | Purpose |
|------|------|---------|
| [PROJECT_ORIGIN.md](PROJECT_ORIGIN.md) | Static | Original brief, client info, timeline, deal structure. **Never changes after initial setup.** |
| [BUSINESS_CONTEXT.md](BUSINESS_CONTEXT.md) | Living | Business model, user personas, workflows. Updates as understanding evolves. |
| [TECH_STACK.md](TECH_STACK.md) | Living | Architecture decisions, conventions, dependencies. |
| [HANDOFF.md](HANDOFF.md) | Living | Account ownership, credentials, transfer checklist. |
| [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) | Reference | First-time setup guide for new developers. |

---

## Subfolders

### `/services/` - External Integrations

Configuration and setup docs for each external service. Each file includes:
- What the service does
- When you need it
- Decision prompts for opinionated choices
- Setup instructions
- Troubleshooting

| File | Service | Status |
|------|---------|--------|
| [DATABASE.md](services/DATABASE.md) | PostgreSQL (Neon/Supabase) | Decision needed |
| [AUTH.md](services/AUTH.md) | NextAuth.js | Decision needed |
| [EMAIL.md](services/EMAIL.md) | Resend | Decision needed |
| [STORAGE.md](services/STORAGE.md) | Vercel Blob / S3 | Decision needed |
| [PAYMENTS.md](services/PAYMENTS.md) | Stripe | Not started |
| [SMS.md](services/SMS.md) | Twilio | Not started |
| [ANALYTICS.md](services/ANALYTICS.md) | Vercel Analytics / PostHog | Not started |

### `/features/` - Feature Specifications

Detailed specs for each feature. Use the template in [features/README.md](features/README.md).

### `/plans/` - Implementation Roadmaps

Phase-based implementation plans. Use the template in [plans/README.md](plans/README.md).

---

## How to Use This Folder

### When Starting the Project
1. Fill out `PROJECT_ORIGIN.md` with client info
2. Fill out `BUSINESS_CONTEXT.md` with what you're building
3. Go through `SETUP_CHECKLIST.md` to set up services

### When Adding a Service
1. Open the relevant `/services/*.md` file
2. Follow the decision prompts
3. Add credentials to `.env`
4. Update `HANDOFF.md` with account ownership

### When Adding a Feature
1. Create a spec in `/features/feature-name.md`
2. Reference the spec while implementing
3. Update the spec with any changes

### When Handing Off the Project
1. Review `HANDOFF.md` for account transfer list
2. Ensure all credentials are documented
3. Update `TECH_STACK.md` with final architecture

---

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Core context | UPPERCASE_SNAKE.md | BUSINESS_CONTEXT.md |
| Service docs | UPPERCASE.md | DATABASE.md |
| Feature specs | lowercase-kebab.md | user-authentication.md |
| Plan docs | PHASE_NAME.md | MVP_PHASE1.md |

---

_All files in /docs are for developer reference only. Client-facing docs go in /deliverables._
