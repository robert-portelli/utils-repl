# dev.mk - dev-related workflow commands
.PHONY: pc-all pc-one super-linter repl

# 🚀 Development REPL
repl:
	docker compose run --rm dev

# 🛡️ Pre-commit Commands
pc-all:
	pre-commit run --all-files

pc-one:
	pre-commit run --files $(ARGS)

# 🧹 Super Linter Command
super-linter:
	gh act -W .github/workflows/super-linter.yaml -P ubuntu-latest=$(REGISTRY_USERNAME)/$(IMAGE_NAME)
