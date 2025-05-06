# Root Makefile for utils-repl

.PHONY: all clean help include-makefiles

# Variables
IMAGE_NAME ?= utils-repl
REGISTRY_USERNAME ?= robertportelli
GIT_SHA := $(shell git rev-parse --short HEAD)

# Include modular makefiles
include .make/docker.mk
include .make/test.mk
#include .make/pr.mk
#include .make/branch.mk
include .make/dev.mk

# 📋 Display Makefile commands
help:
	@echo ""
	@echo "Available commands:"
	@echo "  clean                 Remove stopped containers"
	@echo "  feature               Create a new feature branch from development"
	@echo "  start-release         Create a release prep branch off main"
	@echo "  sync-dev              Merge main back into development"
	@echo "  update                Build and push latest Docker image"
	@echo "  repl                  Launch the REPL inside the dev container"
	@echo "  test, test-coverage   Run test suite (with optional coverage)"
	@echo "  test-ci               Run GitHub Actions workflow via act"
	@echo "  pc-all, pc-one        Run pre-commit on all or selected files"
	@echo "  super-linter          Run the Super Linter workflow via act"
	@echo "  tree                  Show project directory structure"
	@echo "  pr-dev, pr-release    Create PRs to development or release branches"
	@echo "  pr-main               Create PR to main"
	@echo "  release-pr-check      List open release-please PRs to main"
	@echo "  bootstrap-release     Run full release dry-run pipeline"
	@echo "  protect               Apply GitHub branch protection rules"
	@echo ""

# 🌳 Show project structure
tree:
	@tree -a --prune -I "*~|__pycache__|*.bak*|.git|*_cache"
