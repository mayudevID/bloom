#!/bin/bash

cd "$(dirname "$0")/.." || exit

BRANCH=$1
REMOTE=${2:-origin}

if [ -z "$BRANCH" ]; then
  echo "Usage: $0 <branch-name> [remote-name]"
  exit 1
fi

if git show-ref --verify --quiet refs/heads/"$BRANCH"; then
  git branch -D "$BRANCH"
else
  echo "Local branch tidak ditemukan"
fi

git push "$REMOTE" --delete "$BRANCH"