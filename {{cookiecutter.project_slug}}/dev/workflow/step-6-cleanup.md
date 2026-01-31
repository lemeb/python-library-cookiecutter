# Step 6: Post-Merge Cleanup

**Goal**: Clean up after the feature is merged.

## Prerequisites

- [ ] PR has been merged (by human)

If PR not merged yet, this step doesn't apply.

## Procedure

1. **Update local repository**:
   ```bash
   git checkout <base-branch>
   git pull
   ```

2. **Delete the feature branch** (local and remote):
   ```bash
   git branch -d <feature-branch>
   git push origin --delete <feature-branch>
   ```

3. **Update tracker** per tracker conventions (e.g., close issue, move to Done)

## Completion Criteria

- [ ] Feature branch deleted
- [ ] Tracker updated

## Exit

After cleanup:
- Output: `<FEATURE_COMPLETE>`

This is the final step. The feature is done.
