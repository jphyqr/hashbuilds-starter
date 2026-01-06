# 03-design-system.md

<!--
PROMPT: This file guides creation of a **Design System Playground** - a multi-theme showcase
that lets stakeholders compare drastically different aesthetic directions side-by-side.

## Initial Setup Questions

Before building the playground, determine the project context:

1. **Is this a client project or personal project?**
   - CLIENT PROJECT → Enable feedback system (database + UI for collecting ratings)
   - PERSONAL PROJECT → Skip feedback system, just build the playground

2. **If client project, who needs to give feedback?**
   - Get names of reviewers (e.g., "sage", "quinnie")
   - These become options in the feedback UI

3. **How will they review?**
   - ASYNC (different times) → Database-backed feedback, shows other reviewers' ratings
   - SYNC (same room) → Simple UI, no persistence needed

## What You're Building

Instead of asking clients abstract questions about colors and fonts, you'll build an interactive
playground at `/design-system` with:

1. **Multiple theme options** (9-15 themes across 3 tiers)
2. **Live preview pages** (Home, Listing, Dashboard, Components)
3. **Smooth theme switching** with prev/next navigation
4. **Real content** using actual project images and copy
5. **Feedback collection** (if client project) with ratings and notes per reviewer

## Discovery Questions

Ask the client these questions to understand constraints:

1. **What's the business vibe?** (corporate, personal, edgy, premium, friendly, etc.)
2. **Who's the primary audience?** (affects trust signals - professionals vs consumers vs international)
3. **Any colors that are OFF LIMITS?** (competitor colors, personal dislikes)
4. **Light mode, dark mode, or both?** (affects theme range)
5. **What sites do you admire?** (for reference, not copying)
6. **How adventurous are you?** (determines how "bonkers" to go with options)

Don't ask for specific colors - you'll provide options for them to react to.

## Theme Tier Philosophy

### Tier 1: Proven & Safe (3 themes)
Themes that "just work" - professionally acceptable, broadly appealing.
Client will feel comfortable showing these to anyone.

### Tier 2: Bold & Contrarian (3-6 themes)
Distinctive choices that stand out. More personality, some risk.
These spark conversation: "Oh, that's interesting..."

### Tier 3: Absolute Bonkers (3-6 themes)
Extreme but defensible design directions. High memorability.
Even if not chosen, they make Tier 2 feel more reasonable.

## After Client Chooses

1. Update this file with chosen direction
2. Extract final CSS variables to globals.css
3. Remove /design-system page (or keep for future iteration)
-->

---

## Project Context

**Project Type:** _[ ] Client Project  [ ] Personal Project_

**Reviewers:** _[List names if client project, e.g., "sage, quinnie"]_

**Feedback Method:** _[ ] Async (database)  [ ] Sync (in-person)  [ ] N/A_

---

## Design System Playground

**Preview all options:** [/design-system](/design-system)

The playground shows:
- Component showcase (buttons, cards, forms, alerts, badges)
- Home page preview
- Listing/detail page preview
- Dashboard preview

**Theme navigation:**
- Prev/Next arrows to cycle through themes
- Collapsible full selector for direct access
- Theme counter showing position (e.g., "3 of 15")

---

## Client Feedback System (Optional)

If this is a client project with multiple stakeholders, add a feedback collection system.

### Why Feedback Matters

With 9-15 themes, it's hard for clients to:
- Remember which ones they liked
- Communicate preferences clearly
- See what other stakeholders think

A simple rating system solves this.

### Database Schema

Add to `prisma/schema.prisma`:

```prisma
// ============================================================================
// DESIGN FEEDBACK
// ============================================================================

/// Feedback on design system themes from team members
model DesignFeedback {
  id        String         @id @default(cuid())
  themeName String         // e.g., "pacific", "brutalist", "luxury"
  reviewer  String         // e.g., "sage", "quinnie"
  rating    DesignRating   // love, like, neutral, dislike, hate
  notes     String?        @db.Text
  createdAt DateTime       @default(now())
  updatedAt DateTime       @updatedAt

  @@unique([themeName, reviewer]) // One rating per theme per reviewer
  @@map("design_feedback")
}

enum DesignRating {
  LOVE     // Strong yes, would choose this
  LIKE     // Positive, could work
  NEUTRAL  // No strong opinion
  DISLIKE  // Prefer not, but not dealbreaker
  HATE     // Absolute no
}
```

Run: `npx prisma db push`

### API Route

Create `app/api/design-feedback/route.ts`:

