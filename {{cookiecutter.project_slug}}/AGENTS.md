# Coding agent instructions for `{{ cookiecutter.project_name }}`

_NOTE_: This file normally resides at `AGENTS.md` but should be symlinked at
`GEMINI.md` and `CLAUDE.md`. In other words, if you see a reference to
`AGENTS.md` in this file, it references this very file even if you see it under
a different name.

## The anatomy of a feature implementation

Implementing a new feature typically involves the following steps:

### 1. Fully understanding the feature

This includes _exploring the current state of the codebase_, _asking questions
to the user to clarify any doubts_, and _researching any relevant information_
(whether third-party libraries, roadmaps, old PRs, etc.) to fully grasp the
feature requirements and constraints. The goal of this step is to produce a
spec.

<!-- Expand here if needed with repository-specific information -->

### 2. Planning the implementation

This involves _deciding on the architecture and design patterns to use_,
_identifying any potential challenges or dependencies_, and _breaking down the
feature into smaller, manageable tasks_. The goal of this step is to produce a
clear implementation plan. Please check that the spec and the implementation
plan are aligned with each other.

In general, a task should be small enough that it can be implemented, tested,
documented, and committed in one go. It should also be small enough to be done
fully within one agent session. A good rule of thumb is something like 2 human
hours. It can be much smaller, however. In fact, if your feature demands
multiple small tasks that are very similar (e.g. adding multiple API routes), it
is a good idea to keep the first task small, and then use it as a template for
the other tasks. Another reason to keep tasks small is that it makes it easier
to review and test; if you run linting and type-checking commands on thousands
of lines of code, it will make the context window unmanageable.

If you have to add dependencies for a feature, try to make adding them a
separate task. This will make it easier to review and test.

<!-- Expand here if needed with repository-specific information -->

### 3. Executing the implementation

This is the actual coding part. Please follow the best practices and coding
standards specified in your context window; and don't hesitate to look at the
existing codebase for reference.

As you implement the feature, make sure to (1) write unit tests for each task,
(2) update `.gitignore` if needed, (3) update documentation (both inline and
external) as needed.

Note that the implementation should be made in a feature branch, not directly in
the base branch. Make sure to rebase the feature branch regularly to keep it up to
date with the base branch. (Rebase is the default strategy; but if specified
otherwise, follow the specified strategy.)

<!-- Expand here if needed with repository-specific information -->

### 4. Ensuring code quality before committing

There are three quality gates that MUST be passed before committing any code:

1. _Linting and type-checking_. First, run `make check-fix` to auto-fix any
   formatting issues. Then run `make check` to ensure that there are no linting
   or type-checking errors. For stricter checks, run `make check-strict-all`.
   All of the three commands MUST pass before committing any code, because CI/CD
   will run the same commands and will fail the build if any of them fail.
2. _Unit tests_. Run `make test` to ensure that all unit tests pass. If your
   feature requires internet access or latency (e.g. because it is a LLM call),
   also run `make test-all` to ensure that all integration tests pass. You
   should aim for 100% unit test coverage for the new code you write. Use
   `make test-with-coverage` to track unit test coverage without rerunning
   integration tests. `make test` HAS to pass before committing any code.
3. _Documentation_. If you create a new module, you MUST create a corresponding
   file in `docs/api/` AND update the `nav` section in `mkdocs.yml` to include
   it. Also, if you think documentation would be improved by adding things like
   tutorials, guides, etc, please propose them to the user. If you see that one
   of the existing guides or tutorials needs to be updated, please do so
   proactively and properly.Run `make doc` to ensure that the documentation
   builds correctly and that spell check passes. Add any new technical terms to
   `project-words.txt`. Please do NOT use `sort` on `project-words.txt`.
   `make doc` HAS to pass before committing any code.

<!-- Expand here if needed with repository-specific information -->

### 5. Committing and creating a PR

In general, we want git commits to be small and self-contained. As a rule of
thumb, there should be a rough 1:1 correspondence between tasks and git commits.
However, sometimes it makes sense to split a task into multiple commits. Use
your best judgment. The important thing is that each commit should be easy to
review and understand on its own. And ideally, the quality gates should pass
for each commit. Check `DEVELOP.md` for more details on how to write commits.

Unless specified otherwise, you should NOT commit directly without asking for
user review first.

Once commits are done and pushed, you should create a PR. The PR description should include the following sections:

- References to any relevant issues, tasks, or discussions, and ideally the spec
  and implementation plan.
- A clear and concise description of the changes made in the PR.
- Instructions on how to test the changes, if applicable.
- Checklist of the quality gates passed (linting, type-checking, unit tests,
  documentation).
- Any additional context or information that reviewers might find useful.

It is preferable to create PRs through the `gh` CLI tool using here-docs to avoid
issues with markdown formatting.

<!-- Expand here if needed with repository-specific information -->

### 6. Addressing PR feedback

Feedback about the PR can come from different places and should be addressed
in further commits to the same PR.

<!-- Expand here if needed with repository-specific information -->

### 7. Cleaning up after the feature is merged

Once the feature is merged, there might be some cleanup tasks to do, such as
removing any temporary code or branches, updating documentation, etc.

