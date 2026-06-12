#!/bin/bash
# tmux workspace launcher
# Usage: tmux-dev [directory]
# Creates a session with nvim

DIR="${1:-.}"
DIR=$(cd "$DIR" && pwd)
SESSION="dev"

# If session already exists, switch to it
tmux has-session -t "$SESSION" 2>/dev/null && {
    tmux switch-client -t "$SESSION"
    exit 0
}

# Create session with first window
tmux new-session -d -s "$SESSION" -n "code" -c "$DIR"

# 启动 nvim
tmux send-keys -t "$SESSION:1" "nvim ." Enter

# Focus on nvim
tmux select-pane -t "$SESSION:1"

# Switch to the session
tmux switch-client -t "$SESSION"
