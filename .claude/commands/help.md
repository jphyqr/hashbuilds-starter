# Help

Smart router that guides users to the right starting point based on their situation.

## Instructions

When the user runs `/help`, present a quick assessment and route them appropriately.

### Step 1: Quick Scan

First, silently scan the project state:

```bash
# Check if fresh project
test -f .env && echo "env exists" || echo "fresh"

# Check if node_modules exists
test -d node_modules && echo "deps installed" || echo "no deps"

# Check docs status
grep -c "[A-Za-z]" docs/01-project-origin.md 2>/dev/null || echo "0"
grep -c "[A-Za-z]" docs/product/north-star.md 2>/dev/null || echo "0"
```

### Step 2: Determine User's Path

Present this quick router:

```
👋 WELCOME TO HASHBUILDS STARTER
================================

This starter helps you build AND think like a product team.

Where are you in your journey?

**A) Fresh start** - "I just cloned this, show me everything"
   → Full guided tour

**B) Business-first** - "I know what to build but need to document it"
   → Strategy docs, then tech

**C) Tech-first** - "I have a clear idea, just need to set up infra"
   → Services setup, backlog later

**D) Already running** - "Project is set up, what can I do?"
   → Show available commands

Which path? (A/B/C/D)
```

### Path A: Fresh Start (Full Tour)

```
📚 FULL GUIDED TOUR
===================

This starter has 4 main sections:

1. **Business Context** (docs/)
   - Project origin story
   - Business model & constraints
   - Design system preferences
   - Tech stack decisions

2. **Product Management** (docs/product/)
   - North star metric (what's success?)
   - Prioritization framework (how to decide?)
   - Feature backlog (what to build?)
   - Feature specs (how to build?)

3. **Services** (docs/services/)
   - Database, Auth, Email
   - Payments, Storage
   - All with setup guides

4. **Growth** (docs/gtm/)
   - SEO, Launch strategy
   - For after MVP ships

Recommended order for new projects:

1. First, define your project → fill out docs/01-project-origin.md
2. Set up tech → run /setup
3. Define success → fill out docs/product/north-star.md
4. Start building → use /add-idea, /prioritize, /new-feature

Ready to start? Run `/setup` to begin the technical setup,
or open docs/01-project-origin.md to start with strategy.
```

### Path B: Business-First

```
📋 BUSINESS-FIRST PATH
======================

Great for: Consultants, founders, non-technical leads

Start with strategy, then build:

**Step 1: Document Your Vision**
Fill out these docs in order:

| Doc | What It Captures |
|-----|------------------|
| docs/01-project-origin.md | Problem, audience, initial scope |
| docs/02-business-context.md | Revenue model, constraints, timeline |
| docs/03-design-system.md | Colors, fonts, style preferences |
| docs/04-tech-stack.md | Tech choices (or accept defaults) |

**Step 2: Define Success**
| Doc | What It Captures |
|-----|------------------|
| docs/product/north-star.md | ONE metric that defines success |
| docs/product/framework.md | How you'll prioritize features |

**Step 3: Plan Features**
- Use `/add-idea` to capture features
- Use `/prioritize` to score and rank
- Use `/create-spec` for complex features

**Step 4: Set Up Tech (when ready)**
- Run `/setup` to configure services

Start by opening: docs/01-project-origin.md
```

### Path C: Tech-First

```
⚡ TECH-FIRST PATH
==================

Great for: Engineers, technical founders, clear specs

Get running fast, document later:

**Step 1: Infrastructure**
Run `/setup` to configure:
- Database (PostgreSQL)
- Auth (NextAuth + magic link)
- Email (Resend)
- Optional: Payments, Storage

**Step 2: Start Building**
- Use `/add-idea [feature]` to capture what you're building
- For small features: build directly
- For complex features: `/create-spec [name]` first

**Step 3: Document (do this eventually)**
- Fill out docs/01-project-origin.md (helps handoff)
- Set docs/product/north-star.md (helps prioritize)

Start by running: /setup
```

### Path D: Already Running

```
🎛️ AVAILABLE COMMANDS
=====================

**Product Management:**
| Command | Purpose |
|---------|---------|
| /add-idea [desc] | Capture idea to backlog |
| /prioritize | Score and rank all backlog items |
| /new-feature [name] | Build feature (routes through backlog) |
| /create-spec [name] | Create detailed spec for complex features |
| /implement-spec [name] | Build from existing spec |

**Session Management:**
| Command | Purpose |
|---------|---------|
| /check-progress | Full project status |
| /end-session | Wrap up, update progress log |

**Setup & Config:**
| Command | Purpose |
|---------|---------|
| /setup | Configure services (database, auth, etc.) |
| /help | This menu |

**Growth (Post-MVP):**
| Command | Purpose |
|---------|---------|
| /add-seo | Set up programmatic SEO |

**Quick Status:**
Your session hook already shows project status on startup.
Check the tables at the top of each conversation.
```

### Step 3: Follow Up

After presenting the path, ask:

```
Would you like me to:
1. Open the first doc for your path?
2. Run the first command?
3. Explain something in more detail?
```

## Notes

- Session-start hook already scans project state
- This is for users who need explicit guidance
- Always bias toward action - get them started, don't over-explain
- The four paths cover most use cases without being overwhelming
