# Quartz Blog - Claude Instructions

## Running with Bun

This Quartz blog runs exclusively with Bun (no npm/node):

```bash
# Start development server with live reload
bun run quartz/bootstrap-cli.mjs build --serve

# Server runs at http://localhost:8080
# Auto-rebuilds on file changes in content/
```

## Obsidian.nvim Integration

The `content/` directory is configured as an obsidian.nvim workspace:
- Workspace name: `quartz`
- Files created with timestamp IDs: `1762884193-note-name.md`
- Frontmatter includes `title`, `id`, `aliases`, and `tags`
- Wikilinks work via aliases (e.g., `[[note name]]` → `1762884193-note-name.md`)

**Note**: obsidian.nvim adds an H1 heading after frontmatter - delete it manually (Quartz uses frontmatter `title` for page heading)

## Important Config Changes

### Ignore Patterns (quartz.config.ts:20)
```typescript
ignorePatterns: ["private", "templates", ".obsidian", "**/.conform.*", "**/.*", "**/*~"]
```
This prevents Quartz from crashing on conform.nvim temp files.

### Obsidian.nvim Config (~/.config/nvim/lua/plugins/obsidian.lua)
- Quartz workspace added at line 72-75
- `note_frontmatter_func` at line 116-131 ensures `title` field is included

## Content Structure

```
content/
├── index.md              # Homepage
└── *.md                  # Blog posts/notes
```

All markdown files should have frontmatter with at least:
```yaml
---
title: Page Title
---
```

Do NOT duplicate the title as `# Title` in content - Quartz auto-generates it from frontmatter.
