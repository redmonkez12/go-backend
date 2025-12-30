ENV_FILE := .env
-include $(ENV_FILE)
ifneq ($(wildcard $(ENV_FILE)),)
export $(shell grep -v '^\s*#' $(ENV_FILE) | sed 's/=.*//')
endif

# Default database URL if not set in .env
DB_MIGRATOR_ADDR ?= postgres://postgres:postgres@localhost/go_backend?sslmode=disable

MIGRATIONS_PATH = ./cmd/migrate/migrations

.PHONY: migrate-create
migration:
	@migrate create -seq -ext sql -dir $(MIGRATIONS_PATH) $(filter-out $@,$(MAKECMDGOALS))

.PHONY: migrate-up
migrate-up:
	@migrate -path=$(MIGRATIONS_PATH) -database=$(DB_MIGRATOR_ADDR) up

.PHONY: migrate-down
migrate-down:
	@migrate -path=$(MIGRATIONS_PATH) -database=$(DB_MIGRATOR_ADDR) down $(filter-out $@,$(MAKECMDGOALS))

print-env:
	@echo "DB_MIGRATOR_ADDR=$(DB_MIGRATOR_ADDR)"