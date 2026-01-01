#!/bin/bash

# Session Start Hook for hashbuilds-starter
# Outputs project status so Claude knows where we are

cd "$CLAUDE_PROJECT_DIR" || exit 0

echo "📋 PROJECT STATUS (Auto-scanned)"
echo "================================"
echo ""

# Check if this is a fresh clone (no .env)
if [ ! -f ".env" ]; then
  echo "⚠️  FRESH PROJECT DETECTED"
  echo ""
  echo "Run these commands to get started:"
  echo "  cp .env.example .env"
  echo "  pnpm install"
  echo ""
  echo "Then run /setup to configure the project."
  echo ""
  echo "---"
  exit 0
fi

# Check Setup Docs
echo "## Setup Docs"
echo ""

check_doc_filled() {
  local file="$1"
  local name="$2"

  if [ ! -f "$file" ]; then
    echo "| $name | ⬜ Missing |"
    return
  fi

  # Count non-empty, non-comment lines (excluding template markers)
  local content_lines=$(grep -v "^#" "$file" | grep -v "^\s*$" | grep -v "^\[" | grep -v "^_\[" | grep -v "^<!--" | wc -l | tr -d ' ')

  if [ "$content_lines" -gt 20 ]; then
    echo "| $name | ✅ Filled |"
  elif [ "$content_lines" -gt 5 ]; then
    echo "| $name | 📝 Partial |"
  else
    echo "| $name | ⬜ Empty |"
  fi
}

echo "| Doc | Status |"
echo "|-----|--------|"
check_doc_filled "docs/01-project-origin.md" "01-project-origin"
check_doc_filled "docs/02-business-context.md" "02-business-context"
check_doc_filled "docs/03-design-system.md" "03-design-system"
check_doc_filled "docs/04-tech-stack.md" "04-tech-stack"
echo ""

# Check Services via .env
echo "## Services"
echo ""
echo "| Service | Status |"
echo "|---------|--------|"

if grep -q "DATABASE_URL" .env 2>/dev/null; then
  echo "| Database | ✅ Configured |"
else
  echo "| Database | ⬜ Not configured |"
fi

if grep -q "NEXTAUTH_SECRET" .env 2>/dev/null; then
  echo "| Auth | ✅ Configured |"
else
  echo "| Auth | ⬜ Not configured |"
fi

if grep -q "RESEND_API_KEY\|EMAIL_SERVER" .env 2>/dev/null; then
  echo "| Email | ✅ Configured |"
else
  echo "| Email | ⬜ Not configured |"
fi

if grep -q "STRIPE" .env 2>/dev/null; then
  echo "| Payments | ✅ Configured |"
else
  echo "| Payments | ⬜ Not needed yet |"
fi

if grep -q "BLOB_READ_WRITE_TOKEN" .env 2>/dev/null; then
  echo "| Storage | ✅ Configured |"
else
  echo "| Storage | ⬜ Not needed yet |"
fi
echo ""

# Check Product Backlog
echo "## Product Backlog"
echo ""

if [ -f "docs/product/backlog.md" ]; then
  # Count backlog items by status
  ideas=$(grep -c "| idea |" docs/product/backlog.md 2>/dev/null || echo "0")
  scored=$(grep -c "| scored |" docs/product/backlog.md 2>/dev/null || echo "0")
  spec_ready=$(grep -c "| spec-ready |" docs/product/backlog.md 2>/dev/null || echo "0")
  in_prog=$(grep -c "| in-progress |" docs/product/backlog.md 2>/dev/null || echo "0")

  total=$((ideas + scored + spec_ready + in_prog))

  if [ "$total" -gt 0 ]; then
    echo "| Status | Count |"
    echo "|--------|-------|"
    echo "| Ideas (unscored) | $ideas |"
    echo "| Scored | $scored |"
    echo "| Spec Ready | $spec_ready |"
    echo "| In Progress | $in_prog |"
    echo ""

    # Show top 3 scored items
    echo "**Top priorities:**"
    # Extract top items (this is approximate - full parsing needs Claude)
    grep -E "^\| [0-9]+ \|" docs/product/backlog.md | grep -v "| ? |" | head -3 | while read line; do
      id=$(echo "$line" | cut -d'|' -f2 | tr -d ' ')
      idea=$(echo "$line" | cut -d'|' -f3 | tr -d ' ' | cut -c1-40)
      score=$(echo "$line" | cut -d'|' -f5 | tr -d ' ')
      if [ -n "$id" ] && [ -n "$idea" ]; then
        echo "- #$id: $idea... (Score: $score)"
      fi
    done
  else
    echo "Backlog empty. Use /add-idea to capture ideas."
  fi
else
  echo "No backlog yet. Run /add-idea to start."
