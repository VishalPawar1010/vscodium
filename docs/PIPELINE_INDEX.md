# Cross-References & Pipeline File Index (VSCodium Linux CI/CD)

This section provides a cross-linked index and summary for all files and scripts involved in the `.github/workflows/stable-linux.yml` pipeline. Use this as a map to navigate the automation and build process.

---

## Main Workflow
- **[WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md):**
  - Entry point for CI/CD pipeline documentation. Explains jobs, triggers, and artifact/release flow.

## Core Scripts & Documentation
- **[build.sh](./build.sh.md):**
  - Main build orchestrator. Sets up environment, fetches source, triggers preparation and build steps.
- **[prepare_vscode.sh](./prepare_vscode.sh.md):**
  - Prepares VSCode source for build: copies resources, updates settings, applies patches (if enabled), installs dependencies, customizes branding.
- **[get_repo.sh](./get_repo.sh.md):**
  - Fetches the latest VSCode (or fork) source code, sets version variables.
- **[check_cron_or_pr.sh](./check_cron_or_pr.sh.md):**
  - Determines event type (PR, push, cron, etc.) and sets build/deploy flags for the workflow.
- **[check_tags.sh](./check_tags.sh.md):**
  - Checks GitHub releases/tags to determine if a new build is required, sets flags for downstream jobs.
- **[update_settings.sh](./update_settings.sh.md):**
  - Updates settings/configuration files to enforce VSCodium defaults (e.g., disables telemetry).
- **[utils.sh](./utils.sh.md):**
  - Provides shared shell functions for patching, logging, validation, etc.

## How These Interact in the Pipeline
1. **Workflow Triggers:** See [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md#workflow-triggers)
2. **Job Steps:** Each job step in the workflow invokes one or more of the above scripts. See [WORKFLOW_STABLE_LINUX.md](./WORKFLOW_STABLE_LINUX.md#job-breakdown) for the order and logic.
3. **Artifacts:** Output from each script (e.g., built binaries, logs, version info) is passed between jobs as artifacts or environment variables.
4. **Customization:** Most scripts read environment variables set by the workflow or previous steps, allowing for flexible customization and re-use.

## See Also
- [CONTRIBUTOR_GUIDE.md](./CONTRIBUTOR_GUIDE.md): End-to-end development and build process for contributors.
- [howto-build.md](./howto-build.md): Manual build instructions and dependencies for local development.

---

**Navigation Tips:**
- Use the links above to jump to detailed explanations for each script.
- For troubleshooting, start with the workflow doc, then follow the links to the relevant script docs.
- For extending or modifying the pipeline, ensure you update both the workflow and the relevant script docs.

---

*Maintained by the VSCodium community. Please propose improvements or corrections via pull request.*
