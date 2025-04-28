# VSCodium Linux CI/CD Workflow Explained

This document provides a detailed, step-by-step explanation of the `.github/workflows/stable-linux.yml` file, which defines the GitHub Actions workflow for building, testing, packaging, and releasing VSCodium on Linux. It is intended for contributors, maintainers, and anyone interested in understanding or extending the automation pipeline.

---

## Table of Contents
- [Overview](#overview)
- [Workflow Triggers](#workflow-triggers)
- [Environment Variables](#environment-variables)
- [Job Breakdown](#job-breakdown)
  - [check](#check)
  - [compile](#compile)
  - [build (matrix)](#build-matrix)
  - [reh_linux, reh_alpine, snap](#other-jobs)
- [Artifacts & Releases](#artifacts--releases)
- [References & Related Docs](#references--related-docs)

---

## Overview

The `stable-linux.yml` workflow automates the process of building VSCodium binaries for various Linux architectures, testing them, and preparing them for release. It closely mirrors the local build process (see [CONTRIBUTOR_GUIDE.md](./CONTRIBUTOR_GUIDE.md) and [howto-build.md](./howto-build.md)), but runs in the cloud using GitHub Actions.

---

## Workflow Triggers

The workflow is triggered by:
- Manual dispatch (`workflow_dispatch`), with options to force version update, generate assets, or checkout a PR.
- Repository dispatch (for custom events, e.g., from other workflows).
- Pushes to the `master` branch (except markdown and upstream JSON changes).
- Pull requests to the `master` branch (except markdown and upstream JSON changes).

---

## Environment Variables

A set of environment variables is defined globally and per-job, including:
- `APP_NAME`, `BINARY_NAME`, `GH_REPO_PATH`, `ORG_NAME`, `VSCODE_QUALITY`, etc.
- Variables for versioning, architecture, and build control.

These are used throughout the workflow and in the called scripts (e.g., `build.sh`, `get_repo.sh`).

---

## Job Breakdown

### check
- **Runs on:** `ubuntu-latest`
- **Purpose:** Prepares the build by checking out code, switching to the relevant branch, cloning the VSCode repo, running pre-checks, and checking tags/releases.
- **Key Steps:**
  - `actions/checkout`: Checks out the code.
  - `get_pr.sh`: Switches to the relevant PR branch if needed.
  - `get_repo.sh`: Clones the upstream VSCode repository.
  - `check_cron_or_pr.sh`: Determines if the build is triggered by a PR or scheduled event.
  - `check_tags.sh`: Checks existing tags/releases to avoid duplicate builds.
- **Outputs:** Commit/tag/version info, and flags for whether to build/deploy.

### compile
- **Runs on:** `ubuntu-22.04`
- **Needs:** `check`
- **Purpose:** Prepares the build environment and compiles the VSCode source for the default architecture.
- **Key Steps:**
  - Checks out code and switches branch if needed.
  - Sets up GCC, Node.js (20.18.2), and Python 3.11.
  - Installs `libkrb5-dev` (required by VSCode).
  - Clones VSCode repo and runs the main build script (`build.sh`).
  - Compresses the `vscode` directory as an artifact for later jobs.
  - Uploads the artifact using `actions/upload-artifact`.

### build (matrix)
- **Runs on:** `ubuntu-latest` (in containers for each architecture)
- **Needs:** `check`, `compile`
- **Purpose:** Builds, packages, and (optionally) releases VSCodium for multiple Linux architectures.
- **Matrix:**
  - `x64`, `arm64`, `armhf`, `riscv64`, `loong64`, `ppc64le`
  - Each uses a custom Docker image for the target arch.
- **Key Steps:**
  - Checks out code and switches branch if needed.
  - Installs GitHub CLI (`install_gh.sh`) and checks tags/releases.
  - Installs build dependencies (`build/linux/deps.sh`).
  - Sets up Rust toolchain (for native modules/extensions).
  - Downloads the `vscode` artifact from the compile job.
  - Runs `build/linux/package_bin.sh` to build and package binaries.
  - Prepares assets (`prepare_assets.sh`).
  - Releases binaries (`release.sh`) and updates the versions repo (`update_version.sh`) if deployment is enabled.
  - Uploads assets as artifacts if not deploying.

### reh_linux, reh_alpine, snap
- **Purpose:** Specialized jobs for building and packaging for additional targets (reh, Alpine, Snapcraft).
- **Structure:** Similar to the main build matrix, but tailored for each packaging format.

---

## Artifacts & Releases
- **Artifacts:**
  - The compiled `vscode` directory is compressed and uploaded after the `compile` job.
  - Packaged binaries and assets are uploaded for each architecture after the `build` job.
- **Releases:**
  - If deployment is enabled, binaries are released to GitHub and version information is updated.

---

## References & Related Docs
- [CONTRIBUTOR_GUIDE.md](./CONTRIBUTOR_GUIDE.md): End-to-end development and build process.
- [howto-build.md](./howto-build.md): Manual build instructions and dependencies.
- [PIPELINE_INDEX.md](./PIPELINE_INDEX.md): Cross-linked index of all pipeline scripts and docs.
- [build.sh.md](./build.sh.md): Main build orchestrator script.
- [prepare_vscode.sh.md](./prepare_vscode.sh.md): Source preparation and dependency setup.
- [get_repo.sh.md](./get_repo.sh.md): Upstream source fetch and versioning.
- [check_cron_or_pr.sh.md](./check_cron_or_pr.sh.md): Event detection and build/deploy flag logic.
- [check_tags.sh.md](./check_tags.sh.md): Tag/release checking and build gating.
- [update_settings.sh.md](./update_settings.sh.md): Settings/configuration updater.
- [utils.sh.md](./utils.sh.md): Shared shell utilities for patching, logging, etc.
- [howto-build.md](./howto-build.md): Manual build instructions and dependencies.
- [build.sh](../dev/build.sh), [prepare_vscode.sh](../prepare_vscode.sh), [get_repo.sh](../get_repo.sh): Core scripts invoked by the workflow.
- [GitHub Actions Documentation](https://docs.github.com/en/actions): For further details on workflow syntax and features.

---

## Summary
This workflow ensures that every commit or PR to VSCodium is automatically built, tested, and (optionally) released for all major Linux architectures. It closely mirrors the local developer experience, guaranteeing consistency between local and CI builds. For further details on individual scripts or troubleshooting, consult the referenced documents above.

---

*Maintained by the VSCodium community. Please propose improvements via pull request.*
