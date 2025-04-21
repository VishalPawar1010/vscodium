# get_repo.sh (VSCodium) — Documentation

## Purpose
`get_repo.sh` fetches the latest commit of the upstream VSCode (or custom fork) repository, placing it in the `vscode/` directory. It is invoked by [build.sh](./build.sh.md) and the CI pipeline.

## Main Steps
1. **Git Config:**
   - For CI builds, configures git safe directory for GitHub Actions runners.
2. **Clone and Checkout:**
   - Initializes `vscode/` as a git repo, adds remote, fetches latest commit from `main`, checks out that commit.
   - Sets versioning variables (`MS_TAG`, `MS_COMMIT`, `RELEASE_VERSION`).
3. **Export Variables:**
   - Exports variables for use in later scripts and CI environments.

## Environment Variables
- `CI_BUILD`, `GITHUB_REPOSITORY`, `GITHUB_ENV`, etc.

## Cross-References
- Called by: [build.sh.md](./build.sh.md), [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- Output: Populates `vscode/` directory, sets version variables

## Related Docs
- [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- [build.sh.md](./build.sh.md)
