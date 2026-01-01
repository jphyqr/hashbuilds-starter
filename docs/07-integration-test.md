# 07-integration-test.md - Testing & Verification

<!--
PROMPT: Testing strategy depends on your project. Ask me:

1. What's the project complexity?
   - Simple landing page → Manual testing checklist
   - CRUD app → Unit + integration tests
   - Complex app → Full test suite

2. What's your testing experience?
   - New to testing → Start with E2E (Playwright)
   - Some experience → Add component tests
   - Experienced → Full TDD workflow

3. What matters most to test?
   - User flows (signup, checkout) → E2E tests
   - Component behavior → Component tests
   - Business logic → Unit tests
   - API responses → API tests

4. What's your CI/CD setup?
   - None → Local testing scripts
   - GitHub Actions → Automated test runs
   - Vercel → Preview deployment tests

After you answer, I'll set up appropriate testing with:
- Test framework configuration
- Example tests for your use cases
- CI/CD integration
- Testing scripts
-->

---

## Overview

This guide covers testing strategies for Next.js 14 applications, from simple verification to comprehensive test suites.

---

## Quick Start: Playwright E2E

The fastest path to valuable tests is end-to-end testing with Playwright.

### Installation

```bash
pnpm add -D @playwright/test
npx playwright install
```

### Configuration: `playwright.config.ts`

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
```

### First Test: `tests/home.spec.ts`

```typescript
import { test, expect } from '@playwright/test'

test('homepage loads', async ({ page }) => {
  await page.goto('/')
  await expect(page).toHaveTitle(/Your App Name/)
})

test('navigation works', async ({ page }) => {
  await page.goto('/')
  await page.click('text=About')
  await expect(page).toHaveURL('/about')
})
```

### Run Tests

```bash
# Run all tests
npx playwright test

# Run with UI
npx playwright test --ui

# Run specific file
npx playwright test tests/home.spec.ts
```

---

## Test Patterns by Feature Type

### Authentication Flow

```typescript
// tests/auth.spec.ts
import { test, expect } from '@playwright/test'

test.describe('Authentication', () => {
  test('shows sign in page', async ({ page }) => {
    await page.goto('/auth/signin')
    await expect(page.getByRole('heading', { name: 'Sign In' })).toBeVisible()
  })

  test('redirects protected routes to signin', async ({ page }) => {
    await page.goto('/dashboard')
    await expect(page).toHaveURL(/\/auth\/signin/)
  })

  test('sign in with email', async ({ page }) => {
    await page.goto('/auth/signin')
    await page.fill('input[name="email"]', 'test@example.com')
    await page.click('button[type="submit"]')
    await expect(page.getByText('Check your email')).toBeVisible()
  })
})
```

### Form Submission

```typescript
// tests/contact.spec.ts
import { test, expect } from '@playwright/test'

test.describe('Contact Form', () => {
  test('submits successfully', async ({ page }) => {
    await page.goto('/contact')

    await page.fill('input[name="name"]', 'John Doe')
    await page.fill('input[name="email"]', 'john@example.com')
    await page.fill('textarea[name="message"]', 'Hello!')

    await page.click('button[type="submit"]')

    await expect(page.getByText('Message sent')).toBeVisible()
  })

  test('shows validation errors', async ({ page }) => {
    await page.goto('/contact')
    await page.click('button[type="submit"]')
    await expect(page.getByText('Email is required')).toBeVisible()
  })
})
```

### API Routes

```typescript
// tests/api.spec.ts
import { test, expect } from '@playwright/test'

test.describe('API Routes', () => {
  test('GET /api/health returns 200', async ({ request }) => {
    const response = await request.get('/api/health')
    expect(response.ok()).toBeTruthy()
    expect(await response.json()).toEqual({ status: 'ok' })
  })

  test('POST /api/contact creates submission', async ({ request }) => {
    const response = await request.post('/api/contact', {
      data: {
        name: 'Test',
        email: 'test@example.com',
        message: 'Hello',
      },
    })
    expect(response.status()).toBe(201)
  })

  test('protected route returns 401 without auth', async ({ request }) => {
    const response = await request.get('/api/admin/users')
    expect(response.status()).toBe(401)
  })
})
```

### Database Operations

```typescript
// tests/crud.spec.ts
import { test, expect } from '@playwright/test'

