#!/usr/bin/env sh

dirs=$(find ~/dev ~/.config -mindepth 1 -maxdepth 1 -type d)

# Inside tmux
if [[ -n $TMUX ]]; then
	path=$(echo "$dirs" | fzf-tmux -w 80 -h 30)
else
	path=$(echo "$dirs" | fzf --height=30 --scheme=path)
fi

session=$(basename "$path" | tr . _)

tmux new-session -d -c "$path" -s "$session" 2>/dev/null
tmux send-keys -t "$session" nvim ENTER

# Inside tmux
if [[ -n $TMUX ]]; then
	tmux switch-client -t "$session"
	exit 0
fi

tmux attach -t "$session"
