---
name: quality
description: Run all quality gates (linting, type-checking, tests, documentation). Use before committing to ensure code is ready.
---

# All Quality Gates

## Procedure

1. Run `/check`, `/test`, `/doc` (can be parallel if supported)

2. After all complete, re-run all commands to verify nothing was missed due to concurrent edits:
   ```
   make check-fix && make check && make check-strict-all
   make test-with-coverage
   make doc
   ```

3. Report detailed status summary:

   ```
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
   ```

## Why Re-run?

Parallel execution can cause concurrent edits. The final sequential run ensures all gates pass on the final state.

## Exit Conditions

- **Success**: All gates pass in final verification
- **Failure**: Report which gates failed with specific errors/uncovered lines
