#!/bin/bash
# tmux hermes workspace launcher
# Launches hermes + zsh + yazi
# Usage: tmux-hermes.sh

SESSION="hermes"

# If session already exists, switch to it
tmux has-session -t "$SESSION" 2>/dev/null && {
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$SESSION"
    else
        tmux attach -t "$SESSION"
    fi
    exit 0
}

# Create session with window 1: hermes default
tmux new-session -d -s "$SESSION" -n "default"
tmux send-keys -t "$SESSION:1" "hermes" Enter

# Window 2: default shell (bash)
tmux new-window -t "$SESSION" -n "shell"

# Window 3: yazi
tmux new-window -t "$SESSION" -n "yazi"
tmux send-keys -t "$SESSION:3" "yazi" Enter

# Focus on window 1
tmux select-window -t "$SESSION:1"

# Switch to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION"
else
    tmux attach -t "$SESSION"
fi