```typescript
import { prisma } from '@/lib/db';
import { NextResponse } from 'next/server';

// GET - Fetch all feedback grouped by theme
export async function GET() {
  try {
    const feedback = await prisma.designFeedback.findMany({
      orderBy: [{ themeName: 'asc' }, { reviewer: 'asc' }],
    });

    // Group by theme for easier consumption
    const grouped = feedback.reduce((acc, item) => {
      if (!acc[item.themeName]) acc[item.themeName] = {};
      acc[item.themeName][item.reviewer] = {
        rating: item.rating,
        notes: item.notes,
        updatedAt: item.updatedAt,
      };
      return acc;
    }, {} as Record<string, Record<string, any>>);

    return NextResponse.json({ success: true, feedback: grouped });
  } catch (error) {
    return NextResponse.json({ success: false, error: 'Failed to fetch' }, { status: 500 });
  }
}

// POST - Save feedback (upsert)
export async function POST(request: Request) {
  try {
    const { themeName, reviewer, rating, notes } = await request.json();

    // Validate
    if (!themeName || !reviewer || !rating) {
      return NextResponse.json({ success: false, error: 'Missing fields' }, { status: 400 });
    }

    const validRatings = ['LOVE', 'LIKE', 'NEUTRAL', 'DISLIKE', 'HATE'];
    if (!validRatings.includes(rating)) {
      return NextResponse.json({ success: false, error: 'Invalid rating' }, { status: 400 });
    }

    // Upsert (create or update)
    const feedback = await prisma.designFeedback.upsert({
      where: { themeName_reviewer: { themeName, reviewer: reviewer.toLowerCase() } },
      update: { rating, notes: notes || null },
      create: { themeName, reviewer: reviewer.toLowerCase(), rating, notes: notes || null },
    });

    return NextResponse.json({ success: true, feedback });
  } catch (error) {
    return NextResponse.json({ success: false, error: 'Failed to save' }, { status: 500 });
  }
}
```

### Feedback UI Component

Add a sticky panel at the bottom of the design system page:

```typescript
// Rating options with emoji
const ratingEmojis = {
  LOVE: { emoji: '😍', label: 'Love', color: 'bg-green-100 border-green-500' },
  LIKE: { emoji: '👍', label: 'Like', color: 'bg-blue-100 border-blue-500' },
  NEUTRAL: { emoji: '😐', label: 'Meh', color: 'bg-gray-100 border-gray-400' },
  DISLIKE: { emoji: '👎', label: 'Dislike', color: 'bg-orange-100 border-orange-500' },
  HATE: { emoji: '🚫', label: 'No', color: 'bg-red-100 border-red-500' },
};
```

**UI Elements:**
1. **Reviewer toggle** - Buttons to switch between reviewers (e.g., "Sage" / "Quinnie")
2. **Rating buttons** - Row of emoji buttons, selected one highlighted
3. **Notes field** - Optional text input, auto-saves on blur
4. **Team ratings display** - Shows all reviewers' emoji ratings for current theme

**Behavior:**
- Loads all feedback on mount
- Saves immediately when rating clicked
- Updates local state optimistically
- Shows other reviewers' ratings (but not editable)

### Feedback Summary View

Optionally add a summary page or section showing:

```
Theme           | Sage  | Quinnie | Notes
----------------|-------|---------|-------
Pacific Coast   | 😍    | 👍      | "Love the teal" / "Maybe too casual"
Urban Minimal   | 👍    | 😍      | "" / "Very clean"
Neo-Brutalist   | 😐    | 🚫      | "Interesting" / "Too harsh"
...
```

This helps quickly identify:
- **Consensus picks** (both 😍 or 👍)
- **Divisive options** (one loves, one hates)
- **Clear rejects** (both 👎 or 🚫)

---

## Theme Architecture

### Required for Each Theme

```typescript
interface Theme {
  name: string;           // Display name (e.g., "Pacific Coast")
  tagline: string;        // One-liner (e.g., "Where the mountains meet the sea")
  description: string;    // 2-3 sentences explaining the vibe and who it's for
  vibe: string[];         // 3-4 adjectives (e.g., ['Calming', 'Natural', 'Trustworthy'])
  colors: {
    primary: string;           // Main brand color - buttons, links
    primaryForeground: string; // Text on primary color
    secondary: string;         // Supporting color
    secondaryForeground: string;
    accent: string;            // Highlights, badges, special elements
    accentForeground: string;
    background: string;        // Page background
    foreground: string;        // Primary text
    muted: string;             // Subtle backgrounds
    mutedForeground: string;   // Secondary text
    card: string;              // Card backgrounds
    cardForeground: string;
    border: string;            // Borders, dividers
    destructive: string;       // Errors, delete actions
    success: string;           // Success states
  };
  fonts: {
    heading: string;      // Font stack for headings
    body: string;         // Font stack for body text
  };
  radius: string;         // Border radius (e.g., '12px', '0px')
  shadows: boolean;       // Whether to use shadows
  gradients: boolean;     // Whether to use gradients
}
```

