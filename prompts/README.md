# /prompts - Large System Prompts

This folder contains prompts that are too large to embed directly in command files.

---

## Available Prompts

| File | Purpose | Size |
|------|---------|------|
| `PROMPT_KEYWORD_RESEARCH.txt` | SEO keyword research with Keywords Everywhere MCP | ~450 lines |
| `PROMPT_LONG_TAIL_SEO.txt` | Complete SEO article generation system | ~3700 lines |

---

## Usage

These prompts are referenced by slash commands:

- `/add-seo` - Runs both SEO prompts in order

**To use manually:**
1. Ask Claude Code to read the prompt file
2. Follow the instructions in the prompt
3. The prompt will guide you through the rest

---

## When to Add Prompts Here

Add a prompt to this folder when:
- It exceeds ~200 lines (too large for command file)
- It's a comprehensive system prompt
- It needs to be version controlled

For smaller prompts, embed them directly in `.claude/commands/*.md` files.

---

_Prompts are version controlled so Claude Code can read and execute them._
