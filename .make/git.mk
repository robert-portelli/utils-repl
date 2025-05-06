# git.mk — Git-related workflow commands
.PHONY: feature start-release sync-dev

# 🪄 Git Branch Management

# Create a feature branch from development
# Usage: make feature FEATURE=short-branch-name
feature:
	@if [ -z "$(FEATURE)" ]; then \
		echo "❌ ERROR: FEATURE is not set."; \
		echo "✅ Usage: make feature FEATURE=short-branch-name"; \
		exit 1; \
	fi
	git checkout development
	git pull origin development
	git checkout -b feature/$(FEATURE)
	git push -u origin feature/$(FEATURE)

# Create a release preparation branch from main
# Usage: make start-release DATE=yyyy-mm
start-release:
	@if [ -z "$(DATE)" ]; then \
		echo "❌ ERROR: DATE is not set."; \
		echo "✅ Usage: make start-release DATE=yyyy-mm"; \
		exit 1; \
	fi
	git checkout main
	git pull origin main
	git checkout -b release/prepare-$(DATE)
	git push -u origin release/prepare-$(DATE)


# 📋 GitHub PR Commands

# Create PR targeting development branch
pr-dev:
	gh pr create -e \
		--base development \
		--template .github/PULL_REQUEST_TEMPLATE/development.md

# Create PR targeting release/prepare-YYYY-MM
pr-release:
	@if [ -z "$(DATE)" ]; then \
		echo "❌ ERROR: DATE is not set."; \
		echo "✅ Usage: make pr-release DATE=yyyy-mm"; \
		exit 1; \
	fi
	gh pr create -e \
		--base release/prepare-$(DATE) \
		--template .github/PULL_REQUEST_TEMPLATE/release.md

# Create PR targeting main branch
pr-main:
	gh pr create -e \
		--base main \
		--template .github/PULL_REQUEST_TEMPLATE/main.md

# List open release PRs targeting main
release-pr-check:
	gh pr list --base main --state open --search "chore: release"

# 🔁 Trigger bootstrap release pipeline via GitHub Actions
bootstrap-release:
	gh workflow run bootstrap-release.yaml
