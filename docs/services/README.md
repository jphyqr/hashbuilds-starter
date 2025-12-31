# /docs/services - External Service Integrations

This folder contains configuration and setup documentation for all external services.

---

## Service Status

| Service | File | Status | Required? |
|---------|------|--------|-----------|
| Database | [database.md](database.md) | Decision needed | Yes |
| Authentication | [auth.md](auth.md) | Decision needed | Yes |
| Email | [email.md](email.md) | Decision needed | Usually |
| File Storage | [storage.md](storage.md) | Not started | Sometimes |
| Payments | [payments.md](payments.md) | Not started | Sometimes |
| SMS | [sms.md](sms.md) | Not started | Rarely |
| Analytics | [analytics.md](analytics.md) | Not started | Nice-to-have |

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

1. **database.md** - Set up database first (everything depends on it)
2. **auth.md** - Set up auth (most features need user context)
3. **email.md** - Set up email (auth needs it for magic links)
4. **storage.md** - When you need file uploads
5. **payments.md** - When you need to charge users
6. **analytics.md** - Before launch

---

## Adding New Services

When you need a service not listed here:

1. Create `service-name.md` in this folder
2. Follow the template structure above
3. Add to the status table in this README
4. Update `handoff.md` with account ownership

---

## Account Ownership

All service accounts should be documented in [/docs/handoff.md](../handoff.md) with:
- Account owner
- Email used
- Whether client owns or needs transfer

---

_Services are the building blocks. Each file is a mini-guide._
