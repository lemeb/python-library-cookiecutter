<div align="center">
    <!-- You can add an image here -->
    <h1 align="center">{{cookiecutter.project_name}}</h1>
</div>

<p align="center">
    {{cookiecutter.project_short_description}}
</p>

## Stack

* **[Pytest](https://docs.pytest.org/en/stable/)** for testing. The tests live in the `tests/` directory.
* **[Uv](https://docs.astral.sh/uv/)** for managing dependencies and building the package.
* **[Ruff](https://beta.ruff.rs/)** for linting.
* **[Pre-commit](https://pre-commit.com/)** for running linting and formatting before committing.
* **[GitHub Actions](https://docs.github.com/en/actions)** for CI/CD.

## Developer

* The version is declared in the `pyproject.toml` file. Don't forget to update it when you make a new release!