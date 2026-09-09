from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent

SYSTEM_ROOT = PROJECT_ROOT / ".basalcell"

# poetry
PYPROJECT_TOML = PROJECT_ROOT / "pyproject.toml"
POETRY_REQUIREMENTS_TXT = SYSTEM_ROOT / "requirements.txt"

# mamba
ENVIRONMENT_YML = PROJECT_ROOT / "environment.yml"
CONDA_LOCK_YML = SYSTEM_ROOT / "conda-lock.yml"

# renv
RENV_LOCK = PROJECT_ROOT / "renv.lock"