### CSS Variables Pattern

```css
/* Applied dynamically based on selected theme */
--ds-primary: [theme.colors.primary];
--ds-primary-foreground: [theme.colors.primaryForeground];
--ds-secondary: [theme.colors.secondary];
/* ... etc for all colors */
--ds-radius: [theme.radius];
--ds-font-heading: [theme.fonts.heading];
--ds-font-body: [theme.fonts.body];
```

---

## Suggested Theme Templates

### Tier 1: Proven & Safe

#### 1. Nature/Location-Based
**Use when:** Business has strong geographic identity
- Colors from local landscape (ocean, forest, mountains, desert)
- Serif headings for warmth, sans-serif body for readability
- Soft corners (12px radius), subtle shadows
- Example: Pacific Coast (teal + forest green + sand)

#### 2. Urban Minimal
**Use when:** Premium/professional positioning, international audience
- High contrast black/white with metallic accent (gold, silver)
- Modern sans-serif throughout
- Sharp corners (4px radius), no shadows
- Example: Black + white + warm gold

#### 3. Nordic Warmth
**Use when:** Personal brand, friendly service, "human" positioning
- Warm neutrals with terracotta/rust accent
- Characterful serif headings, rounded sans body
- Very soft corners (16px radius), subtle shadows
- Example: Terracotta + cream + warm brown

### Tier 2: Bold & Contrarian

#### 4. Neo-Brutalist
**Use when:** Anti-corporate positioning, memorable brand
- Black + electric accent (lime, cyan, magenta)
- Monospace headings, geometric sans body
- Zero radius, thick black borders
- Example: Black + white + electric lime

#### 5. Analog Nostalgia
**Use when:** Trust through authenticity, "real people" positioning
- Sepia/paper tones with ink-like accents
- Typewriter/serif fonts
- Minimal radius, paper-like textures
- Example: Cream paper + brown ink + stamp pad slate

#### 6. Swiss Grid
**Use when:** Information-dense, intellectual audience
- Red accent on black/white base
- Helvetica or similar throughout
- Zero radius, strict grid
- Example: Swiss red + black + white

#### 7. Dark Mode Luxury
**Use when:** Premium tech-forward audience, nighttime use case
- Dark background with metallic accents (gold, rose gold)
- Elegant serif headings, clean sans body
- Medium radius, subtle glow effects
- Example: True black + metallic gold + champagne

#### 8. Editorial
**Use when:** Content-heavy, storytelling, lifestyle brand
- Muted sophisticated palette
- Bold display serif headings, readable serif body
- Zero radius, dramatic whitespace
- Example: Rich black + warm bronze + cream

#### 9. Industrial
**Use when:** Creative/artistic audience, loft/urban aesthetic
- Raw material colors (rust, concrete, copper)
- Bold condensed headings, workman-like body
- Minimal radius, textured feel
- Example: Rust + charcoal steel + bronze

### Tier 3: Absolute Bonkers

#### 10. Pure Brutalism
**Use when:** Architecture/design audience, statement brand
- Concrete grays with safety orange accent
- Heavy condensed headings
- Zero radius, heavy shadows
- Example: Concrete gray + construction orange

#### 11. High Contrast
**Use when:** Accessibility as brand statement, bold positioning
- Pure primary colors (blue, yellow, red on white)
- System fonts at large sizes
- Zero radius, heavy borders
- Example: Pure blue + pure yellow + black borders

#### 12. Anti-Design
**Use when:** Ironic/self-aware brand, tech-savvy audience
- Default browser colors (link blue, visited purple)
- System fonts (Times, Arial)
- Zero styling, spreadsheet aesthetic
- Example: Link blue + system gray + highlighter yellow

#### 13. Retro Computing
**Use when:** Tech nostalgia, hacker culture, memorable positioning
- Green phosphor on black (or amber variant)
- Monospace everything
- Zero radius, terminal aesthetic
- Example: Phosphor green + CRT black

#### 14. Terminal/IDE
**Use when:** Developer audience, technical product
- Dark editor colors with syntax highlighting accents
- Monospace fonts throughout
- Small radius, no shadows
- Example: Editor dark + syntax blue + syntax yellow

