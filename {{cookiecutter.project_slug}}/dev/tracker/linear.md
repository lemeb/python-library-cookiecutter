# Tracker: Linear

This tracker uses Linear for specs, task tracking, and collaboration.

## Step 1: Spec

**Where to record**: Linear issue description

Update the issue with:
- Problem statement
- Proposed solution
- Acceptance criteria

## Step 2: Plan

**Where to record**: Linear issue description + sub-issues

1. Update the parent issue description with the implementation plan
2. Create sub-issues for each task:
   - Title: `PARENT-ID(N): Task description`
   - Set dependencies between sub-issues (Linear supports this)
3. Order sub-issues by priority

**Approval**: In interactive mode, user approves verbally. In headless mode:
- Update the issue with the plan
- Create sub-issues
- Add a comment: "Implementation plan ready for review"
- Move issue to "Ready for Dev" (or equivalent status)
- Output `<AWAITING_APPROVAL>`

User approves by moving to "In Progress" or re-running `/go-on`.

## Step 3: Task

**Identifying next task**: Find the first sub-issue in "Todo" status.

**Tracking progress**:
- Move sub-issue to "In Progress" when starting
- Move to "Done" when complete
- Add commit hash as a comment

## Step 4: Ship

**PR reference**:
- Add PR URL as a comment on the parent issue
- Move parent issue to "In Review"

## Step 5: Feedback

**On BLOCKED**:
- Add a comment explaining the blocker and what decision is needed
- Move issue to "Blocked" status
- Tag relevant stakeholders

## Step 6: Cleanup

**After merge**:
- Move parent issue to "Done"
- Sub-issues should already be "Done"
