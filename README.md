<div align="center">
    <img alt="Python Cookiecutter template." src="logo.png" height="150">
    <h1 align="center">Python Cookiecutter template</h1>
</div>

<p align="center">
    An opinionated cookiecutter template for Python libraries.
</p>

## Usage

### Option 1: Using `cruft` (Recommended)

We recommend using [Cruft](https://cruft.github.io/cruft/) to generate your
project. Cruft is like
[Cookiecutter](https://cookiecutter.readthedocs.io/en/stable/), but it allows
you to keep your project up to date with the latest changes in the template.

To create a new project, run the following command:

```bash
# Change 'lemeb' to your GitHub username if you've forked the repository.
cruft create https://github.com/lemeb/python-library-cookiecutter.git
```

Every now and then, you can run the following command to update your project to
the latest version of the template:

```bash
cruft update
```

This command will also run on GitHub Actions every day at 2am UTC to update your
project to the latest version of the template.

### Option 2: Using `cookiecutter`

If you don't want to use Cruft, you can use `cookiecutter` to generate your
project.

```bash
cookiecutter https://github.com/lemeb/python-library-cookiecutter.git
```

## Repository structure

Once generated, your repository will look like this:

```
.
├── .github/
│   └── workflows/
│       └── cruft-update.yaml # GH workflow to update to latest template version
├── docs/                   # Documentation
│   ├── api/                # API documentation
│   └── index.md            # Homepage
├── scratch/                # Scratchpad directory (ignored by git)
├── src/
│   └── {{project_slug}}    # Where your code will live
│       ├── ...
│       ├── __init__.py
│       └── {{project_slug}}.py
├── tests/                  # Tests
├── LICENSE
├── pyproject.toml
└── README.md
```
