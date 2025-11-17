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

The `content/` directory is the **source of truth** for all blog content.

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

**Important**: Do NOT duplicate the title as `# Title` in content - Quartz auto-generates it from frontmatter. When using obsidian.nvim, delete the auto-generated H1 heading it creates after frontmatter.

## Academic Citations

Quartz has full academic citation support via the Citations plugin (configured in `quartz.config.ts:75-87`).

### Citation Syntax

Use standard Pandoc citation syntax in your markdown:

```markdown
According to research [@citation-key], this is important.

Multiple citations [@key1; @key2; @key3].

In-text citation: @citation-key says that...

## References
Bibliography auto-generates here
```

### Bibliography Sources

Citations are fetched from GitHub-hosted `.bib` files (no local files needed):

- `https://raw.githubusercontent.com/shedali/citations/main/engineering.bib`
- `https://raw.githubusercontent.com/shedali/citations/main/health.bib`
- `https://raw.githubusercontent.com/shedali/citations/main/business.bib`
- `https://raw.githubusercontent.com/shedali/citations/main/politics.bib`
- `https://raw.githubusercontent.com/shedali/citations/main/psychology.bib`
- `https://raw.githubusercontent.com/shedali/citations/main/writing.bib`

All files are merged automatically. Add new entries to the [citations repository](https://github.com/shedali/citations).

### Citation Style

Currently using APA style (`csl: "apa"`). Can be changed to:
- `"chicago"`
- `"ieee"`
- `"mla"`
- `"harvard"`
- Or custom CSL file URL

### Example Post

See `content/test-citations.md` for a working example.

## Publishing Workflow

Content is directly committed to the repository, enabling editing from anywhere.

### Local Development

```bash
# Edit files in content/ directory
# Preview changes:
xc serve       # or: bun run quartz/bootstrap-cli.mjs build --serve
# Visit http://localhost:8080
```

### Deploy to GitHub Pages

```bash
# Option 1: Quick deploy
xc deploy      # Commits with "Update content" and pushes

# Option 2: Custom commit message
git add content/
git commit -m "Add post about X"
git push
```

### Mobile Editing

Edit from anywhere:
- **GitHub Web Editor**: Press `.` on any file in the GitHub repo
- **Working Copy** (iOS): Full-featured git client for iOS
- **GitHub Mobile App**: Quick edits on the go

All changes automatically trigger GitHub Actions deployment. Site updates in ~1-2 minutes.

## GitHub Pages Deployment

The repo is configured with GitHub Actions to automatically deploy to GitHub Pages on push to `main` branch.

**Workflow**: `.github/workflows/deploy-pages.yaml`

The CI/CD pipeline uses Bun for fast builds:

- Triggers on push to `main` branch (or any branch) or manual workflow dispatch
- Uses `oven-sh/setup-bun@v2` to install Bun
- Runs `bun install` to install dependencies
- Builds the site using `bun run quartz/bootstrap-cli.mjs build`
- Deploys the `public/` directory to GitHub Pages
- Build time: ~11-14 seconds

**GitHub Pages Settings**:

- Source: "GitHub Actions"
- Deployment branches: `main` and `v4` are both allowed
- Live URL: https://shedali.github.io/quartz/

The workflow automatically handles building and deploying - no manual build step needed after pushing.