<!-- Expand here if needed with repository-specific information -->

Note that a conversation between you and me can happen at any time during this
process. It is your job, before doing anything, to figure out at which stage we
are, and potentially ask questions. (Figuring this out might be very easy if
you are, say, a sub-agent.)


## Good Python practices

- **Adding dependencies**:
  - Always add new dependencies using `uv add <package>`. This will ensure
    proper locking of the dependencies.
  - If you need to add a dev dependency, use `uv add --dev <package>`.
  - Corollary: never modify `pyproject.toml` or `uv.lock` directly as far as
    dependencies are concerned. Always use `uv` commands.
  - Only add dependencies that are strictly necessary. Yes, you might think that
    some packages will need to be added later. Well, wait until later then.
  - **Note**: Don't bother modifying `scratch/pyproject.toml` - it's not tracked
    by git and exists only for local experimentation.

- **Checking code**:
  - **Always run `make check-fix` first** before running `make check` or
    `make check-strict-all`. Many errors (formatting, import sorting, simple
    lint issues) will be auto-fixed, saving you time. Then run `make check` for
    all linting and type checks in parallel. All errors will be shown (the
    Makefile uses `-k` to keep going on failures). For stricter checks, use
    `make check-strict-all`.
  - One quirk of `make check-strict-all` is that it will run `ruff`'s preview
    rules. If you want to comment such rule out, you cannot do it in the file;
    it will be removed by `ruff format`. Instead, you should update the
    `ruff-strict.toml` file where these exceptions are documented. YOU SHOULD
    DOCUMENT THE RULE PER FILE, NOT FOR THE ENTIRE CODEBASE. And every exception
    should be documented with a comment explaining why the rule is not applied
    in that file.
  - If you're wondering if a rule is in preview: if it appears during
    `make check-strict-all`, but not during `make check`, then it is a preview
    rule. This means that you need to comment it out in `ruff-strict.toml` if
    you want to ignore it.
  - Be **really** weary before adding any `# type: ignore`, `# pyright: ignore`,
    or `# noqa` comments. These should be used only as last resort, when no
    better solution is available. Don't hesitate to ask questions to the user on
    whether further code changes are made to avoid these comments, or whether
    the ignore comments are acceptable.

- **Code practices**:
  - Check `pyproject.toml` to know what is the minimum Python version that is
    supported. Write constructs accordingly (e.g. no `Union` if Python 3.10+ is
    supported).
  - Try not to use `print` statements. Use your best judgment instead: if it's
    for logging, use `logging`. If it's for user-facing interaction, use the
    `rich` library (such as `print` or `Console`).
  - You can use `# type: ignore[error-code]` (`mypy`),
    `# pyright: ignore[ErrorCode]` (`pyright`), and `# noqa: <ERROR_CODE>`
    (`ruff`). If multiple go on the same line, they should go with `mypy` first.
    Use them only as last resort, when no better solution is available. (An
    example where this is warranted is if `Any` is really the only type that
    works, or if you need to use a third-party library that is not typed.) Some
    pointers on which errors to just comment out are specified below.
  - In general, do NOT put file-level ignore comments. Instead, try to address
    the issues on a line-by-line basis. Exceptions to this rule include:
    - Test files that inherently need to use `Any` types (e.g. because of
      mocking, JSON parsing, etc.)
    - Test files with regards to private module state access or docstring-
      related issues.
    - Errors or warnings that are really pervasive throughout the file, and
      addressing them individually would be too cumbersome. In this case,
      however, you MUST document why you're putting a file-level ignore.
  - IMPORTANT! Don't hesitate to over-document. Please ensure that when you
    modify a function, you also update the docstring. If you add a new
    parameter, please document it. Don't forget to put "args", "returns", and
    "raises" in the docstring. THIS IS ONE VERY COMMON LINTING MISTAKE! The
    exception here are helper functions that are private to a module and are
    self-explanatory.
  - Check `pyproject.toml` for the max line length. It's probably 80. Yes, the
    formatter will sometimes just reformat the code, but some lines (e.g.
    docstrings) will need to be modified accordingly.
  - The right way to pass a message to an exception is to define a `msg`
    variable, and then pass it to the exception.
  - Put `@final` whenever needed. Helps for type-checking.
  - Put `@override` whenever needed (and it's generally more often than you
    think). Helps for type-checking.
  - Any time you define an empty list, try to type-hint it (e.g.
    `my_list: list[str] = []`).
  - Be mindful of class methods that don't use the `self` parameter. If you
    don't use it, you should make it static.
  - If you use `cast(...)`, make sure that the name of the new type is put
    within double quotes (e.g., `cast("MyType", obj)`).

  - **Documentation practices**:
    - **Blank line before lists**: In markdown and docstrings, always insert a
      blank line between a paragraph and a list. Without it, the list may not
      render correctly. (This doesn't apply to `Raises:` or `Args:` sections in
      docstrings, where the list is part of the same section.)

      ```markdown
      <!-- Correct -->

      List header:

      - first element
      - second element

      <!-- Incorrect - no blank line -->

      List header:

      - first element
      - second element
      ```

    - **Two newlines between paragraphs**: Separate paragraphs with two newlines
      (i.e., a blank line). A single newline will render as one continuous
      paragraph.
    - Whenever possible, any references to a file or library (or really any
      piece of code) should be surrounded with backticks. Don't say ("we detect
      uv.lock", say "we detect `uv.lock`").
    - **Cross-references**: Use the format "[`function`][module.function]" to
      create clickable links in the generated documentation. Example:
      `Uses [`lru_cache`][functools.lru_cache] to ensure...`. This works for the
      standard library, our own library, and external libraries (thanks to
      mkdocs/griffe).
      - Yes, this means using _both_ backticks and square brackets. This is so
        that the generated documentation shows the function name in a code font
        while linking to the right place.
      - Available inventories are configured in `mkdocs.yml` under
        `inventories`. Add new ones as needed (e.g.,
        `https://example.com/objects.inv`). Only use cross-references if either
        (1) the function or object is part of the standard library, (2) the
        function or object is part of the current library, or (3) is part of an
        external library but the inventory is in the `inventories` section of
        `mkdocs.yml` or another plugin takes care of it (like a
        `griffe-pydantic` plugin for Pydantic objects.)
      - If you reference something that is not in an inventory, you can still
        use backticks, but don't use the square brackets.
      - **Exception**: You don't need cross-references in `Args:`, `Returns:`,
        or `Raises:` sections of docstrings - griffe handles those
        automatically.
    - **Don't state the obvious**: If a class explicitly subclasses something
      (e.g., `class A(B, C):`), don't write "Inherits from B and C" in the
      docstring - the auto-generated documentation already shows this.
    - **Docstring formatting (Google style)**:
      - In `Returns:` sections, continuation lines must be indented to show they
        belong to the same return description. For example:

        ```python
        Returns:
            The URL with async driver if it was a postgres URL,
                otherwise the original value unchanged.
        ```

    - **Before committing**, run `make doc` to verify spell check passes and
      docs build correctly. Add any new technical terms to `project-words.txt`.

  - **Docstring nitpicks**:
    - Make sure there is an exact 1:1 correspondence between the errors
      EXPLICITLY raised in the body of the function and the errors listed in the
      `Raises:` section of the docstring. If an error is raised but not
      documented, or documented but not raised, fix the docstring or the code
      accordingly.
    - Always strive to include a `Returns:` section in docstrings of functions
      that return a value. (Don't bother for abstract methods or functions that
      only return `None`, or for "stub functions": functions where the body only
      consists of `pass`, `...`, `raise NotImplementedError`, or similar)

