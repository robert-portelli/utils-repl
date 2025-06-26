# .make/dev.mk — Development utilities

.PHONY: pc-all pc-one super-linter repl

repl: ## Launch the REPL inside the dev container
	@echo "🧪 Entering REPL..."
	docker compose run --rm dev poetry run python

pc-all: ## Run pre-commit on all files
	pre-commit run --all-files

pc-one: ## Run pre-commit on selected files via ARGS
	pre-commit run --files $(ARGS)

super-linter: ## Run the Super Linter workflow locally using act
	gh act -W .github/workflows/super-linter.yaml -P ubuntu-latest=$(REGISTRY_USERNAME)/$(IMAGE_NAME)
