# /docs/services - External Service Integrations

<!--
ROLE: DevOps / Platform Engineer

When reading files in this folder, adopt the mindset of a platform engineer:
- Think about reliability, scalability, and security
- Focus on infrastructure that "just works"
- Ask "what happens when this fails?"
- Consider cost at scale (not just MVP pricing)
- Prefer managed services over self-hosted
- Document everything for the next engineer

Your job is to:
1. Set up reliable infrastructure
2. Configure external services correctly
3. Manage environment variables and secrets
4. Ensure services can scale with usage
5. Document setup for handoff

Services are numbered in setup order. Each file has an embedded PROMPT.
Claude Code will ask you questions and help configure each service.

**Required services:**
1. 01-database.md → Everything depends on this
2. 03-email.md → Auth needs this for magic links

**Optional services (skip if not needed for MVP):**
3. 04-payments.md → Only if charging users
4. 05-storage.md → Only if users upload files
5. 06-sms.md → Rarely needed (email usually suffices)
6. 07-analytics.md → Set up before launch

**Note:** Auth is handled in [docs/06-auth-system.md](../06-auth-system.md) - it's an architecture concern, not an external service.
-->

---

## Service Status

| # | Service | File | Required? | Status |
|---|---------|------|-----------|--------|
| 1 | Database | [01-database.md](01-database.md) | Yes | [ ] Not started |
| 2 | Email | [03-email.md](03-email.md) | Usually | [ ] Not started |
| 3 | Payments | [04-payments.md](04-payments.md) | Sometimes | [ ] Not started |
| 4 | File Storage | [05-storage.md](05-storage.md) | Sometimes | [ ] Not started |
| 5 | SMS | [06-sms.md](06-sms.md) | Rarely | [ ] Not started |
| 6 | Analytics | [07-analytics.md](07-analytics.md) | Before launch | [ ] Not started |

> **Auth:** See [docs/06-auth-system.md](../06-auth-system.md) - handled as architecture, not external service.

---

## How Each File Works

Every service file has:

1. **Embedded PROMPT** - Claude Code asks you questions
2. **What It Does** - Brief explanation
3. **When You Need It** - Scenarios requiring this service
4. **Decision Points** - Choices you need to make
5. **Setup Instructions** - Step-by-step guide
6. **Environment Variables** - Required `.env` additions
7. **Testing** - How to verify it works
8. **Status Checklist** - Track your progress

---

## Adding New Services

When you need a service not listed here:

1. Create `0X-service-name.md` (pick next number)
2. Add embedded PROMPT at top
3. Follow the existing file structure
4. Add to the status table above
5. Update [handoff.md](../handoff.md) with account ownership

---

## Account Ownership

All service accounts should be documented in [/docs/handoff.md](../handoff.md) with:
- Account owner
- Email used
- Whether client owns or needs transfer

---

_Go through files 01 → 07 in order. Skip optional ones you don't need._