test.describe('CRUD Operations', () => {
  test('creates new item', async ({ page }) => {
    await page.goto('/items/new')
    await page.fill('input[name="title"]', 'Test Item')
    await page.click('button[type="submit"]')

    await expect(page).toHaveURL(/\/items\/\w+/)
    await expect(page.getByText('Test Item')).toBeVisible()
  })

  test('updates item', async ({ page }) => {
    await page.goto('/items/test-id/edit')
    await page.fill('input[name="title"]', 'Updated Item')
    await page.click('button[type="submit"]')

    await expect(page.getByText('Updated Item')).toBeVisible()
  })

  test('deletes item', async ({ page }) => {
    await page.goto('/items/test-id')
    await page.click('button[aria-label="Delete"]')
    await page.click('button:has-text("Confirm")')

    await expect(page).toHaveURL('/items')
  })
})
```

---

## Component Testing with Vitest

### Installation

```bash
pnpm add -D vitest @vitejs/plugin-react @testing-library/react @testing-library/jest-dom jsdom
```

### Configuration: `vitest.config.ts`

```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    include: ['**/*.test.{ts,tsx}'],
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './'),
    },
  },
})
```

### Setup: `tests/setup.ts`

```typescript
import '@testing-library/jest-dom'
```

### Component Test: `components/Button.test.tsx`

```typescript
import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from './Button'

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button')).toHaveTextContent('Click me')
  })

  it('calls onClick when clicked', () => {
    const onClick = vi.fn()
    render(<Button onClick={onClick}>Click</Button>)
    fireEvent.click(screen.getByRole('button'))
    expect(onClick).toHaveBeenCalledTimes(1)
  })

  it('disables when disabled prop is true', () => {
    render(<Button disabled>Click</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

---

## Manual Testing Checklist

For simpler projects, a structured manual checklist is effective:

### `tests/MANUAL_CHECKLIST.md`

```markdown
# Manual Testing Checklist

Run through this before each deployment.

## Core Functionality

- [ ] Homepage loads < 3s
- [ ] All navigation links work
- [ ] Mobile menu opens/closes
- [ ] Footer links work

## Forms

- [ ] Contact form submits
- [ ] Validation errors display
- [ ] Success message shows
- [ ] Email is received

## Authentication (if applicable)

- [ ] Sign in page loads
- [ ] OAuth buttons work
- [ ] Magic link email arrives
- [ ] Protected routes redirect
- [ ] Sign out works

## Responsive Design

- [ ] Mobile (375px) - Layout correct
- [ ] Tablet (768px) - Layout correct
- [ ] Desktop (1280px) - Layout correct

## Performance

- [ ] Lighthouse score > 90
- [ ] No console errors
- [ ] Images load properly
- [ ] Fonts load properly

## SEO

- [ ] Title tags correct
- [ ] Meta descriptions present
- [ ] OG images load
- [ ] Sitemap accessible

## Cross-Browser

- [ ] Chrome - Works
- [ ] Safari - Works
- [ ] Firefox - Works
```

---

## CI/CD Integration

### GitHub Actions: `.github/workflows/test.yml`

```yaml
name: Test

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install dependencies
        run: pnpm install

      - name: Run unit tests
        run: pnpm test

      - name: Install Playwright
        run: npx playwright install --with-deps

      - name: Run E2E tests
        run: npx playwright test

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
```

---

## Package.json Scripts

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:all": "pnpm test && pnpm test:e2e"
  }
}
```

---

## Testing Database

### Test Database Setup

```env
# .env.test
DATABASE_URL="postgresql://user:pass@localhost:5432/myapp_test"
```

### Reset Between Tests

```typescript
// tests/helpers/db.ts
import { db } from '@/lib/db'

export async function resetDatabase() {
  await db.$executeRaw`TRUNCATE TABLE "User" CASCADE`
  await db.$executeRaw`TRUNCATE TABLE "Post" CASCADE`
}

export async function seedTestData() {
  await db.user.create({
    data: {
      email: 'test@example.com',
      name: 'Test User',
    },
  })
}
```

### Use in Tests

```typescript
import { test } from '@playwright/test'
import { resetDatabase, seedTestData } from './helpers/db'

test.beforeEach(async () => {
  await resetDatabase()
  await seedTestData()
})
```

---

## Test Fixtures

### Auth Fixture

```typescript
// tests/fixtures.ts
import { test as base } from '@playwright/test'

type Fixtures = {
  authenticatedPage: Page
}

export const test = base.extend<Fixtures>({
  authenticatedPage: async ({ page }, use) => {
    // Set up authentication
    await page.goto('/auth/signin')
    await page.fill('input[name="email"]', 'test@example.com')
    await page.click('button[type="submit"]')
    // Wait for auth to complete
    await page.waitForURL('/dashboard')

    await use(page)
  },
})

export { expect } from '@playwright/test'
```

### Use Fixture

```typescript
import { test, expect } from './fixtures'

test('authenticated user sees dashboard', async ({ authenticatedPage }) => {
  await authenticatedPage.goto('/dashboard')
  await expect(authenticatedPage.getByText('Welcome')).toBeVisible()
})
```

---

## Visual Regression Testing

```typescript
// tests/visual.spec.ts
import { test, expect } from '@playwright/test'

test('homepage visual', async ({ page }) => {
  await page.goto('/')
  await expect(page).toHaveScreenshot('homepage.png')
})

test('mobile navigation', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 })
  await page.goto('/')
  await page.click('[aria-label="Menu"]')
  await expect(page.locator('nav')).toHaveScreenshot('mobile-nav.png')
})
```

Update screenshots:
```bash
npx playwright test --update-snapshots
```

---

## Testing Strategy by Project Phase

### MVP Phase
- Manual testing checklist
- Basic E2E for critical paths (auth, main CTA)
- API health check test

### Growth Phase
- Full E2E test suite
- Component tests for shared components
- Visual regression for key pages

### Scale Phase
- Unit tests for business logic
- Integration tests for complex flows
- Performance tests
- Accessibility tests

---

## Accessibility Testing

```typescript
import { test, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

test('homepage has no accessibility violations', async ({ page }) => {
  await page.goto('/')

  const accessibilityScanResults = await new AxeBuilder({ page }).analyze()

  expect(accessibilityScanResults.violations).toEqual([])
})
```

Install: `pnpm add -D @axe-core/playwright`

---

## Test Checklist Before Deploy

- [ ] All E2E tests pass locally
- [ ] No console errors in browser
- [ ] Lighthouse accessibility > 90
- [ ] Mobile responsive verified
- [ ] API endpoints return expected responses
- [ ] Auth flow works end-to-end
- [ ] Forms submit successfully
- [ ] Error states handled gracefully

---

_Start with E2E tests for critical user paths. Add more tests as the application grows._
