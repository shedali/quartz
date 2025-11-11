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

### sync-content

Copy content from Obsidian vault to quartz for deployment (removes symlink)

```bash
./sync-content.sh
```

### restore-symlink

Restore symlink to Obsidian vault for local development

```bash
./restore-symlink.sh
```

### publish

Prepare content for deployment (sync, stage, and show commit prompt)

```bash
./sync-content.sh && git add content/ && echo 'Ready to commit. Run: git commit -m "Update content" && git push'
```

### deploy

Deploy to GitHub Pages (syncs content, commits, and pushes)

```bash
./sync-content.sh && git add content/ && git commit -m "Update content" && git push && ./restore-symlink.sh
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

## Scripts

All tasks above are defined as xc tasks and call these scripts:

- **`sync-content.sh`** - Copies content from `~/dev/shedali/knowledge/posts` to `content/`, removing symlink for deployment
- **`restore-symlink.sh`** - Restores symlink from `content/` to `~/dev/shedali/knowledge/posts` for local development

## Content Structure

- **Local development**: `content/` is a symlink to `~/dev/shedali/knowledge/posts`
- **Deployment**: Run `sync-content` to copy files and remove symlink before committing
- **After deployment**: Run `restore-symlink` to continue local development

## Configuration

- **Quartz config**: `quartz.config.ts`
- **Layout**: `quartz.layout.ts`
- **obsidian.nvim**: Configured with "quartz" workspace pointing to `content/`
- **Nix environment**: `flake.nix` provides bun, git, rsync, xc, fzf, mdcat

## Links

- [Quartz Documentation](https://quartz.jzhao.xyz/)
- [Obsidian Vault](~/dev/shedali/knowledge/)
