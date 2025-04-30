.PHONY: clean feature help pc-all pc-one protect repl start-release super-linter sync-dev tag test test-ci test-coverage tree update pr-dev pr-release pr-main

# Variables
IMAGE_NAME ?= utils-repl
REGISTRY_USERNAME ?= robertportelli
GIT_SHA := $(shell git rev-parse --short HEAD)

# 📋 Display Makefile commands
help:
	@echo ""
	@echo "Available commands:"
	@echo "  clean              Remove stopped containers"
	@echo "  feature            Create feature branch from development (FEATURE=...)"
	@echo "  help               Show this help message"
	@echo "  pc-all             Run pre-commit on all files"
	@echo "  pc-one             Run pre-commit on selected files (ARGS=\"...\")"
	@echo "  protect            Apply GitHub branch protection rules"
	@echo "  repl               Launch a REPL session inside the development container"
	@echo "  start-release      Create release branch from main (DATE=yyyy-mm)"
	@echo "  super-linter       Run the Super Linter GitHub Actions workflow locally with act"
	@echo "  sync-dev           Merge main back into development after release"
	@echo "  tag                Tag the current commit and push to origin (VERSION=x.y.z)"
	@echo "  test               Run the test suite (ARGS=\"...\" optional)"
	@echo "  test-ci            Run GitHub Actions workflow locally with act (ARGS=\"...\" optional)"
	@echo "  test-coverage      Run the test suite with coverage report (ARGS=\"...\" optional)"
	@echo "  tree               Show project structure with tree command"
	@echo "  update             Build, tag, and push the Docker image to remote registry"
	@echo "  pr-dev             Create a feature/fix PR to development"
	@echo "  pr-release         Create a release PR to release/prepare-<date> (pass DATE=yyyy-mm)"
	@echo "  pr-main            Create a final release PR to main"

	@echo ""


# 🌳 Show project structure
tree:
	@tree -a --prune -I "*~|__pycache__|*.bak*|.git|*_cache"

# 📦 Docker Image Commands
update:
	docker compose down --remove-orphans
	docker build --load -t $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest .
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest

# 🚀 Development Commands
repl:
	docker compose run --rm --profile dev dev

# 🧪 Test Commands
test:
	docker compose run --rm --profile test test poetry run pytest $(ARGS)

test-coverage:
	docker compose run --rm --profile test test poetry run pytest --cov=src --cov-report=term-missing $(ARGS)

test-ci:
	gh act -W $(ARGS) -P ubuntu-latest=$(REGISTRY_USERNAME)/$(IMAGE_NAME)

# 🛡️ Pre-commit Commands
pc-all:
	pre-commit run --all-files

pc-one:
	pre-commit run --files $(ARGS)

# 🧹 Super Linter Command
super-linter:
	gh act -W .github/workflows/super-linter.yaml -P ubuntu-latest=$(REGISTRY_USERNAME)/$(IMAGE_NAME)

# 🧹 Cleanup
clean:
	docker compose rm -fs

# 📋 Branch Automation Commands

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

# Tag the current HEAD with a version
# Usage: make tag VERSION=x.y.z
tag:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ ERROR: VERSION is not set."; \
		echo "✅ Usage: make tag VERSION=x.y.z"; \
		exit 1; \
	fi
	git tag v$(VERSION)
	git push origin v$(VERSION)

# Merge main back into development after a release
# Usage: make sync-dev
sync-dev:
	git checkout development
	git pull origin development
	git merge main
	git push origin development

# Apply branch protections using the setup script
# Usage: make protect
protect:
	bash scripts/setup-branch-protections.sh

# 📋 GitHub PR Commands (using templates and editor mode)

# Create PR targeting development branch
# Usage: make pr-dev
pr-dev:
	gh pr create -e \
		--base development \
		--template .github/PULL_REQUEST_TEMPLATE/development.md

# Create PR targeting release/prepare-YYYY-MM
# Usage: make pr-release DATE=2024-05
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
# Usage: make pr-main
pr-main:
	gh pr create -e \
		--base main \
		--template .github/PULL_REQUEST_TEMPLATE/main.md
