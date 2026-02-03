# Tracker: GitHub Issues

This tracker uses GitHub Issues for specs and task tracking.

## Step 1: Spec

**Where to record**: GitHub Issue description

Example issue body for `#42: User Authentication`:

```markdown
## Problem

Users cannot log in to the application. We need a secure authentication system.

## Proposed Solution

Implement JWT-based authentication with email/password login.

## Acceptance Criteria

- [ ] User can register with email and password
- [ ] User can log in and receive a JWT token
- [ ] Protected routes reject requests without valid token
- [ ] Passwords are hashed with bcrypt

## Non-Goals

- Social login (OAuth) — future work
- Password reset — future work
```

## Step 2: Plan

**Where to record**: GitHub Issue description (append)

Append the implementation plan to the issue:

```markdown
---

## Implementation Plan

Status: DRAFT

### Tasks

- [ ] 1. Add User model and migrations
- [ ] 2. Add password hashing utilities (depends on 1)
- [ ] 3. Add /register endpoint (depends on 1, 2)
- [ ] 4. Add /login endpoint with JWT (depends on 1, 2)
- [ ] 5. Add auth middleware (depends on 4)
- [ ] 6. Protect routes with middleware (depends on 5)

### Notes

- Using PyJWT for tokens
- Token expiry: 24 hours
```

**Approval mechanism**:
- In interactive mode, user approves verbally
- In headless mode:
  1. Update issue with plan, set `Status: DRAFT`
  2. Add comment: "Implementation plan ready for review"
  3. Output `<AWAITING_APPROVAL>`
  4. User approves by changing to `Status: APPROVED` or re-running `/go-on`

## Step 3: Task

**Tracking progress**: Check off tasks in the issue as you complete them.

Example progress:
```markdown
- [x] 1. Add User model and migrations
- [x] 2. Add password hashing utilities
- [ ] 3. Add /register endpoint ← IN PROGRESS
- [ ] 4. Add /login endpoint with JWT
```

## Step 4: Ship

**PR reference**: Link PR to issue using `Closes #42` in PR description.

## Step 5: Feedback

**On BLOCKED**:
- Add a comment explaining the blocker
- Add `blocked` label if available

## Step 6: Cleanup

**After merge**: GitHub auto-closes the issue if PR used `Closes #42`.

---

## Local Files

Even when using GitHub Issues as tracker, you MAY use local files:
- `specs/` — Optional, for local searchable documentation
- `IMPLEMENTATION_PLAN.md` — Not used; plan lives in the issue

The GitHub Issue is the single source of truth.
