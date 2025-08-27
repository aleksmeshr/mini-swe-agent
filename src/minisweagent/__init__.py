"""
This file provides:

- Path settings for global config file & relative directories
- Version numbering
- Protocols for the core components of mini-swe-agent.
  By the magic of protocols & duck typing, you can pretty much ignore them,
  unless you want the static type checking.
"""

__version__ = "1.9.1"

import os
from pathlib import Path
from typing import Any, Protocol

import dotenv
from platformdirs import user_config_dir
from rich.console import Console

from minisweagent.utils.log import logger

package_dir = Path(__file__).resolve().parent

dotenv.load_dotenv(dotenv_path=".env")

class Model(Protocol):
    """Protocol for language models."""

    config: Any
    cost: float
    n_calls: int

    def query(self, messages: list[dict[str, str]], **kwargs) -> dict: ...

    def get_template_vars(self) -> dict[str, Any]: ...


class Environment(Protocol):
    """Protocol for execution environments."""

    config: Any

    def execute(self, command: str, cwd: str = "") -> dict[str, str]: ...

    def get_template_vars(self) -> dict[str, Any]: ...


class Agent(Protocol):
    """Protocol for agents."""

    model: Model
    env: Environment
    messages: list[dict[str, str]]
    config: Any

    def run(self, task: str, **kwargs) -> tuple[str, str]: ...


__all__ = [
    "Agent",
    "Model",
    "Environment",
    "package_dir",
    "__version__",
    "global_config_file",
    "global_config_dir",
    "logger",
]
