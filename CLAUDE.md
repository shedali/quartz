# Quartz Blog - Claude Instructions

## Development Environment

This Quartz blog uses Nix flakes and direnv for environment management:

```bash
# Activate the environment (first time)
direnv allow

# Environment includes: bun, git, rsync, xc, fzf, mdcat
```

## Task Runner

Use the interactive task picker via Make + xc:

```bash
make run    # Shows interactive task picker
xc serve    # Run task directly
```

Tasks are documented in README.md with xc format.

## Building the Site

This Quartz blog runs exclusively with Bun (no npm/node) and has reproducible builds via Nix:

### Local Development (with Bun)

```bash
# Development server with live reload
bun run quartz/bootstrap-cli.mjs build --serve
# Server runs at http://localhost:8080
# Auto-rebuilds on file changes in content/

# Just build (no server)
bun run quartz/bootstrap-cli.mjs build
```

### Reproducible Build (with Nix)

The same build process used in CI:

```bash
# Build the site using Nix (produces ./result)
nix build

# The built site is available in ./result/
# View locally:
python -m http.server --directory result 8080
```

This build is fully reproducible - it will produce identical output locally and in CI.

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

The `content/` directory is **symlinked** to `~/dev/shedali/knowledge/posts` for local development.

```
content/ -> ~/dev/shedali/knowledge/posts/
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

## Publishing Workflow

Since content is symlinked, use these scripts before deploying:

### For Local Development (current state)

Content is symlinked - changes to `~/dev/shedali/knowledge/posts` appear immediately.

### Before Deploying to GitHub Pages

```bash
# Sync content and deploy
./sync-content.sh
git add content/
git commit -m "Update content"
git push

# Restore symlink for local dev
./restore-symlink.sh
```

Or use xc tasks:

```bash
xc publish    # Syncs content and stages for commit
xc deploy     # Full deploy workflow (sync, commit, push)
```

**Scripts:**

- `sync-content.sh` - Copies content from knowledge vault, removes symlink
- `restore-symlink.sh` - Restores symlink for local development

## GitHub Pages Deployment

The repo is configured with GitHub Actions to automatically deploy to GitHub Pages on push to `v4` branch.

**Workflow**: `.github/workflows/deploy-pages.yaml`

The CI/CD pipeline uses Nix for fully reproducible builds:

- Triggers on push to `v4` branch or manual workflow dispatch
- Installs Nix using DeterminateSystems/nix-installer-action
- Uses DeterminateSystems/magic-nix-cache-action for fast, cached builds
- Builds the site using `nix build` (same command works locally)
- Deploys the `public/` directory to GitHub Pages

**Setup Requirements**:

1. Enable GitHub Pages in repo settings
2. Set source to "GitHub Actions"
3. Content must be synced (not symlinked) before pushing

**Benefits of Nix-based CI**:

- **Fully reproducible**: Same build output locally and in CI
- **Hermetic**: All dependencies pinned via flake.lock
- **Fast caching**: Magic Nix Cache significantly speeds up builds
- **No version drift**: Exact same Bun, git, and dependencies everywhere

The workflow automatically handles building and deploying - no manual build step needed after pushing.
