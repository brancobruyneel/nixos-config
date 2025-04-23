#!/usr/bin/env bash

# Inside tmux
if [[ -n $TMUX ]]; then
  path=$(cat ~/.cache/tmux-dirs/paths | fzf-tmux -w 100 -h 30)
else
  path=$(cat ~/.cache/tmux-dirs/paths | fzf --height=30 --scheme=path)
fi

session=$(basename "$path" | tr . _)

if [ -z "$session" ]; then
  exit 0
fi

tmux new-session -d -c "$path" -s "$session" 2>/dev/null
tmux send-keys -t "$session" nvim ENTER

# Inside tmux
if [[ -n $TMUX ]]; then
  tmux switch-client -t "$session"
  exit 0
fi

tmux attach -t "$session"
