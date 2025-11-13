# Quartz Blog

Personal digital garden built with Quartz v4, using Bun and connected to my Obsidian knowledge vault.

## Development Setup

This project uses Nix flakes and direnv for environment management. Run `direnv allow` to activate the development environment.

## Tasks

Run tasks using the interactive picker:

```bash
make run
```

Or directly with xc:

```bash
xc <task-name>
```

### serve

Start the Quartz development server with live reload

```bash
bun run quartz/bootstrap-cli.mjs build --serve
```

### build

Build the site without starting the server

```bash
bun run quartz/bootstrap-cli.mjs build
```

### publish

Stage content changes and show diff

```bash
git add content/ && git status && git diff --staged --stat
```

### deploy

Deploy to GitHub Pages (commit and push)

```bash
git add content/ && git commit -m "Update content" && git push
```

### format

Format code with prettier

```bash
npx prettier . --write
```

### check

Type-check and lint without making changes

```bash
tsc --noEmit && npx prettier . --check
```

## Content Structure

The `content/` directory is the **source of truth** for all blog posts and notes. Edit files directly in this directory, either:
- Locally on your Mac
- Via GitHub web editor
- On mobile/iPad using Working Copy or similar git clients

All changes should be committed to git. No symlinks, no sync scripts - just edit, commit, and push.

## Configuration

- **Quartz config**: `quartz.config.ts`
- **Layout**: `quartz.layout.ts`
- **obsidian.nvim**: Configured with "quartz" workspace pointing to `content/`
- **Nix environment**: `flake.nix` provides bun, git, rsync, xc, fzf, mdcat

## Publishing Workflow

1. **Write content**: Edit markdown files in `content/` directory
2. **Preview locally**: `xc serve` or `make run`
3. **Deploy**:
   - Quick: `xc deploy` (commits with "Update content")
   - Custom: `git add content/ && git commit -m "your message" && git push`
4. **Live in ~1-2 minutes**: https://shedali.github.io/quartz/

## Mobile Editing

Edit from anywhere using:
- **GitHub Web Editor**: Press `.` on any file in GitHub
- **Working Copy** (iOS): Full-featured git client
- **GitHub Mobile App**: Quick edits on the go

All changes automatically deploy via GitHub Actions.

## Links

- [Quartz Documentation](https://quartz.jzhao.xyz/)
- [Live Site](https://shedali.github.io/quartz/)
