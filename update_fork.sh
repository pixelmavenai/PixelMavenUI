#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/Comfy-Org/ComfyUI.git"
BRANCH="master"   # ← corrected from main to master

echo "==> Checking current remotes..."
git remote -v

# Add upstream if not already set
if git remote get-url upstream &>/dev/null; then
  echo "==> Upstream already set, updating URL..."
  git remote set-url upstream "$UPSTREAM"
else
  echo "==> Adding upstream remote..."
  git remote add upstream "$UPSTREAM"
fi

echo "==> Fetching latest from upstream..."
git fetch upstream

echo "==> Switching to branch: $BRANCH"
git checkout "$BRANCH"

echo "==> Merging upstream/$BRANCH into local $BRANCH..."
git merge upstream/"$BRANCH" --no-edit

echo "==> Pushing updated fork to origin..."
git push origin "$BRANCH"

echo "==> Updating submodules..."
git submodule update --init --recursive --remote

echo "==> Done! Your fork is now up to date with upstream."