# Check Progress

Scan the project and report current status across all phases.

## Instructions

Scan the following areas and generate a status report:

### 1. Setup Docs (docs/)

Check each file for content beyond the template:

| File | Check For |
|------|-----------|
| 01-project-origin.md | Project name, client name filled in |
| 02-business-context.md | Business model, personas filled in |
| 03-design-system.md | Colors, fonts defined |
| 04-tech-stack.md | Any customizations from default |
| 05-coding-standards.md | Reference only (always "ready") |
| 06-auth-system.md | Reference only (always "ready") |
| 07-integration-test.md | Reference only (always "ready") |

**Status indicators:**
- ✅ Filled - Has real content
- ⬜ Empty - Still template/placeholder
- 📝 Partial - Some sections filled

### 2. Services (docs/services/)

Check each service doc for configuration status:

| File | Check For |
|------|-----------|
| 01-database.md | DATABASE_URL in .env, Prisma schema |
| 02-auth.md | NEXTAUTH_SECRET in .env |
| 03-email.md | RESEND_API_KEY in .env |
| 04-payments.md | STRIPE keys in .env |
| 05-storage.md | Storage config in .env |
| 06-sms.md | SMS provider in .env |
| 07-analytics.md | Analytics config |

**Status indicators:**
- ✅ Configured - Env vars present, docs filled
- ⬜ Not configured - No env vars
- ⚠️ Partial - Env vars but docs empty

### 3. Specs (specs/)

List all spec files and their status:

```
specs/
├── feature-name.md (Status: Ready/In Progress/Complete)
└── another-feature.md (Status: Planning)
```

Count by status:
- Planning: X
- Ready: X
- In Progress: X
- Complete: X

### 4. Code Status

Check for:
- `app/` - Number of page.tsx files (routes)
- `components/` - Number of component files
- `prisma/schema.prisma` - Number of models
- `app/api/` - Number of API routes

### 5. Last Session

Read `deliverables/progress.md` for:
- Most recent date entry
- What was completed
- "Next Session" items

### 6. Environment

Check `.env` exists and has content (don't read secrets, just check presence).

## Output Format

Generate this report:

```
📋 PROJECT STATUS
================

## Setup Docs
| Doc | Status |
|-----|--------|
| 01-project-origin | ✅ Filled |
| 02-business-context | ✅ Filled |
| 03-design-system | ⬜ Empty |
| 04-tech-stack | ✅ Default |

## Services
| Service | Status |
|---------|--------|
| Database | ✅ Configured (Neon) |
| Auth | ⬜ Not configured |
| Email | ⬜ Not configured |
| Payments | ⬜ Not needed |
| Storage | ⬜ Not needed |

## Specs
- Planning: 0
- Ready: 2
- In Progress: 1
- Complete: 0

## Codebase
- Routes: 5
- Components: 12
- Models: 3
- API Routes: 4

## Last Session
**Date:** Dec 31, 2024
**Completed:** Set up database, created user model
**Next:** Configure auth system

## Current Phase
**Phase 2: Services** - Database done, auth next

## Suggested Next Steps
1. Configure auth (docs/services/02-auth.md)
2. Set up email for magic links (docs/services/03-email.md)
3. Create first feature spec (/create-spec [name])
```

## After Report

Ask: "What would you like to work on?"

Suggest the most logical next step based on:
1. Incomplete setup docs → Fill those first
2. Missing required services → Configure those
3. No specs → Create first spec
4. Specs ready → Implement them
5. All done → GTM phase