#### 15. Newspaper
**Use when:** Information authority, classic media positioning
- Newsprint + ink black + masthead red
- Classic newspaper typography
- Zero radius, column-based layouts
- Example: Newsprint cream + ink black + masthead red

---

## Preview Pages to Build

### 1. Component Showcase
Shows all UI elements with current theme:
- Typography scale (h1-h6, body, small)
- Button variants (primary, secondary, outline, ghost, destructive)
- Cards (listing card, info card, testimonial card)
- Form elements (inputs, textareas, selects, checkboxes)
- Alerts (success, info, warning, error)
- Badges (various states)

### 2. Home Page Preview
- Hero section with headline + CTA
- Feature cards (3-column grid)
- Featured listing/item
- Call-to-action section
- Footer preview

### 3. Detail/Listing Page Preview
- Image gallery with navigation
- Title + metadata section
- Description card
- Feature list
- Sidebar with pricing + CTA
- Related items carousel

### 4. Dashboard Preview
- Sidebar navigation
- Stats cards (4-column)
- Data table or list
- Action buttons
- User avatar/menu

---

## Implementation Checklist

### Phase 1: Setup
- [ ] Create `/app/design-system/page.tsx`
- [ ] Define `Theme` interface
- [ ] Create theme objects (start with 6-9)
- [ ] Set up CSS variable system
- [ ] Build theme switcher UI

### Phase 2: Components
- [ ] `ThemedButton` - respects theme colors/radius
- [ ] `ThemedCard` - respects theme shadows/borders
- [ ] `ThemedInput` - respects theme styling
- [ ] `ThemedBadge` - respects theme colors
- [ ] `ThemedAlert` - respects theme colors

### Phase 3: Preview Pages
- [ ] Component showcase
- [ ] Home page preview
- [ ] Detail page preview
- [ ] Dashboard preview

### Phase 4: Polish
- [ ] Add real images (use Vercel Blob or placeholder service)
- [ ] Write realistic copy for previews
- [ ] Add theme descriptions/taglines
- [ ] Test on mobile
- [ ] Add prev/next navigation
- [ ] Make selector collapsible

### Phase 5: Feedback System (Client Projects Only)
- [ ] Add `DesignFeedback` model to schema
- [ ] Run `prisma db push`
- [ ] Create `/api/design-feedback` route
- [ ] Build `FeedbackPanel` component
- [ ] Add reviewer names to toggle
- [ ] Test rating persistence
- [ ] Add feedback summary view (optional)

---

## After Client Decision

### Document the Choice

```markdown
## Chosen Direction

**Theme:** [Name]
**Tier:** [Proven & Safe / Bold & Contrarian / Absolute Bonkers]

**Why this direction:**
- [Reason 1]
- [Reason 2]
- [Reason 3]

**Modifications requested:**
- [Any tweaks to colors, fonts, etc.]

**Feedback Summary:**
| Reviewer | Rating | Notes |
|----------|--------|-------|
| [Name]   | [Rating] | [Notes] |
```

### Extract to Production

1. Copy final color values to `globals.css`:
```css
:root {
  --primary: [hex];
  --primary-foreground: [hex];
  /* ... */
}
```

2. Update `tailwind.config.ts` with font families

3. Load fonts in `layout.tsx` (Google Fonts or local)

4. Remove or archive `/design-system` page

5. (Optional) Keep `DesignFeedback` table for future iteration

---

## Tips for Theme Creation

### Color Harmony
- Use a color tool (Coolors, Adobe Color) for palette generation
- Ensure sufficient contrast ratios (4.5:1 for text)
- Test colors with actual UI components, not just swatches

### Font Pairing
- Contrast heading and body fonts (serif + sans, or display + text)
- Limit to 2 fonts maximum
- Consider loading performance (fewer weights = faster)

### Radius Strategy
- 0px = Sharp, architectural, serious
- 4-8px = Professional, clean
- 12-16px = Friendly, approachable
- 24px+ = Playful, soft

### Shadow Strategy
- No shadows = Flat, modern, print-like
- Subtle shadows = Depth, premium feel
- Heavy shadows = Dramatic, attention-grabbing

---

## Resources

- [Realtime Colors](https://realtimecolors.com) - Preview colors on real UI
- [Coolors](https://coolors.co) - Palette generation
- [Google Fonts](https://fonts.google.com) - Font discovery
- [Contrast Checker](https://webaim.org/resources/contrastchecker/) - Accessibility testing
- [shadcn/ui](https://ui.shadcn.com) - Component reference

---

_Last updated: [DATE]_
_Status: [Themes ready for review / Collecting feedback / Client chose X / Applied to production]_
