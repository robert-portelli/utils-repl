# .make/test.mk

# Testing-related commands

.PHONY: test test-coverage test-ci
# 🧪 Test Commands
test:
	docker compose run --rm test poetry run pytest $(ARGS)

test-coverage:
	docker compose run --rm test poetry run pytest --cov=src --cov-report=term-missing $(ARGS)

test-ci:
	gh act -W $(ARGS) -P ubuntu-latest=$(REGISTRY_USERNAME)/$(IMAGE_NAME)
