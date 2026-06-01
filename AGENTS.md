# AGENTS.md

## What this is

Hexo 8 (node_modules: 8.1.0, package.json meta: 8.0.0) static blog, theme **Fluid** v1.9.8, deployed to GitHub Pages at `jgq12138.github.io` (zh-CN, Asia/Shanghai).

## Commands

| Purpose | Command |
|---------|---------|
| Build | `npm run build` (hexo generate) |
| Dev server | `npm run server` (hexo server) |
| Clean cache | `npm run clean` (hexo clean) |
| Manual deploy | `npm run deploy` (hexo deploy → gh-pages) |
| New post | `npx hexo new "Title"` |
| New page | `npx hexo new page "Name"` |

## CI / Deploy

- **Branches**: `main` (source), `gh-pages` (old deployer-git target)
- GitHub Actions (`.github/workflows/pages.yml`) pushes `./public` to GitHub Pages on commit to `main`. This is the primary deployment — `npm run deploy` is a secondary fallback.
- VS Code has a `Run hexo` launch config (`hexo server`).

## Structure

- `source/_posts/` — blog posts (markdown + front-matter)
- `scaffolds/` — post/page/draft templates
- `_config.yml` — Hexo site config
- `_config.fluid.yml` — Fluid theme config (1096 lines)
- `public/`, `.deploy_git/` — build artifacts (gitignored, don't edit)

## No tests / lint / typecheck

This repo has no test runner, linter, or type checker.
