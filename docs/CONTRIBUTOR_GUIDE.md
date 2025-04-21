# VSCodium Linux Developer Guide

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture & Directory Structure](#architecture--directory-structure)
- [Prerequisites & Dependencies](#prerequisites--dependencies)
- [End-to-End Build Pipeline](#end-to-end-build-pipeline)
- [Development Workflow](#development-workflow)
- [Debugging & Troubleshooting](#debugging--troubleshooting)
- [Contributing Guidelines](#contributing-guidelines)
- [Advanced Topics](#advanced-topics)
- [References](#references)

---

## Project Overview

VSCodium provides free/libre binaries of Microsoft’s VS Code, built from source with telemetry disabled and a community-driven configuration. This repo contains scripts to automate fetching, patching, building, and packaging the editor for all major platforms.

---

## Architecture & Directory Structure

- `.github/workflows/`: GitHub Actions CI/CD definitions (e.g., `stable-linux.yml`)
- `dev/`: Developer scripts (e.g., `build.sh`)
- `patches/`: Patches applied to the upstream VS Code source
- `src/`: Custom resources and overrides
- `vscode/`: The checked-out and prepared VS Code source (generated during build)
- `docs/`: Documentation (including this guide)
- `utils.sh`, `prepare_vscode.sh`, `get_repo.sh`, etc.: Core build scripts

---

## Prerequisites & Dependencies

### System Packages

Install these with your package manager (`apt`, `dnf`, etc.):

- `node` (20.14)
- `npm`
- `jq`
- `git`
- `python3` (3.11)
- `gcc`, `g++`, `make`, `pkg-config`
- `libx11-dev`, `libxkbfile-dev`, `libsecret-1-dev`, `libkrb5-dev`
- `fakeroot`, `rpm`, `rpmbuild`, `dpkg`
- `imagemagick` (for AppImage)
- `snapcraft`

### Node Packages

All required Node packages are installed automatically during the build (`npm ci`).

---

## End-to-End Build Pipeline

### 1. Clone the Repository

```bash
git clone https://github.com/VSCodium/vscodium.git
cd vscodium
```

### 2. Start the Build

For Linux, simply run:

```bash
./dev/build.sh
```

This script orchestrates the entire build, following these high-level steps:

#### a. Environment Setup

- Exports environment variables (e.g., `APP_NAME`, `BINARY_NAME`, `VSCODE_QUALITY`).
- Detects architecture and OS.

#### b. Fetch Upstream Source

- Runs `get_repo.sh` to fetch the latest commit from the upstream VS Code repository (or a custom fork, if configured).
- Places the source in the `vscode/` directory.

#### c. Prepare Source

- Runs `prepare_vscode.sh` to:
  - Copy custom resources and licenses.
  - Update settings (e.g., disable telemetry).
  - (If enabled) Apply project-specific patches (currently disabled for stability).

#### d. Install Dependencies

- Installs Node dependencies with `npm ci` inside the `vscode/` directory.

#### e. Build

- Runs the VS Code build process, producing binaries and distributable packages.

#### f. Package

- Packages the build for distribution (e.g., `.deb`, `.rpm`, Snap, AppImage).

#### g. Logs

- All build logs are stored in the `logs/` directory for troubleshooting.

---

## Development Workflow

### Making Changes

1. **Sync with Upstream**  
   Always start from the latest `main` branch.

2. **Modify Source or Scripts**  
   - Edit scripts in `dev/`, `utils.sh`, or patches in `patches/`.
   - For UI or feature changes, modify files under `src/` or create new patches.

3. **Test Your Changes**  
   - Run `./dev/build.sh` and verify the build completes.
   - Test the produced binary (`vscode/` or packaged output).

4. **Debugging**  
   - Review logs in `logs/`.
   - Use `npm run watch` in the `vscode/` directory for incremental builds.

5. **Commit and Push**  
   - Follow commit message guidelines.
   - Open a pull request for review.

### Updating or Creating Patches

- Use `./dev/patch.sh <patch-name>` to generate or update patches.
- Follow prompts to resolve conflicts and finalize the patch.

---

## Debugging & Troubleshooting

- **Build Fails at Patch Step:**  
  Ensure patches match the current upstream source. If not needed, disable patching in `prepare_vscode.sh`.

- **Dependency Issues:**  
  Ensure all system and Node dependencies are installed as per this guide.

- **CI/CD Failures:**  
  Check `.github/workflows/stable-linux.yml` for the exact steps run by GitHub Actions.

- **Logs:**  
  Review `logs/build_*.log` for detailed error messages.

---

## Contributing Guidelines

- Read `CONTRIBUTING.md` and `CODE_OF_CONDUCT.md`.
- Open issues for bugs or feature requests.
- For bugfixes, follow the workflow above and ensure your changes are well-tested.
- For new features, discuss in an issue or pull request before large changes.

---

## Advanced Topics

- **CI/CD Reference:**  
  The GitHub Actions workflow (`.github/workflows/stable-linux.yml`) automates the build and release pipeline. It runs the same scripts as local builds, ensuring consistency.
- **Custom Builds:**  
  You can set environment variables or modify scripts to customize the build (e.g., branding, disabling features).
- **Packaging for Distribution:**  
  The build produces packages for various Linux distributions and Snapcraft.

---

## References

- [README.md](../README.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [How to Build](./howto-build.md)
- [GitHub Actions Workflow](../.github/workflows/stable-linux.yml)
- [Troubleshooting](./troubleshooting.md)

---

## Quick Start for New Contributors

1. **Install all dependencies** (see above).
2. **Clone the repo** and create a new branch.
3. **Run `./dev/build.sh`** to verify your environment.
4. **Make your changes** and test locally.
5. **Push and open a PR** for review.

Welcome to the VSCodium community! If you have questions, check the docs or join the [Gitter chat](https://gitter.im/VSCodium/Lobby).

---

*This document is maintained by the VSCodium community. Please propose improvements or corrections via pull request.*
