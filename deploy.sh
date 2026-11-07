#!/usr/bin/env bash
# Publishes this folder as a GitHub Pages site. Needs git + the GitHub CLI, logged in:  gh auth login
# Put speedart.mp4 / session.mp4 in this folder first (each file must be under 100 MB).
set -euo pipefail
cd "$(dirname "$0")"
REPO="${1:-canvasbuddy-pitch}"
OWNER=$(gh api user --jq .login)
[ -d .git ] || git init -q -b main
git add -A && git commit -q -m "CanvasBuddy pitch deck" || true
gh repo view "$OWNER/$REPO" >/dev/null 2>&1 || gh repo create "$REPO" --public --source=. --remote=origin
git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$OWNER/$REPO.git"
git push -u origin main
gh api -X POST "repos/$OWNER/$REPO/pages" -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 || true
echo
echo "Live in about a minute at:  https://$OWNER.github.io/$REPO/"
echo "Jump straight to the video slide:  https://$OWNER.github.io/$REPO/#slide=7"
