.PHONY: help run clean test

help:
	@echo "Available targets:"
	@echo "  run       - Run the agent with a prompt (usage: make run PROMPT='your prompt here')"
	@echo "  clean     - Clean up generated files"
	@echo "  test      - Run a quick test"

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
