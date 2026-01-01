# 03-design-system.md

<!--
PROMPT: Read this file, then ask me the following questions to fill it out:

1. Do you have existing brand colors? If yes, what are they (hex codes)?
2. If no existing colors, what vibe do you want? (professional, playful, bold, minimal, etc.)
3. What fonts do you want? (or should I suggest based on the vibe?)
4. Light mode, dark mode, or both?
5. Any design inspiration? (websites, apps, or styles you like)
6. What's the primary action users take? (this affects button styling)

After you answer, I'll fill in the sections below and create your Tailwind config.
Skip any sections you're not ready to decide on.
-->

---

## Brand Colors

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Primary** | _[color name]_ | `#______` | Buttons, links, key actions |
| **Secondary** | _[color name]_ | `#______` | Secondary buttons, accents |
| **Background** | _[color name]_ | `#______` | Page background |
| **Foreground** | _[color name]_ | `#______` | Primary text |
| **Muted** | _[color name]_ | `#______` | Secondary text, borders |
| **Accent** | _[color name]_ | `#______` | Highlights, badges |
| **Destructive** | _[color name]_ | `#______` | Error states, delete actions |

---

## Typography

| Role | Font | Weight | Size |
|------|------|--------|------|
| **Headings** | _[font name]_ | _[weight]_ | - |
| **Body** | _[font name]_ | _[weight]_ | - |
| **Mono** | _[font name]_ | _[weight]_ | Code blocks |

**Font loading:** _[Google Fonts / Local / System]_

---

## Design Aesthetic

**Vibe:** _[1-3 words describing the feel]_

**Inspiration:**
- _[Link to site/app you like]_
- _[Another reference]_

**Key characteristics:**
- _[e.g., "Rounded corners, soft shadows"]_
- _[e.g., "Minimal, lots of whitespace"]_
- _[e.g., "Bold typography, high contrast"]_

---

## Component Patterns

### Buttons
- **Primary:** _[description]_
- **Secondary:** _[description]_
- **Ghost:** _[description]_

### Cards
- **Border radius:** _[e.g., "rounded-lg"]_
- **Shadow:** _[e.g., "shadow-sm"]_
- **Border:** _[e.g., "border border-gray-200"]_

### Forms
- **Input style:** _[description]_
- **Label position:** _[above / inline / floating]_
- **Error states:** _[description]_

---

## Spacing System

Using Tailwind defaults:
- `p-4` (16px) for card padding
- `gap-6` (24px) for section spacing
- `space-y-4` (16px) for form field spacing

---

## Dark Mode

**Status:** _[Enabled / Disabled / Not decided]_

**Strategy:** _[System preference / Toggle / Dark only]_

---

## Tailwind Config

_After filling out this file, update `tailwind.config.ts` with these values._

```typescript
// tailwind.config.ts - generated from design-system.md
// TODO: Update with actual values after filling out this file
```

---

## Component Library

**Using:** shadcn/ui (pre-installed)

**Installed components:**
- [ ] Button
- [ ] Card
- [ ] Input
- [ ] Form
- [ ] Dialog
- [ ] Toast (Sonner)

_Add components as needed: `pnpm dlx shadcn@latest add [component]`_

---

_Last updated: [DATE]_
