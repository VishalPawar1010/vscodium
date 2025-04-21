# check_cron_or_pr.sh (VSCodium) — Documentation

## Purpose
`check_cron_or_pr.sh` determines the type of CI event (PR, push, workflow dispatch, cron) and sets the build/deploy flags accordingly. It is used in the early steps of the pipeline to control what the rest of the workflow should do.

## Main Steps
1. **Event Detection:**
   - Checks the value of `GITHUB_EVENT_NAME` (PR, push, workflow_dispatch, or cron).
2. **Flag Setting:**
   - Sets `SHOULD_BUILD` and `SHOULD_DEPLOY` based on event type and inputs (e.g., `GENERATE_ASSETS`).
3. **Export to GitHub Actions:**
   - Writes flags and branch info to `$GITHUB_ENV` for use in subsequent steps.

## Environment Variables
- `GITHUB_EVENT_NAME`, `GITHUB_BRANCH`, `GENERATE_ASSETS`, `SHOULD_BUILD`, `SHOULD_DEPLOY`, `VSCODE_QUALITY`, `GITHUB_ENV`

## Cross-References
- Called by: [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- Output: Sets build/deploy flags for all downstream jobs

## Related Docs
- [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
