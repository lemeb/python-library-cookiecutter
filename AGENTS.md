# Coding Agent Instructions for python-library-cookiecutter

This is a cookiecutter template for Python libraries. The generated project
lives in `{{cookiecutter.project_slug}}/`.

## Quick Reference

| Action | Command |
|--------|---------|
| Lint Python (template) | See "Linting" section below |
| Test template generation | `cookiecutter . --no-input` |

## Linting

The generated project uses **80 character line length**. When editing Python
files in `{{cookiecutter.project_slug}}/`, always verify with:

```bash
uvx ruff check --isolated --line-length 80 \
  --select=E,F,W,I,N,UP,B,A,C4,T10,SIM,ARG,PTH,PL,RUF,S,TRY,FBT,C90,E501 \
  "{{cookiecutter.project_slug}}/.claude/scripts/go_on_loop.py"
```

For type checking:

```bash
uvx mypy --ignore-missing-imports \
  "{{cookiecutter.project_slug}}/.claude/scripts/go_on_loop.py"
```

**Note**: The `pyproject.toml` in the template contains Jinja2 syntax, so
ruff/mypy cannot parse it directly. Use `--isolated` to skip config loading.

## Directory Structure

```
.
├── cookiecutter.json          # Template variables
├── hooks/                     # Pre/post generation hooks
└── {{cookiecutter.project_slug}}/  # Generated project template
    ├── .claude/               # Claude Code configuration
    │   └── scripts/           # Automation scripts (Python)
    ├── dev/                   # Developer documentation
    │   ├── tracker/           # Issue tracker integrations
    │   └── workflow/          # Workflow step files
    └── ...
```

## Before Committing

1. Run linting (see above)
2. Run type checking (see above)
3. Test template generation if you changed `cookiecutter.json` or hooks
