# CONTRIBUTING.md

## Project Purpose
`utils-repl` is a professional-grade Python package that enhances REPL (interactive Python shell) workflows. It emphasizes code clarity, semantic versioning, robust release management, and developer productivity. The initial utility is `ImportTracker`. Future tools will support dynamic inspection, hot reloading, and quality-of-life improvements.

---

## Branching Strategy

### Long-Lived Branches
- `main`: Production-ready. Linear history. Protected.
- `development`: Collects feature work. Allows merge commits.

### Short-Lived Branches
- `feature/*`: Branched from `development`. PR back into `development`.
- `release/*`: Branched from `main`. Cherry-picks merge commits from `development`.

---

## Feature Workflow
1. `git checkout development && git pull`
2. `git checkout -b feature/<short-description>`
3. Develop and commit changes
4. Open a PR from `feature/*` → `development`

> Feature developers do not push directly to `main`. Versioning and production releases are handled by the release admin.

---

## Release Workflow (Release Admin)
1. `git checkout main && git pull`
2. `git checkout -b release/<version>`
3. Cherry-pick individual merge commits from `development`
4. Reword or squash commits to follow Conventional Commits
5. Push `release/*` to GitHub
6. This triggers `release-please` → opens PR to `main`
7. Review the version bump and changelog, then merge

> Merging to `main` triggers `publish-pypi.yaml`, which builds and publishes to PyPI

---

## Commit Style
Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

Examples:
- `feat(import-tracker): add regex filtering`
- `fix(core): resolve REPL crash`
- `chore: update dev dependencies`

Types:
- `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

> Use `!` or `BREAKING CHANGE:` in the commit body to denote breaking changes

---

## Development Standards
- Python version: `>=3.13,<4.0`
- Project layout: `src/utils_repl/`
- Typing: Full type hints required
- Dependencies: Managed with Poetry
- Logging: Use `logging` module, level `INFO` by default

---

## Setup Commands
Use Poetry:
- Install dependencies: `poetry install --with dev`
- Run tests: `make test`
- Lint code: `make lint`

---

## Automation & Protections
- `release-please.yaml`: Automates changelog/version bump
- `publish-pypi.yaml`: Builds and uploads to PyPI on tagged releases
- Branch protections enforced via:
  - `main-branch-protection.yaml`
  - `development-branch-protection.yaml`
  - `feature-branch-protection.yaml`
- Workflows restricted by `CODEOWNERS`

---

Thank you for contributing to `utils-repl`. Please follow this guide to ensure consistent, high-quality changes.
