# Component Inventory

Track reusable components as they're built.

For design aesthetics, see [docs/03-design-system.md](../03-design-system.md).

---

## Component Library

**Base:** shadcn/ui (Radix primitives + Tailwind)

**Install components:**
```bash
pnpm dlx shadcn@latest add [component]
```

---

## shadcn/ui Components Installed

Track which shadcn components are installed:

| Component | Installed | Notes |
|-----------|-----------|-------|
| Button | [ ] | |
| Card | [ ] | |
| Dialog | [ ] | |
| Dropdown Menu | [ ] | |
| Form | [ ] | With react-hook-form |
| Input | [ ] | |
| Label | [ ] | |
| Select | [ ] | |
| Separator | [ ] | |
| Sheet | [ ] | Mobile drawer |
| Skeleton | [ ] | Loading states |
| Table | [ ] | |
| Tabs | [ ] | |
| Textarea | [ ] | |
| Toast (Sonner) | [ ] | |
| Tooltip | [ ] | |

---

## Custom Components

Track project-specific reusable components:

<!--
PROMPT: As you build components, add them here with their props and usage.

| Component | Location | Purpose | Key Props |
|-----------|----------|---------|-----------|
| ListingCard | components/listings/ListingCard.tsx | Display listing preview | listing, onEdit? |
-->

| Component | Location | Purpose | Key Props |
|-----------|----------|---------|-----------|
| _[Add as you build]_ | | | |

---

## Component Patterns

### File Structure

```
components/
├── ui/                      # shadcn/ui (don't modify directly)
├── layout/                  # Layout components
│   ├── Header.tsx
│   ├── Footer.tsx
│   └── Sidebar.tsx
├── [feature]/               # Feature-specific
│   ├── ListingCard.tsx
│   └── ListingForm.tsx
└── shared/                  # Cross-feature components
    ├── LoadingSpinner.tsx
    └── EmptyState.tsx
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Component files | PascalCase | `UserCard.tsx` |
| Component folders | kebab-case | `components/user-profile/` |
| Index exports | index.ts | Re-export from folder |

### Component Template

```tsx
// components/[feature]/[Component].tsx

import { cn } from '@/lib/utils'

type ComponentProps = {
  // Required props first
  title: string
  // Optional props after
  className?: string
  onAction?: () => void
}

export function Component({
  title,
  className,
  onAction,
}: ComponentProps) {
  return (
    <div className={cn("base-styles", className)}>
      {/* ... */}
    </div>
  )
}
```

---

## Layout Components

| Component | Purpose | Used In |
|-----------|---------|---------|
| `Header` | Site header with nav | Root layout |
| `Footer` | Site footer | Root layout |
| `Sidebar` | Admin nav | Admin layout |
| `PageHeader` | Page title + actions | Most pages |

---

## Shared Components

Common components used across features:

| Component | Purpose | Props |
|-----------|---------|-------|
| `LoadingSpinner` | Loading indicator | `size?: 'sm' \| 'md' \| 'lg'` |
| `EmptyState` | No data placeholder | `title, description, action?` |
| `ConfirmDialog` | Confirmation modal | `title, message, onConfirm` |
| `DataTable` | Sortable/filterable table | `columns, data, pagination?` |

---

## Component Guidelines

### When to Create a Component

Create a new component when:
- UI is reused 2+ times
- Logic is complex enough to isolate
- It makes the parent component cleaner

Don't create a component when:
- It's only used once (extract later if needed)
- It's just styling (use Tailwind classes)

### Props Guidelines

```tsx
// Good: Explicit props
type Props = {
  user: User
  onEdit: (user: User) => void
}

// Avoid: Spreading all props
type Props = User & { onEdit: () => void }  // Hard to know what's expected

// Good: Optional with defaults
type Props = {
  size?: 'sm' | 'md' | 'lg'  // Provide default in component
}
```

### Composition over Props

```tsx
// Avoid: Prop explosion
<Card
  title="..."
  description="..."
  image="..."
  actions={[...]}
  footer="..."
/>

// Better: Composition
<Card>
  <CardHeader>
    <CardTitle>...</CardTitle>
    <CardDescription>...</CardDescription>
  </CardHeader>
  <CardContent>...</CardContent>
  <CardFooter>...</CardFooter>
</Card>
```

---

_Update this file as you build components._