fi
echo ""

# Check Specs
echo "## Feature Specs"
echo ""
spec_count=0
planning=0
ready=0
in_progress=0
complete=0

if [ -d "docs/product" ]; then
  spec_count=$(find docs/product -name "*.md" ! -name "README.md" ! -name "_template.md" ! -name "backlog.md" ! -name "north-star.md" ! -name "framework.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$spec_count" -gt 0 ]; then
    planning=$(grep -l "Status.*Planning" docs/product/*.md 2>/dev/null | wc -l | tr -d ' ')
    ready=$(grep -l "Status.*Ready" docs/product/*.md 2>/dev/null | wc -l | tr -d ' ')
    in_progress=$(grep -l "Status.*In Progress" docs/product/*.md 2>/dev/null | wc -l | tr -d ' ')
    complete=$(grep -l "Status.*Complete" docs/product/*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "- Planning: $planning"
    echo "- Ready: $ready"
    echo "- In Progress: $in_progress"
    echo "- Complete: $complete"
  else
    echo "No feature specs yet. Use /create-spec to start."
  fi
else
  echo "No product folder. Run /setup first."
fi
echo ""

# GTM Status
echo "## GTM (Go-to-Market)"
echo ""
if grep -q "ANTHROPIC_API_KEY" .env 2>/dev/null && grep -q "CRON_SECRET" .env 2>/dev/null; then
  echo "| SEO System | ✅ Configured |"
else
  echo "| SEO System | ⬜ Not set up (run /add-seo after MVP) |"
fi
echo ""

# Codebase stats
echo "## Codebase"
echo ""
routes=$(find app -name "page.tsx" 2>/dev/null | wc -l | tr -d ' ')
components=$(find components -name "*.tsx" 2>/dev/null | wc -l | tr -d ' ')
api_routes=$(find app/api -name "route.ts" 2>/dev/null | wc -l | tr -d ' ')
models=$(grep -c "^model " prisma/schema.prisma 2>/dev/null || echo "0")

echo "- Routes: $routes"
echo "- Components: $components"
echo "- API Routes: $api_routes"
echo "- Prisma Models: $models"
echo ""

# Last session from progress.md
echo "## Last Session"
echo ""
if [ -f "deliverables/progress.md" ]; then
  # Get most recent date header
  last_date=$(grep "^## \[" deliverables/progress.md | head -1 | sed 's/## //' | tr -d '[]')
  if [ -n "$last_date" ]; then
    echo "**Date:** $last_date"
  fi

  # Get next session items
  next_items=$(sed -n '/### Next Session/,/^---/p' deliverables/progress.md | grep "^\- \[" | head -3)
  if [ -n "$next_items" ]; then
    echo "**Planned:**"
    echo "$next_items"
  fi
else
  echo "No progress log yet."
fi
echo ""

# Determine current phase and suggest next step
echo "## Suggested Next Step"
echo ""

# Phase detection logic
if ! grep -q "DATABASE_URL" .env 2>/dev/null; then
  echo "**Phase:** Foundation Setup"
  echo "→ Configure database: Read docs/services/01-database.md"
elif ! grep -q "NEXTAUTH_SECRET" .env 2>/dev/null; then
  echo "**Phase:** Services Setup"
  echo "→ Configure auth: Read docs/services/02-auth.md"
elif ! grep -q "RESEND_API_KEY\|EMAIL_SERVER" .env 2>/dev/null; then
  echo "**Phase:** Services Setup"
  echo "→ Configure email: Read docs/services/03-email.md"
elif [ "$spec_count" = "0" ] && [ "$total" = "0" ]; then
  echo "**Phase:** Feature Development"
  echo "→ Capture your first idea: /add-idea [description]"
elif [ "$ideas" -gt 0 ]; then
  echo "**Phase:** Feature Development"
  echo "→ Prioritize backlog: /prioritize"
elif [ "$ready" -gt 0 ]; then
  echo "**Phase:** Feature Development"
  echo "→ Implement a ready spec: /implement-spec [name]"
elif [ "$in_progress" -gt 0 ]; then
  echo "**Phase:** Feature Development"
  echo "→ Continue in-progress spec"
elif [ "$routes" -gt 3 ]; then
  if ! grep -q "ANTHROPIC_API_KEY" .env 2>/dev/null; then
    echo "**Phase:** Go-to-Market"
    echo "→ Set up SEO: /add-seo"
  else
    echo "**Phase:** Growth"
    echo "→ Continue building or review /check-progress"
  fi
else
  echo "→ Run /check-progress for detailed status"
fi

echo ""
echo "---"
echo "Commands: /add-idea | /prioritize | /create-spec | /check-progress | /end-session"

exit 0
