# .make/act.mk — Run smoke tests with act

.PHONY: smoke-all smoke-% smoke-list

# Load persisted ACTOR variable if available
-include .env
export ACTOR

# Require ACTOR or exit
ifndef ACTOR
$(error ❌ ACTOR is not set. Please set it via `export ACTOR=your-github-username` or pass it inline: `ACTOR=your-github-username make <target>`)
endif

# Base act command
ACT_BASE := gh act workflow_dispatch \
  --secret-file .secrets \
  --container-architecture linux/amd64 \
  --reuse \
  --rm \
  --actor $(ACTOR)

# Dynamically collect all smoke test workflows, skip *.save files
SMOKE_TESTS := $(filter-out %.save,$(patsubst .github/workflows/%.yaml,%,$(wildcard .github/workflows/smoke*.yaml)))

smoke-list: ## List available smoke test targets
	@echo "🧪 Available smoke tests:"
	@for wf in $(SMOKE_TESTS); do echo "  - $$wf"; done

smoke-all: ## Run all smoke tests
	@for wf in $(SMOKE_TESTS); do \
		echo "🚀 Running $$wf"; \
		$(ACT_BASE) -W .github/workflows/$$wf.yaml $(ARGS); \
	done

run-smoke: ## Interactively select a smoke test to run
	@options=$$(find .github/workflows -maxdepth 1 -type f -name 'smoke*.yaml' | sed 's|.*/||; s|\.yaml$$||'); \
	IFS=" " read -r -a arr <<< "$$options"; \
	echo "Select a smoke test to run:"; \
	select opt in $$options; do \
		if [ -n "$$opt" ]; then \
			echo "🚀 Running smoke test: $$opt"; \
			$(ACT_BASE) -W .github/workflows/$$opt.yaml $(ARGS); \
			break; \
		else \
			echo "❌ Invalid selection"; \
		fi; \
	done
