# build.sh — VSCodium Main Build Script

## Purpose
`build.sh` is the entrypoint for building VSCodium both locally and in CI. It orchestrates fetching the upstream source, preparing it, building binaries, and packaging artifacts.

## Arguments (CLI Options)
- `-i`: Build "insider" release (sets `BINARY_NAME=codium-insiders`, `VSCODE_QUALITY=insider`)
- `-l`: Mark as "latest" (sets `VSCODE_LATEST=yes`)
- `-o`: Only prepare source, skip build (sets `SKIP_BUILD=yes`)
- `-p`: Do not skip asset build (`SKIP_ASSETS=no`)
- `-s`: Only build, skip source preparation (`SKIP_SOURCE=yes`)

## Environment Variables
- `APP_NAME`, `BINARY_NAME`, `CI_BUILD`, `GH_REPO_PATH`, `ORG_NAME`, `SHOULD_BUILD`, `SKIP_ASSETS`, `SKIP_BUILD`, `SKIP_SOURCE`, `VSCODE_LATEST`, `VSCODE_QUALITY`, `VSCODE_SKIP_NODE_VERSION_CHECK`, `OS_NAME`, `VSCODE_ARCH`, `NODE_OPTIONS`

## Step-by-Step Logic
1. **Logging Setup**: Logs all output to `logs/build_*.log` for reproducibility and debugging.
2. **Environment Setup**: Sets variables for product, binary, repo, build toggles, and architecture. Detects OS/arch and sets `VSCODE_ARCH` accordingly.
3. **Option Parsing**: Parses CLI options to override build toggles.
4. **Source Preparation**:
   - If not skipping source, removes old `vscode*` folders.
   - Sources `get_repo.sh` to fetch upstream source (see [get_repo.sh.md](./get_repo.sh.md)).
   - Sources `version.sh` to set version variables.
   - Saves key variables to `dev/build.env` for later use.
5. **Build and Asset Steps**:
   - If not skipping build, runs `prepare_vscode.sh` (see [prepare_vscode.sh.md](./prepare_vscode.sh.md)).
   - Handles OS-specific gypi includes for native modules.
   - If not skipping assets, runs `prepare_assets.sh` for packaging.

## Cross-References
- Invoked by: [stable-linux.yml](./WORKFLOW_STABLE_LINUX.md)
- Calls: [get_repo.sh.md](./get_repo.sh.md), [prepare_vscode.sh.md](./prepare_vscode.sh.md), `version.sh`, `prepare_assets.sh`
- Output: Logs, environment files, triggers downstream build steps

## Related Docs
- [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- [prepare_vscode.sh.md](./prepare_vscode.sh.md)
- [get_repo.sh.md](./get_repo.sh.md)
- [PIPELINE_INDEX.md](./PIPELINE_INDEX.md)
