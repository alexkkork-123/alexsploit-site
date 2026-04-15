#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
REPO="alexkkork-123/alexsploit-site"
read -rp "GitHub token: " TOKEN
git remote set-url origin "https://${TOKEN}@github.com/${REPO}.git" 2>/dev/null || git remote add origin "https://${TOKEN}@github.com/${REPO}.git"
git add -A
git diff --cached --quiet && echo "Nothing to commit" && exit 0
git commit -m "update"
GIT_LFS_SKIP_SMUDGE=1 git push -u origin main
git remote set-url origin "https://github.com/${REPO}.git"
echo "Pushed to https://github.com/${REPO}"
