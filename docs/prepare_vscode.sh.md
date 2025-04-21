# prepare_vscode.sh (VSCodium) — Documentation

## Purpose
`prepare_vscode.sh` prepares the VSCode source tree for building VSCodium. It is called by [build.sh](./build.sh.md) and by the CI pipeline. It copies resources, updates settings, applies (or skips) patches, and installs Node dependencies.

## Main Steps
1. **Source Copy:**
   - Copies files from `src/stable/` or `src/insider/` to `vscode/` based on `VSCODE_QUALITY`.
   - Copies `LICENSE` to `vscode/LICENSE.txt`.
2. **Settings Update:**
   - Calls `../update_settings.sh` to update configuration (see [update_settings.sh.md](./update_settings.sh.md)).
3. **Patch Application:**
   - (Currently skipped; logic removed for stability.)
4. **Node Dependency Setup:**
   - Sets environment variables to skip Electron/Playwright downloads in CI.
   - For Linux, sets `VSCODE_SKIP_NODE_VERSION_CHECK` and handles ARM arch specifics.
   - Moves `.npmrc`, copies project `.npmrc`, runs `npm ci` (up to 5 retries), restores `.npmrc`.
5. **product.json Customization:**
   - Uses `jq` to set URLs and branding in `product.json`.
6. **Platform-Specific Customization:**
   - For Linux, updates product name and icon fields.
   - For Windows, patches installer script.

## Environment Variables
- `VSCODE_QUALITY`, `OS_NAME`, `npm_config_arch`, `CI_BUILD`, etc.

## Cross-References
- Called by: [build.sh.md](./build.sh.md), [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- Calls: [update_settings.sh.md](./update_settings.sh.md), [utils.sh.md](./utils.sh.md)
- Edits: `vscode/`, `product.json`, `.npmrc`

## Related Docs
- [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md)
- [build.sh.md](./build.sh.md)
- [update_settings.sh.md](./update_settings.sh.md)
- [utils.sh.md](./utils.sh.md)
