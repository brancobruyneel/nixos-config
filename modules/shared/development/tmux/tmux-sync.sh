#!/usr/bin/env sh

echo "finding projects..."

git=$(find ~/dev ~/work -name .git -type d -prune -exec dirname {} \;)
config=$(find ~/.config -mindepth 1 -maxdepth 1 -type d)

mkdir -p ~/.cache/tmux-dirs/

echo "writing paths to cache..."

printf "$git\n$config" | sort >~/.cache/tmux-dirs/paths | uniq

echo "done"
