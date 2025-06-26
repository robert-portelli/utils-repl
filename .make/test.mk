# .make/test.mk — Test suite orchestration

.PHONY: test test-coverage test-ci

test: ## Run the full pytest test suite inside the container
	docker compose run --rm test poetry run pytest $(ARGS)

test-coverage: ## Run pytest with coverage report (shows uncovered lines)
	docker compose run --rm test poetry run pytest --cov=src --cov-report=term-missing $(ARGS)
