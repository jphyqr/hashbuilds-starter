# HANDOFF.md - Account Ownership & Transfer Checklist

**This file tracks all external accounts and services for project handoff.**

---

## Account Ownership Summary

| Service | Account Owner | Email Used | Client Owns? | Transfer Status |
|---------|---------------|------------|--------------|-----------------|
| Domain | _[Name]_ | _[email]_ | [ ] | Not started |
| Hosting (Vercel) | _[Name]_ | _[email]_ | [ ] | Not started |
| Database | _[Name]_ | _[email]_ | [ ] | Not started |
| Email (Resend) | _[Name]_ | _[email]_ | [ ] | Not started |
| Payments (Stripe) | _[Name]_ | _[email]_ | [ ] | Not started |
| Storage | _[Name]_ | _[email]_ | [ ] | Not started |
| Analytics | _[Name]_ | _[email]_ | [ ] | Not started |

---

## Detailed Account Information

### Domain Registrar

| Field | Value |
|-------|-------|
| Provider | _[e.g., Vercel, Namecheap, GoDaddy]_ |
| Domain | _[e.g., example.com]_ |
| Registered by | _[Name]_ |
| Account email | _[email]_ |
| Expiration | _[Date]_ |
| Auto-renew | _[Yes/No]_ |

**Transfer notes:** _[Any special instructions]_

---

### Hosting (Vercel)

| Field | Value |
|-------|-------|
| Account | _[Name]_ |
| Account email | _[email]_ |
| Project name | _[Name in Vercel]_ |
| Team/Personal | _[Team name or Personal]_ |
| Plan | _[Hobby/Pro/Enterprise]_ |

**Transfer notes:** Add client to team, transfer project ownership.

---

### Database

| Field | Value |
|-------|-------|
| Provider | _[Neon/Supabase/etc.]_ |
| Account | _[Name]_ |
| Account email | _[email]_ |
| Project/Database name | _[Name]_ |
| Region | _[e.g., us-west-2]_ |
| Plan | _[Free/Pro]_ |

**Transfer notes:** _[Transfer project or create new account]_

---

### Email Service

| Field | Value |
|-------|-------|
| Provider | _[Resend/SendGrid/etc.]_ |
| Account | _[Name]_ |
| Account email | _[email]_ |
| Domain verified | _[domain.com]_ |
| Plan | _[Free/Paid]_ |

**Transfer notes:** Client needs own account. Transfer domain or re-verify.

---

### Payment Processing

| Field | Value |
|-------|-------|
| Provider | _[Stripe]_ |
| Account | _[Name]_ |
| Account email | _[email]_ |
| Business name | _[Name on Stripe]_ |
| Payout account | _[Whose bank?]_ |

**Transfer notes:** Client MUST own this. Create under their email.

---

### Storage

| Field | Value |
|-------|-------|
| Provider | _[Vercel Blob/S3/etc.]_ |
| Account | _[Tied to Vercel or separate]_ |
| Bucket/Store name | _[Name]_ |

**Transfer notes:** Usually transfers with Vercel.

---

### Analytics

| Field | Value |
|-------|-------|
| Provider | _[Vercel/PostHog/GA4]_ |
| Account | _[Name]_ |
| Account email | _[email]_ |
| Property/Project ID | _[ID]_ |

**Transfer notes:** Add client as admin, transfer ownership.

---

## Environment Variables to Transfer

The client will need these values in their own hosting:

```env
# Database
DATABASE_URL="xxx"
DATABASE_URL_UNPOOLED="xxx"

# Auth
NEXTAUTH_URL="xxx"
NEXTAUTH_SECRET="xxx"

# Email
RESEND_API_KEY="xxx"
EMAIL_FROM="xxx"

# [Add others as needed]
```

**Note:** Regenerate secrets for production. Don't reuse dev keys.

---

## Pre-Transfer Checklist

### Before Handoff

- [ ] All features complete and tested
- [ ] Documentation complete (TRAINING.md)
- [ ] Client has received admin training
- [ ] All accounts listed above are documented
- [ ] Production environment is stable

### During Transfer

- [ ] Create accounts under client's email where needed
- [ ] Transfer domain (if applicable)
- [ ] Add client to Vercel team
- [ ] Transfer Vercel project ownership
- [ ] Share/transfer database access
- [ ] Regenerate production secrets
- [ ] Update DNS if domain transfers

### After Transfer

- [ ] Verify client can access all services
- [ ] Verify deployments work under client's account
- [ ] Verify emails send from client's domain
- [ ] Remove developer access (if requested)
- [ ] Archive source code for developer

---

## Support Handoff

| Item | Status |
|------|--------|
| Client has TRAINING.md | [ ] |
| Client knows how to deploy | [ ] |
| Client knows how to view logs | [ ] |
| Emergency contact established | [ ] |
| Support period defined | [ ] |

---

## Notes

_Any additional handoff notes:_

```
[Free-form notes about the transfer]
```

---

_Last updated: [DATE]_
