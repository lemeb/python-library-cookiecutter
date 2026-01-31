# Tracker: GitHub Issues

This tracker uses GitHub Issues for specs and task tracking.

## Step 1: Spec

**Where to record**: GitHub Issue description

Update the issue body with:
- Problem statement
- Proposed solution
- Acceptance criteria

## Step 2: Plan

**Where to record**: GitHub Issue description (append) + task list

Format in issue description:
```markdown
## Implementation Plan

- [ ] Task 1: Description
- [ ] Task 2: Description (blocked by Task 1)
- [ ] Task 3: Description
```

**Approval**: In interactive mode, user approves verbally. In headless mode:
- Update the issue with the plan
- Add a comment: "Implementation plan ready for review"
- Output `<AWAITING_APPROVAL>`

User approves by responding to the comment or re-running `/go-on`.

## Step 3: Task

**Tracking progress**: Check off tasks in the issue as you complete them.
Use `gh issue edit` or the API.

## Step 4: Ship

**PR reference**: Link PR to issue using `Closes #123` in PR description.

## Step 5: Feedback

**On BLOCKED**:
- Add a comment explaining the blocker
- Add `blocked` label if available

## Step 6: Cleanup

**After merge**: GitHub auto-closes the issue if PR used `Closes #123`.
