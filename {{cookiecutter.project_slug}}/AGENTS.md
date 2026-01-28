# Coding Agent Instructions for {{ cookiecutter.project_name }}

_NOTE_: This file normally resides at `AGENTS.md` but should be symlinked at
`GEMINI.md` and `CLAUDE.md`. If you see a reference to `AGENTS.md` in this file,
it references this very file even if you see it under a different name.

<!-- You can fill in repository-specific information in tags like this.
     This includes information such as issue tracker details, team conventions,
     or anything else that is relevant to your context.
     Do NOT remove these tags because they will make updating from the template
     much much harder. -->

---

## Quick Reference

| Action | Command |
|--------|---------|
| Auto-fix formatting | `make check-fix` |
| Lint + type-check | `make check` |
| Strict checks | `make check-strict-all` |
| Run tests | `make test` |
| Tests + coverage | `make test-with-coverage` |
| Build docs | `make doc` |
| Add dependency | `uv add <package>` |
| Add dev dependency | `uv add --dev <package>` |

**Before committing**, both `make check` and `make check-strict-all` must pass,
along with `make test` and `make doc`.

---

## Where to Find Information

| Topic | File |
|-------|------|
| Commands, tooling, commit format | `DEVELOP.md` |
| Linting, type-checking, fixing errors | `dev/checking.md` |
| Testing practices, coverage | `dev/testing.md` |
| Documentation, docstrings | `dev/documentation.md` |
| Python coding practices, dependencies | `dev/python.md` |
| Project structure, usage | `README.md` |
| Python version, line length, deps | `pyproject.toml` |

**For implementation tasks**: Load `dev/checking.md`, `dev/testing.md`,
`dev/documentation.md`, and `dev/python.md` before writing code.

---

## Determining Request Type

Before starting, classify the request:

| Type | Examples | Action |
|------|----------|--------|
| **Exploration** | "How does X work?", "Where is Y?", "Explain this" | Answer directly |
| **Quick fix** | "Fix this typo", "Rename this variable" | Fix, run quality gates, commit |
| **Implementation** | "Add feature X", "Implement Y", "Build Z" | Follow workflow below |
| **Ambiguous** | "Help me with X", "I need to do Y" | **Ask which type** |

---

## The Anatomy of a Feature Implementation

Implementing a new feature typically involves the following steps. Note that a
conversation between you and the user can happen at any time during this
process. It is your job, before doing anything, to figure out at which stage you
are, and potentially ask questions. (Figuring this out might be very easy if you
are, say, a sub-agent.)

### 1. Fully understanding the feature

This includes _exploring the current state of the codebase_, _asking questions
to the user to clarify any doubts_, and _researching any relevant information_
(whether third-party libraries, roadmaps, old PRs, etc.) to fully grasp the
feature requirements and constraints. The goal of this step is to produce a
spec.

<!-- Expand here with repo-specific information. For example:
     - Where should specs be recorded? (Linear issue, GitHub issue, etc.)
     - Are there specific templates or formats for specs?
     Do NOT remove this comment. -->

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

<!-- Expand here with repo-specific information. For example:
     - Where should plans/tasks be tracked?
     - Are there specific formats for implementation plans?
     Do NOT remove this comment. -->

### 3. Executing the implementation

This is the actual coding part. Please follow the best practices and coding
standards specified in your context window; and don't hesitate to look at the
existing codebase for reference. Load `dev/checking.md`, `dev/testing.md`,
`dev/documentation.md`, and `dev/python.md` before writing code.

As you implement the feature, make sure to (1) write unit tests for each task,
(2) update `.gitignore` if needed, (3) update documentation (both inline and
external) as needed.

Note that the implementation should be made in a feature branch, not directly in
the base branch. Make sure to rebase the feature branch regularly to keep it up
to date with the base branch. (Rebase is the default strategy; but if specified
otherwise, follow the specified strategy.)

<!-- Expand here with repo-specific information. For example:
     - Branch naming conventions?
     - Any specific patterns or conventions to follow?
     Do NOT remove this comment. -->

### 4. Ensuring code quality before committing

There are three quality gates that MUST be passed before committing any code:

1. _Linting and type-checking_. First, run `make check-fix` to auto-fix any
   formatting issues. Then run `make check` to ensure that there are no linting
   or type-checking errors. For stricter checks, run `make check-strict-all`.
   Both `make check` and `make check-strict-all` MUST pass before committing any
   code, because CI/CD will run the same commands and will fail the build if any
   of them fail.
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
   proactively and properly. Run `make doc` to ensure that the documentation
   builds correctly and that spell check passes. Add any new technical terms to
   `project-words.txt`. Please do NOT use `sort` on `project-words.txt`.
   `make doc` HAS to pass before committing any code.

<!-- Expand here with repo-specific information. For example:
     - Additional quality gates?
     - Specific coverage requirements?
     Do NOT remove this comment. -->

### 5. Committing and creating a PR

In general, we want git commits to be small and self-contained. As a rule of
thumb, there should be a rough 1:1 correspondence between tasks and git commits.
However, sometimes it makes sense to split a task into multiple commits. Use
your best judgment. The important thing is that each commit should be easy to
review and understand on its own. And ideally, the quality gates should pass for
each commit. Check `DEVELOP.md` for more details on how to write commits.

Unless specified otherwise, you should NOT commit directly without asking for
user review first.

Once commits are done and pushed, you should create a PR. The PR description
should include the following sections:

- References to any relevant issues, tasks, or discussions, and ideally the spec
  and implementation plan.
- A clear and concise description of the changes made in the PR.
- Instructions on how to test the changes, if applicable.
- Checklist of the quality gates passed (linting, type-checking, unit tests,
  documentation).
- Any additional context or information that reviewers might find useful.

It is preferable to create PRs through the `gh` CLI tool using here-docs to
avoid issues with markdown formatting.

<!-- Expand here with repo-specific information. For example:
     - PR template requirements?
     - Issue linking format?
     - Required reviewers?
     Do NOT remove this comment. -->

### 6. Addressing PR feedback

Feedback about the PR can come from different places and should be addressed in
further commits to the same PR.

<!-- Expand here with repo-specific information. For example:
     - How to handle feedback from different sources?
     - Any specific conventions for addressing feedback?
     Do NOT remove this comment. -->

### 7. Cleaning up after the feature is merged

Once the feature is merged, there might be some cleanup tasks to do, such as
removing any temporary code or branches, updating documentation, etc.

<!-- Expand here with repo-specific information. For example:
     - Post-merge cleanup checklist?
     - Any notifications or updates to make?
     Do NOT remove this comment. -->

---

## Checkpoints

| Before... | Verify... |
|-----------|-----------|
| `git commit` | `make check`, `make check-strict-all`, `make test`, `make doc` all pass |
| `git push` | All quality gates pass, branch rebased on base branch |
| `gh pr create` | PR description complete with all sections |

---

## Recording Lessons Learned

After fixing errors, if you discover something that would have helped you avoid
the problem, note it in the PR description under a "Lessons Learned" section.
Maintainers will periodically incorporate useful lessons into the `dev/*.md`
files.
