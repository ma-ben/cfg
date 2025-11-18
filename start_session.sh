#!/usr/bin/env bash

# 用法:
#   ./tmux_dev.sh <PROJECT_DIR> <SESSION_NAME> <CONDA_ENV>
# 示例:
#   ./tmux_dev.sh ~/nanoGPT nanoGPT nanoGPT

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <SESSION_NAME> <PROJECT_DIR> <CONDA_ENV>"
    exit 1
fi

SESSION="$1"
PROJECT_DIR="$2"
ENV_NAME="$3"

cd "$PROJECT_DIR" || { echo "路径不存在: $PROJECT_DIR"; exit 1; }

# 如果会话已存在，直接 attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach -t "$SESSION"
    exit 0
fi

WINDOW_1="main"
tmux new-session -d -s "$SESSION" -n "$WINDOW_1"
tmux send-keys -t "$SESSION:$WINDOW_1" "conda activate $ENV_NAME" C-m
tmux send-keys -t "$SESSION:$WINDOW_1" "clear" C-m

WINDOW_2="GPU"
tmux new-window -t "$SESSION" -n "$WINDOW_2"
tmux send-keys -t "$SESSION:$WINDOW_2" "conda activate $ENV_NAME" C-m
tmux send-keys -t "$SESSION:$WINDOW_2" "nvitop" C-m

WINDOW_3="Lab"
tmux new-window -t "$SESSION" -n "$WINDOW_3"
tmux send-keys -t "$SESSION:$WINDOW_3" "conda activate $ENV_NAME" C-m
tmux send-keys -t "$SESSION:$WINDOW_3" "clear" C-m

tmux select-window -t "$SESSION:$WINDOW_1"
tmux attach -t "$SESSION"
