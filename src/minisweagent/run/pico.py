import os
from pathlib import Path

import typer
import yaml

from minisweagent import package_dir
from minisweagent.agents.default import DefaultAgent
from minisweagent.environments.local import LocalEnvironment
from minisweagent.models.anthropic import AnthropicModel

app = typer.Typer()

@app.command()
def main(
    task: str = typer.Option(None, "-t", "--task", help="Task/problem statement", show_default=False, prompt=False),
    file: Path = typer.Option(None, "-f", "--file", help="Read task from file"),
    model_name: str = os.getenv("MSWEA_MODEL_NAME"),
) -> DefaultAgent:
    task_text = task if task is not None else file.read_text()
    if not task_text.strip():
        raise typer.Exit("Error: No task provided. Use -t/--task or -f/--file.")

    print(f"Task: {task_text}")

    agent = DefaultAgent(
        AnthropicModel(model_name=model_name),
        LocalEnvironment(),
        **yaml.safe_load(Path(package_dir / "config" / "default.yaml").read_text())["agent"],
    )
    agent.run(task_text)
    return agent


if __name__ == "__main__":
    app()
