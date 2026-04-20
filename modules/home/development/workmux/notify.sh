#!/usr/bin/env bash
# Notify when Claude finishes, unless the agent's tmux window is active
if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
  WINDOW_ACTIVE=$(tmux display-message -p -t "$TMUX_PANE" '#{window_active}' 2>/dev/null)
  [ "$WINDOW_ACTIVE" = "1" ] && exit 0
fi
PROJECT=$(basename "$PWD")
@terminalNotifier@ -title "Claude Code" -message "Agent finished in $PROJECT" -sound Glass