- **Handling linting and type-checking errors** (these are misc notes):
  - In general, if we're dealing with operations that inherently deal with `Any`
    or `Unknown` (e.g. because you're parsing JSON, because you're dealing with
    a third-party library that is not typed, etc.), you can safely put ignore
    comments for: `reportUnknownArgumentType`, `reportUnknownMemberType`,
    `reportUnknownVariableType`, `reportUnknownParameterType`,
    `reportUnknownType`, `reportAny`, `reportExplicitAny`, etc. (`pyright`), and
    `ANN401` (`ruff`).
  - In some cases, you can put `object` as the type, but this is not
    recommended. If you do so, please document why you did it.
  - **Test files and pyright strict mode**: Test files often need file-level
    pyright configuration when they use mocks and JSON responses that inherently
    involve `Any` types. Add at the top of the file:
    <!-- markdownlint-disable MD031 -->

    ```python
    # pyright: reportAny=false, reportExplicitAny=false
    ```

    Add `reportPrivateUsage=false` if tests need to access private module state,
    and `reportUnknownArgumentType=false` for JSON parsing.

  - **Pyright ignore placement**: The `# pyright: ignore[rule]` comment MUST be
    on the exact line with the error. Putting it on an adjacent line won't work.
  - **Comment wording pitfall**: Any comment starting with `# pyright:` is
    parsed as a directive. If explaining why a pyright ignore is needed, start
    with `# Pyright ignore needed...` (capital P) or rephrase to avoid the
    prefix.
  - **Unused parameters**: Use `_paramname` prefix (e.g., `_request`) for
    intentionally unused parameters. This satisfies both ruff's `ARG001` and
    pyright's `reportUnusedParameter` without needing ignore comments.
  - **Unused call results**: For `reportUnusedCallResult` errors, assign the
    result to `_`, e.g., `_ = await db.execute(...)`.
  - If you get an error saying that there are too many arguments in a method
    signature, you should consider the following options, in order of
    preference:
    1. Refactor the code to reduce the number of parameters (e.g., group related
       parameters into a dataclass or dictionary). But if this is not feasible,
       or clearly idiotic, or decreases code readability, then...
    2. Use a noqa comment.
    3. Really avoid using solutions relying on `kwargs` or `args` unless
       absolutely necessary. We like type-checking!
  - Don't hesitate to fix the `unusedCallResult` errors by assigning the result
    to `_` if the result is not needed. This is easy to write and is better than
    an ignore comment. **NOTE**: If you import i18n in the file, `_` might be
    shadowed. In this case, you can use something like `_unused` or `__`
    instead.
