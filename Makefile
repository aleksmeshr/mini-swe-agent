.PHONY: help run clean test fix-test-bug

PROJECT ?= JacksonCore
BUG_NUMBER ?= 3
CONTAINER_NAME=agent-defects4j-$(shell echo $(PROJECT) | tr '[:upper:]' '[:lower:]')-$(BUG_NUMBER)

help:
	@echo "Available targets:"
	@echo "  run       - Run the agent with a prompt (usage: make run PROMPT='your prompt here')"
	@echo "  clean     - Clean up generated files"
	@echo "  test      - Run a quick test"
	@echo "  fix-test-bug   - Build Docker container for Defects4J bug (usage: make fix-test-bug PROJECT=JacksonCore BUG_NUMBER=3)"

run:
	@if [ -z "$(PROMPT)" ]; then \
		echo "Error: PROMPT is required"; \
		echo "Usage: make run PROMPT='your task description'"; \
		exit 1; \
	fi
	uv run --env-file .env src/minisweagent/__main__.py -t "$(PROMPT)"

clean:
	rm -rf .venv
	rm -rf src/*.egg-info
	rm -rf build/
	rm -rf dist/
	@echo "Cleanup complete"

test:
	@echo "Running quick test..."
	rm hello.py > /dev/null 2>&1 || true
	uv run --env-file .env src/minisweagent/__main__.py -t "Make a python script hello.py that prints 'Hello, World!'"
	@test -f hello.py && echo "Test successful" || (echo "Test failed: hello.py does not exist"; exit 1)
	rm hello.py

fix-test-bug:
	@echo "Building Docker container for $(PROJECT) bug $(BUG_NUMBER)..."
	docker build -f tests/defects4j/Dockerfile \
		--build-arg DEFECTS4J_PROJECT=$(PROJECT) \
		--build-arg DEFECTS4J_BUG_NUMBER=$(BUG_NUMBER) \
		--build-arg TASK_FILE=tests/defects4j/$(PROJECT)-$(BUG_NUMBER).md \
		-t $(CONTAINER_NAME) .
	@echo "Container built successfully!"
	docker run -it --env-file .env $(CONTAINER_NAME) run-agent
