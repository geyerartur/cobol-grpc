#!/usr/bin/env bash
set -eu

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$repo_root" ]; then
    echo "Run this script from inside the repository." >&2
    exit 1
fi

if [ -d "$repo_root/.githooks" ]; then
    find "$repo_root/.githooks" -maxdepth 1 -type f -exec chmod +x {} +
fi

git -C "$repo_root" config --local core.hooksPath .githooks

echo "Git hooks activated for $repo_root"
