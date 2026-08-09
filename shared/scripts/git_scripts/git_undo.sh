#!/usr/bin/env bash
# Undo the last N commits, keeping their changes staged. Defaults to 1.
#   git-undo      -> git reset --soft HEAD~1
#   git-undo 13   -> git reset --soft HEAD~13
set -euo pipefail

count="${1:-1}"

case "$count" in
  '' | *[!0-9]*)
    echo "git-undo: expected a positive integer, got '$count'" >&2
    exit 1
    ;;
esac

if [ "$count" -lt 1 ]; then
  echo "git-undo: count must be at least 1" >&2
  exit 1
fi

exec git reset --soft "HEAD~$count"
