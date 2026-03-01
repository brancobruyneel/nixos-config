#!/usr/bin/env sh

sessions=$(tmux list-sessions -F "#{session_name}")

tmux_switch_to_session() {
	session="$1"
	if echo "$sessions" | grep "^$session$" >/dev/null 2>&1; then
		tmux switch-client -t "$session"
	fi
}

choice=$(sort -rfu <<<"$sessions" |
	fzf-tmux -w 80 -h 30 |
	tr -d '\n')
tmux_switch_to_session "$choice"
