#!/bin/bash

# Session Start Hook for hashbuilds-starter
# Outputs project status so Claude knows where we are

cd "$CLAUDE_PROJECT_DIR" || exit 0

echo "📋 PROJECT STATUS (Auto-scanned)"
echo "================================"
echo ""

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

if [ -f ".env" ]; then
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
else
  echo "| All | ⚠️ No .env file |"
fi
echo ""

# Check Specs
echo "## Feature Specs"
echo ""
if [ -d "specs" ]; then
  spec_count=$(find specs -name "*.md" ! -name "README.md" ! -name "_TEMPLATE.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$spec_count" -gt 0 ]; then
    planning=$(grep -l "Status.*Planning" specs/*.md 2>/dev/null | wc -l | tr -d ' ')
    ready=$(grep -l "Status.*Ready" specs/*.md 2>/dev/null | wc -l | tr -d ' ')
    in_progress=$(grep -l "Status.*In Progress" specs/*.md 2>/dev/null | wc -l | tr -d ' ')
    complete=$(grep -l "Status.*Complete" specs/*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "- Planning: $planning"
    echo "- Ready: $ready"
    echo "- In Progress: $in_progress"
    echo "- Complete: $complete"
  else
    echo "No feature specs yet. Use /create-spec to start."
  fi
else
  echo "No specs folder."
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

# Suggest next step
echo "## Suggested Next Step"
echo ""

# Logic: empty docs → fill them, no services → configure, no specs → create spec
if ! grep -q "DATABASE_URL" .env 2>/dev/null; then
  echo "→ Configure database: Read docs/services/01-database.md"
elif ! grep -q "NEXTAUTH_SECRET" .env 2>/dev/null; then
  echo "→ Configure auth: Read docs/services/02-auth.md"
elif [ "$spec_count" = "0" ] 2>/dev/null; then
  echo "→ Create first feature spec: /create-spec [feature-name]"
elif [ "$ready" -gt 0 ] 2>/dev/null; then
  echo "→ Implement a ready spec: /implement-spec [name]"
else
  echo "→ Continue building or run /check-progress for details"
fi

echo ""
echo "---"
echo "Run /check-progress for detailed status."

exit 0
