# Root Makefile for utils-repl

.PHONY: all clean help include-makefiles

# Variables
IMAGE_NAME ?= utils-repl
REGISTRY_USERNAME ?= robertportelli
GIT_SHA := $(shell git rev-parse --short HEAD)

# Include modular makefiles
include .make/act.mk
include .make/docker.mk
include .make/test.mk
#include .make/pr.mk
#include .make/branch.mk
include .make/dev.mk

help: ## Show all available Make targets and their descriptions, grouped by source file
	@echo ""
	@echo "Available commands:"
	@for file in $(MAKEFILE_LIST); do \
		case $$file in \
			*.mk|Makefile) \
				if [ -f $$file ]; then \
					echo ""; \
					echo "$$file"; \
					grep -E '^[a-zA-Z0-9_.%/-]+:.*##' $$file | \
						awk -F':|##' '{ printf "  \033[1m%-20s\033[0m %s\n", $$1, $$3 }'; \
				fi ;; \
		esac; \
	done
	@echo ""


# 🌳 Show project structure
tree:
	@tree -a --prune -I "*~|__pycache__|*.bak*|.git|*_cache"
