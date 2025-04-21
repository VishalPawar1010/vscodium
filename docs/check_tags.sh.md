# check_tags.sh (VSCodium) — Documentation

## Purpose
`check_tags.sh` inspects GitHub releases/tags for the current repository to decide if a new build is required. It prevents unnecessary builds/releases if nothing has changed.

## Main Steps
1. **Token Selection:**
   - Selects the appropriate GitHub token for API access.
2. **Release Query:**
   - Uses `curl` and `jq` to fetch the latest release and its assets from the GitHub API.
3. **Build Decision:**
   - Compares current version/commit to release assets to decide if a build is needed (for all platforms/archs).
   - Sets `SHOULD_BUILD`, `SHOULD_BUILD_SRC`, `SHOULD_BUILD_DEB`, etc. as needed.
4. **Export to GitHub Actions:**
   - Writes version and build flags to `$GITHUB_ENV` for downstream steps.

## Environment Variables
- `GITHUB_TOKEN`, `GH_TOKEN`, `APP_NAME`, `ASSETS_REPOSITORY`, `MS_TAG`, `MS_COMMIT`, `RELEASE_VERSION`, `OS_NAME`, `VSCODE_ARCH`, `GITHUB_ENV`, etc.

## Cross-References
- Called by: [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- Output: Sets build flags, version info, and asset checks for the pipeline

## Related Docs
- [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
