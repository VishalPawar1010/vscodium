#!/usr/bin/env bash
# shellcheck disable=SC2129

set -e

# git workaround
if [[ "${CI_BUILD}" != "no" ]]; then
  git config --global --add safe.directory "/__w/$( echo "${GITHUB_REPOSITORY}" | awk '{print tolower($0)}' )"
fi

# Always fetch and use the latest commit from the main branch of the void repo
DEFAULT_BRANCH="main"  # Change to 'master' if needed
MS_TAG="latest"
TIME_PATCH=$( printf "%04d" $(($(date +%-j) * 24 + $(date +%-H))) )
RELEASE_VERSION="${MS_TAG}${TIME_PATCH}"
mkdir -p vscode
cd vscode || { echo "'vscode' dir not found"; exit 1; }
git init -q
git remote add origin https://github.com/VishalPawar1010/void.git
git fetch --depth 1 origin ${DEFAULT_BRANCH}
git checkout FETCH_HEAD
MS_COMMIT=$(git rev-parse HEAD)
echo "Using latest commit: $MS_COMMIT"
echo "RELEASE_VERSION=\"${RELEASE_VERSION}\""
echo "MS_TAG=\"${MS_TAG}\""
echo "MS_COMMIT=\"${MS_COMMIT}\""
cd ..

# for GH actions
if [[ "${GITHUB_ENV}" ]]; then
  echo "MS_TAG=${MS_TAG}" >> "${GITHUB_ENV}"
  echo "MS_COMMIT=${MS_COMMIT}" >> "${GITHUB_ENV}"
  echo "RELEASE_VERSION=${RELEASE_VERSION}" >> "${GITHUB_ENV}"
fi

export MS_TAG
export MS_COMMIT
export RELEASE_VERSION
