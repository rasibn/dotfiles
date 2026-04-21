#!/usr/bin/env bash
# Claude Code tmux notification helper
# Usage: claude-notify.sh stop|notify|clear
#
# stop:   Claude finished responding, waiting for input  -> /tmp/claude-stop-<session>-*
# notify: Permission request or attention needed         -> /tmp/claude-notify-<session>-*
# clear:  User responded, clear all flags for session

ACTION="${1:-stop}"

if [ -z "$TMUX" ]; then
  exit 0
fi

SESSION=$(tmux display-message -p '#S')
WINDOW=$(tmux display-message -p '#I')

case "$ACTION" in
  stop)
    touch "/tmp/claude-stop-${SESSION}-${WINDOW}"
    ;;
  notify)
    touch "/tmp/claude-notify-${SESSION}-${WINDOW}"
    ;;
  clear)
    rm -f /tmp/claude-stop-${SESSION}-* /tmp/claude-notify-${SESSION}-*
    ;;
esac
