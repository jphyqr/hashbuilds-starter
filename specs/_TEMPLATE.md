# [Feature Name]

**Status:** Planning
**Priority:** [MVP | Phase 2 | Nice-to-have]
**Created:** [YYYY-MM-DD]
**Last Updated:** [YYYY-MM-DD]

---

## Problem Statement

[Describe the problem this feature solves. Be specific about user pain points.]

---

## User Stories

- As a [user type], I want [action], so that [benefit]
- As a [user type], I want [action], so that [benefit]

---

## Acceptance Criteria

- [ ] [Specific, testable criterion]
- [ ] [Specific, testable criterion]
- [ ] [Specific, testable criterion]

---

## Technical Design

### Database Models

```prisma
model Example {
  id        String   @id @default(cuid())
  // fields
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

### API Routes

| Method | Route | Purpose | Auth Required |
|--------|-------|---------|---------------|
| GET | /api/example | Fetch examples | No |
| POST | /api/example | Create example | Yes |

### Components

- `ExampleList` - Displays list of examples
- `ExampleForm` - Form for creating/editing
- `ExampleCard` - Individual example display

### State Management

[Describe client state requirements if any]

---

## User Flow

1. User [action]
2. System [response]
3. User sees [result]
4. [Continue flow...]

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Empty state | Show placeholder with CTA |
| Error state | Display error message, retry option |
| Loading state | Show skeleton/spinner |
| [Other case] | [Behavior] |

---

## Security Considerations

- [ ] Input validation
- [ ] Authorization checks
- [ ] Rate limiting (if applicable)
- [ ] Data sanitization

---

## Implementation Steps

### Phase 1: Database & API
1. [ ] Add Prisma models
2. [ ] Run migration
3. [ ] Create API routes
4. [ ] Test API with curl/Postman

### Phase 2: UI Components
5. [ ] Create base components
6. [ ] Add form handling
7. [ ] Implement loading/error states
8. [ ] Connect to API

### Phase 3: Polish
9. [ ] Add validation messages
10. [ ] Responsive design check
11. [ ] Accessibility review
12. [ ] Update tests

---

## Testing Checklist

### Unit Tests
- [ ] [Component] renders correctly
- [ ] [Function] handles edge cases

### Integration Tests
- [ ] API returns expected responses
- [ ] Form submission works end-to-end

### E2E Tests
- [ ] Complete user flow works
- [ ] Error states handled gracefully

---

## Dependencies

- [Package/library if any]
- [External service if any]

---

## Out of Scope

[Explicitly list what this feature does NOT include to prevent scope creep]

- Not including [feature X]
- Not handling [edge case Y]

---

## Open Questions

- [ ] [Question that needs answering before implementation]
- [ ] [Decision that needs to be made]

---

## References

- [Link to relevant docs]
- [Link to similar implementations]
- [Design mockups if any]

---

_Spec created: [DATE]_
_Last reviewed: [DATE]_
