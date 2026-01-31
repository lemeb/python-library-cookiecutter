# Step 3: Implementing a Task

**Goal**: Implement ONE task completely (code + tests + quality + commit).

This step repeats for each task in your plan. Each invocation handles exactly
one task.

## Prerequisites

- [ ] Implementation plan exists and is approved (Step 2 complete)
- [ ] Tasks are tracked per the active tracker's conventions
- [ ] You are on a feature branch (not main/master/base branch)
- [ ] Previous task (if any) is committed

**If the plan or tasks are not recorded** in the tracker yet (e.g., Plan Mode
cleared context), record them now before proceeding.

If not on a feature branch, create one first.

## Procedure

### 3a. Pick the next task

1. **Identify the next incomplete task** from your plan/tracker
2. **Verify it's unblocked** (dependencies completed)
3. **Mark it as in-progress** per tracker conventions

### 3b. Implement

1. **Load coding guidance** before writing code:
   - `dev/checking.md` — linting & type-checking
   - `dev/testing.md` — testing practices
   - `dev/documentation.md` — docstrings & docs
   - `dev/python.md` — coding style

2. **Write the code** for this task only
   - Follow existing patterns in the codebase
   - Keep changes focused on this task

3. **Write tests** for the code you just wrote
   - Aim for 100% coverage on new code
   - Include edge cases from the spec

4. **Update documentation** if needed
   - Docstrings for new public APIs
   - Update docs/ if user-facing
   - Add terms to `project-words.txt`

### 3c. Quality gate

Run `/quality` (or manually: `make check-fix && make check && make check-strict-all && make test-with-coverage && make doc`)

- **If passing**: Proceed to commit
- **If failing**: Fix issues and re-run until passing

### 3d. Commit

1. **Stage the changes** for this task
2. **Write a commit message** following the project's conventions:
   - Check `DEVELOP.md` for commit message format
   - Look at recent commits (`git log -5`) for style reference
3. **Commit** (unless user asked to review first)
4. **Mark task complete** per tracker conventions

## Claude-specific Notes (ignore if Codex or Gemini)

**Task tracking**: Use `TaskCreate`/`TaskUpdate` to track progress through
tasks within a session:
- Create tasks with clear subjects and descriptions
- Use `addBlockedBy` to represent the DAG of dependencies from your plan
- Mark tasks `in_progress` when starting, `completed` when done
- This provides visibility and allows hand-off if the session ends

**Parallel execution**: If multiple tasks are independent (no dependencies
between them), you can spawn sub-agents to work on them in parallel:
- Keep it reasonable (2-3 parallel tasks max)
- Each sub-agent handles a complete task including tests and quality
- Tell sub-agents: "Running in headless mode" if applicable

**Quality checks**: To preserve context, spawn sub-agents for `/check`, `/test`,
`/doc` in parallel rather than running make commands directly. After sub-agents
complete, run `/quality` yourself to verify nothing was missed.

## Completion Criteria (per task)

- [ ] Code written and follows project patterns
- [ ] Tests written with good coverage
- [ ] `/quality` passes
- [ ] Changes committed
- [ ] Task marked complete per tracker conventions

## Exit

After completing ONE task:
- Output: `<STEP_COMPLETE>`
- If more tasks remain: Next invocation continues with next task
- If all tasks done: Next step is Step 4 (Ship)

If blocked (e.g., need clarification, dependency not ready):
- Output: `<BLOCKED reason="...">`
