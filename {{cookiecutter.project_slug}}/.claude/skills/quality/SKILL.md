---
name: quality
description:
  Run all quality gates and report detailed status. Use as final verification
  after parallel sub-agents, or as all-in-one check.
---

# All Quality Gates

## When to Use

- **After parallel sub-agents**: Run this to verify nothing was missed due to
  concurrent edits
- **As all-in-one check**: If not using parallel sub-agents, this runs
  everything

## Procedure

1. Run all quality gate commands sequentially:

   ```bash
   make check-fix
   make check
   make check-strict-all
   make test-with-coverage
   make doc
   ```

2. If any fail, fix the issues and re-run from step 1

3. Report detailed status summary:

   ```text
   ## Quality Gates Summary

   ### Linting & Type-Checking
   - `make check`: PASS/FAIL
   - `make check-strict-all`: PASS/FAIL
   - Errors fixed: <count> (list briefly if any)
   - Remaining warnings: <count or "none">

   ### Tests
   - `make test-with-coverage`: PASS/FAIL
   - Tests: <passed>/<total>
   - Coverage (overall): <X>%
   - Coverage (new code): <X>% [list uncovered files/lines if < 100%]
   - Integration tests (`make test-all`): PASS/FAIL/SKIPPED

   ### Documentation
   - `make doc`: PASS/FAIL
   - New terms added to project-words.txt: <list or "none">
   - New modules documented: <list or "none">

   ### Overall: PASS/FAIL

   ### Lessons Learned
   <Patterns discovered while fixing issues that should be documented>
   <If none, write "None">
   ```

## Lessons Learned

**Always include a "Lessons Learned" section**, even if empty. This is critical
when running as a sub-agent — the main agent needs this information for the PR
description.

Examples of lessons learned:
- "Discovered that `mypy` requires explicit type annotations for class variables"
- "The spell-checker doesn't recognize 'webhook' — added to project-words.txt"
- "Tests using `freezegun` must import it before the module under test"

If you fixed issues, ask: "Would knowing this earlier have helped?" Note it in
the lessons learned output. The main agent will include it in the PR description
under "Lessons Learned", and the human maintainer will decide whether to update
`AGENTS.md` or `dev/*.md`.

## Exit Conditions

- **Success**: All gates pass
- **Failure**: Report which gates failed with specific errors/uncovered lines
