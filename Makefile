export PIPENV_VENV_IN_PROJECT=true
export PYTHONPATH=src
export MYPYPATH=src

all: help

.PHONY: help
help:
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sed -e "s/| \(.*\)$$/| $$(printf "\033")[37m\1$$(printf "\033")[0m/g"
	@printf '\nAvailable variables:\n'
	@grep -E '^[a-zA-Z_-]+\?=.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "?="}; {printf "\033[36m%-20s\033[0m default: %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the project
	pipenv sync --bare

.PHONY: fmt
fmt: ## Format
	pipenv run -- black src
	pipenv run -- isort --profile black src

.PHONY: setup
setup:
	pipenv sync --dev --bare

.PHONY: sh
sh: ## Open a pipenv shell
	pipenv shell

.PHONY: test
test: setup ## Test the project | make test path=spec/spec_lifen.py
	pipenv run -- black --check src
	pipenv run -- isort --profile black --check-only src
	pipenv run -- flake8 --append-config .flake8.conf src
