# /docs/services - External Service Integrations

This folder contains configuration and setup documentation for all external services.

---

## Service Status

| Service | File | Status | Required? |
|---------|------|--------|-----------|
| Database | [DATABASE.md](DATABASE.md) | Decision needed | Yes |
| Authentication | [AUTH.md](AUTH.md) | Decision needed | Yes |
| Email | [EMAIL.md](EMAIL.md) | Decision needed | Usually |
| File Storage | [STORAGE.md](STORAGE.md) | Not started | Sometimes |
| Payments | [PAYMENTS.md](PAYMENTS.md) | Not started | Sometimes |
| SMS | [SMS.md](SMS.md) | Not started | Rarely |
| Analytics | [ANALYTICS.md](ANALYTICS.md) | Not started | Nice-to-have |

---

## How Each File Works

Every service file follows this structure:

1. **What It Does** - Brief explanation
2. **When You Need It** - Scenarios that require this service
3. **Decision Point** - Choices you need to make
4. **Recommended Setup** - Our default recommendations
5. **Setup Instructions** - Step-by-step guide
6. **Environment Variables** - Required `.env` additions
7. **Testing** - How to verify it works
8. **Troubleshooting** - Common issues

---

## Setup Order

**Recommended order for new projects:**

1. **DATABASE.md** - Set up database first (everything depends on it)
2. **AUTH.md** - Set up auth (most features need user context)
3. **EMAIL.md** - Set up email (auth needs it for magic links)
4. **STORAGE.md** - When you need file uploads
5. **PAYMENTS.md** - When you need to charge users
6. **ANALYTICS.md** - Before launch

---

## Adding New Services

When you need a service not listed here:

1. Create `SERVICE_NAME.md` in this folder
2. Follow the template structure above
3. Add to the status table in this README
4. Update `HANDOFF.md` with account ownership

---

## Account Ownership

All service accounts should be documented in [/docs/HANDOFF.md](../HANDOFF.md) with:
- Account owner
- Email used
- Whether client owns or needs transfer

---

_Services are the building blocks. Each file is a mini-guide._
