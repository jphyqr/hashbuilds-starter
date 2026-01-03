# /docs/cfo - Financial Operations (Role: CFO)

> **Status:** 🚧 IN DEVELOPMENT
>
> This layer is being built in [hashbuilds core](https://github.com/jphyqr/hashbuilds) first.
> Progress tracked in: `FEATURE_CRA.md`

---

## Purpose

The CFO layer handles:
- Tax compliance (CRA for Canada, IRS for US)
- Expense tracking and categorization
- Invoice management
- Revenue reporting
- HST/GST collection and remittance
- Year-end preparation

---

## Why This Exists

Most solo developers and small agencies:
1. Don't track expenses properly until tax time
2. Mix personal and business transactions
3. Don't know what's deductible
4. Scramble at year-end

This layer provides:
- **Structured tracking** from day one
- **CRA-compliant categories** built in
- **Notion sync** for easy data entry
- **Admin dashboard** for visibility
- **Export-ready** data for accountants

---

## Planned Structure

```
/docs/cfo/
├── README.md              ← You are here
├── 01-business-setup.md   ← Legal entity, fiscal year, tax numbers
├── 02-expense-tracking.md ← Categories, receipt management
├── 03-revenue-tracking.md ← Invoices, payment tracking
├── 04-hst-gst.md          ← Tax collection and remittance
├── 05-year-end.md         ← Preparation checklist
└── templates/
    ├── expense-report.md
    └── invoice-template.md
```

---

## Current Development

**Being built in:** hashbuilds (production site)

**Why there first:**
- Real data (actual expenses, invoices)
- Real deadlines (tax season)
- Real integrations (Notion, Stripe)

**Will extract to starter when:**
- [ ] Core structure proven
- [ ] Categories validated against CRA guidelines
- [ ] Notion sync working reliably
- [ ] Admin dashboard functional
- [ ] Export format approved by accountant

---

## For Now

If you need financial tracking before this is ready:

1. **Use a spreadsheet** - Google Sheets with expense categories
2. **Keep receipts** - Folder per month, photo each receipt
3. **Separate accounts** - Business bank account + credit card
4. **Track HST** - 13% (ON) or your province's rate on all invoices

---

## Links

- **HashBuilds FEATURE_CRA.md** - Active development
- **CRA Business Expenses Guide** - https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/sole-proprietorships-partnerships/business-expenses.html

---

_This will become a full layer like /docs/product/ once proven in production._
