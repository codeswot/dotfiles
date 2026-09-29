#!/usr/bin/env bash
set -euo pipefail

# Pull the live versions of every file this repo tracks back into the repo,
# so GitHub always reflects the current setup. Review with `git diff`, then commit.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

git ls-files .config .local | while read -r f; do
  if [[ -f "$HOME/$f" ]] && ! cmp -s "$HOME/$f" "$f"; then
    cp "$HOME/$f" "$f"
    echo "updated  $f"
  fi
done

git status --short
