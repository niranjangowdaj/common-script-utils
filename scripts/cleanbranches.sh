#!/bin/bash
# Description: Delete all local branches already merged into main/master
set -e

DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

echo "Default branch: $DEFAULT"
echo ""

MERGED=$(git branch --merged "$DEFAULT" | grep -v "^\*" | grep -vE "^\s*($DEFAULT|master|main|develop)$")

if [ -z "$MERGED" ]; then
  echo "No merged branches to clean up."
  exit 0
fi

echo "Branches to delete:"
echo "$MERGED" | while read -r branch; do
  echo "  - $branch"
done

echo ""
read -r -p "Delete these branches? [y/N] " CONFIRM
if [[ "$CONFIRM" =~ ^[yY]$ ]]; then
  echo "$MERGED" | xargs git branch -d
  echo "✓ Done"
else
  echo "Aborted."
fi
