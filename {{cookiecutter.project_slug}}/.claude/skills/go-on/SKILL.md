---
name: go-on
description:
  Assess workflow state, execute ONE step, then exit with a signal. Designed for
  incremental progress — invoke repeatedly (manually or in a loop) to complete a
  feature.
---

# Workflow Continuation

## Arguments

```
/go-on [--headless] [ISSUE-REF]
```

- `--headless`: Running in autonomous loop (no user interaction available)
- `ISSUE-REF`: Issue reference (e.g., `SUN-199`, `#42`, `specs/feature.md`)

If no argument, infer from conversation context or current git branch.

## Quick Reference

| Signal | Meaning |
|--------|---------|
| `<STEP_COMPLETE>` | One unit done, invoke again for next |
| `<AWAITING_APPROVAL>` | Plan presented, waiting for user (headless only) |
| `<AWAITING_INPUT reason="...">` | Need clarification (headless only) |
| `<AWAITING_REVIEW>` | PR submitted, waiting for review |
| `<FEATURE_COMPLETE>` | All done |
| `<BLOCKED reason="...">` | Cannot proceed |

## Procedure

1. **Load the active tracker file** (specified in AGENTS.md under "Tracker
   Configuration") for how to record specs, plans, and track progress

2. **Assess current state** by checking:
   - Tracker (per active tracker file) for spec and plan status
   - Git: branch, commits, uncommitted changes, PR status
   - Filesystem: implementation progress

3. **Determine current step and load its procedure**:

   | State | Step | File to Load |
   |-------|------|--------------|
   | No spec exists | 1 | `dev/workflow/step-1-spec.md` |
   | Spec exists, no plan | 2 | `dev/workflow/step-2-plan.md` |
   | Plan not approved | 2 | `dev/workflow/step-2-plan.md` |
   | Plan approved, tasks remain | 3 | `dev/workflow/step-3-task.md` |
   | All tasks done, no PR | 4 | `dev/workflow/step-4-ship.md` |
   | PR exists, has feedback | 5 | `dev/workflow/step-5-feedback.md` |
   | PR merged | 6 | `dev/workflow/step-6-cleanup.md` |

4. **Execute ONE unit of work** per the step file's procedure
   - Follow the active tracker's conventions for recording state
   - If `--headless`, output `<AWAITING_*>` signals instead of waiting

5. **Output status**:

   ```
   ## /go-on Status

   Mode: <interactive|headless>
   Step: <N - name>
   State before: <what was found>
   Action taken: <what was done>
   Result: <outcome>

   <SIGNAL>

   Next: <what happens on next invocation>
   ```

## Key Principles

- **Stateless**: Determine state fresh each invocation from external sources
- **Atomic**: Do ONE thing, then exit
- **Idempotent**: Safe if interrupted; next invocation re-assesses
- **Signal-driven**: Always output exactly one signal for loop detection
- **Tracker-aware**: Follow the active tracker's conventions

## Headless Mode

When `--headless` is passed:
- Output `<AWAITING_APPROVAL>` instead of waiting for user response
- Output `<AWAITING_INPUT>` instead of asking questions
- Record state to tracker before exiting (so next invocation can continue)
- When spawning sub-agents, tell them: "Running in headless mode"

## For Autonomous Loops

```bash
while :; do
  OUTPUT=$(claude -p "/go-on --headless ISSUE-123" 2>&1)
  echo "$OUTPUT"

  # Stop on any signal except STEP_COMPLETE
  grep -q "<FEATURE_COMPLETE>" <<< "$OUTPUT" && exit 0
  grep -q "<AWAITING_APPROVAL>" <<< "$OUTPUT" && exit 0
  grep -q "<AWAITING_INPUT" <<< "$OUTPUT" && exit 0
  grep -q "<AWAITING_REVIEW>" <<< "$OUTPUT" && exit 0
  grep -q "<BLOCKED" <<< "$OUTPUT" && exit 1

  sleep 2
done
```
