# kpis.md - Metrics Deep-Dive

**Parent:** [02-business-context.md](../02-business-context.md)
**Purpose:** Detailed metric definitions and tracking when brief summaries aren't enough

---

## North Star Metric

> **_[The ONE metric that best captures value delivered to customers]_**

| Attribute | Value |
|-----------|-------|
| **Metric** | _[e.g., Weekly Active Listings Viewed]_ |
| **Definition** | _[Exactly how it's calculated]_ |
| **Current** | _[Current value]_ |
| **Target (90 days)** | _[Target value]_ |
| **Why this metric** | _[Why it represents customer value]_ |

### North Star Breakdown
```
North Star = [Input 1] × [Input 2] × [Input 3]

Example:
Weekly Active Users = New Users + Returning Users - Churned Users
```

---

## Metric Categories

### Acquisition Metrics

| Metric | Definition | Current | Target | Owner |
|--------|------------|---------|--------|-------|
| **Website visitors** | Unique visitors /month | _[#]_ | _[#]_ | _[Who]_ |
| **Signups** | New accounts created | _[#]_ | _[#]_ | _[Who]_ |
| **Signup conversion** | Visitors → Signups | _[%]_ | _[%]_ | _[Who]_ |
| **CAC** | Cost per acquired customer | $___ | $___ | _[Who]_ |
| **Traffic sources** | % from each channel | _[breakdown]_ | _[target]_ | _[Who]_ |

### Activation Metrics

| Metric | Definition | Current | Target | Owner |
|--------|------------|---------|--------|-------|
| **Activation rate** | Signups → _[key action]_ | _[%]_ | _[%]_ | _[Who]_ |
| **Time to value** | Time to first _[value moment]_ | _[time]_ | _[time]_ | _[Who]_ |
| **Onboarding completion** | % completing onboarding | _[%]_ | _[%]_ | _[Who]_ |

**Activation definition:**
> A user is "activated" when they _[specific action that indicates they've experienced core value]_.

### Engagement Metrics

| Metric | Definition | Current | Target | Owner |
|--------|------------|---------|--------|-------|
| **DAU/MAU** | Daily/Monthly active ratio | _[%]_ | _[%]_ | _[Who]_ |
| **Session frequency** | Sessions per user /week | _[#]_ | _[#]_ | _[Who]_ |
| **Session duration** | Avg time per session | _[min]_ | _[min]_ | _[Who]_ |
| **Feature adoption** | % using _[feature]_ | _[%]_ | _[%]_ | _[Who]_ |

### Retention Metrics

| Metric | Definition | Current | Target | Owner |
|--------|------------|---------|--------|-------|
| **D1 retention** | % returning day 1 | _[%]_ | _[%]_ | _[Who]_ |
| **D7 retention** | % returning day 7 | _[%]_ | _[%]_ | _[Who]_ |
| **D30 retention** | % returning day 30 | _[%]_ | _[%]_ | _[Who]_ |
| **Churn rate** | % lost per month | _[%]_ | _[%]_ | _[Who]_ |
| **NPS** | Net Promoter Score | _[#]_ | _[#]_ | _[Who]_ |

### Revenue Metrics

| Metric | Definition | Current | Target | Owner |
|--------|------------|---------|--------|-------|
| **MRR** | Monthly Recurring Revenue | $___ | $___ | _[Who]_ |
| **ARR** | Annual Recurring Revenue | $___ | $___ | _[Who]_ |
| **ARPU** | Avg Revenue Per User | $___ | $___ | _[Who]_ |
| **LTV** | Lifetime Value | $___ | $___ | _[Who]_ |
| **Expansion revenue** | % from upsells | _[%]_ | _[%]_ | _[Who]_ |

---

## Metric Definitions

### _[Metric Name]_

| Attribute | Value |
|-----------|-------|
| **Formula** | `[exact calculation]` |
| **Data source** | _[Where data comes from]_ |
| **Refresh frequency** | _[Real-time / Daily / Weekly]_ |
| **Segments** | _[How we break this down]_ |
| **Known issues** | _[Any caveats or data quality issues]_ |

_[Repeat for each metric that needs detailed definition]_

---

## Dashboards & Reporting

### Primary Dashboard
- **Tool:** _[e.g., Mixpanel, PostHog, internal]_
- **URL:** _[Link to dashboard]_
- **Refresh:** _[Real-time / Daily]_

### Weekly Metrics Review
- **When:** _[Day/time]_
- **Attendees:** _[Who]_
- **Format:** _[Sync/async, doc location]_

### Monthly Business Review
- **Metrics covered:** _[Which metrics]_
- **Report location:** _[Link]_

---

## Experiments Framework

### Current Experiments

| Experiment | Hypothesis | Metric | Status | Results |
|------------|------------|--------|--------|---------|
| _[Name]_ | _[If X then Y]_ | _[Primary metric]_ | _[Running/Complete]_ | _[Results or ETA]_ |

### Experiment Log

| Date | Experiment | Result | Learning |
|------|------------|--------|----------|
| _[Date]_ | _[What we tested]_ | _[+X% / -X% / Neutral]_ | _[What we learned]_ |

---

## Alerts & Thresholds

| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| _[Metric]_ | _[threshold]_ | _[threshold]_ | _[Who to notify, what to do]_ |

---

## Changelog

| Date | Change |
|------|--------|
| _[YYYY-MM-DD]_ | Initial KPIs documented |

---

_Last updated: [DATE]_
