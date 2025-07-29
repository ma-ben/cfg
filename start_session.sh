#!/bin/bash
cd ~/nanoGPT # 所有环境会继承这个路径
SESSION="nanoGPT"
ENV_NAME="nanoGPT"

# 如果会话已存在，直接 attach
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
    tmux attach -t $SESSION
    exit 0
fi

# 创建新的会话 + 第一个窗口 main
WINDOW_1="main"
tmux new-session -d -s $SESSION -n $WINDOW_1
tmux send-keys -t $SESSION:$WINDOW_1 "conda activate $ENV_NAME" C-m
tmux send-keys -t $SESSION:$WINDOW_1 'clear' C-m

# 创建新窗口 GPU 并运行 nvitop
WINDOW_2="GPU"
tmux new-window -t $SESSION -n $WINDOW_2
tmux send-keys -t $SESSION:$WINDOW_2 "conda activate $ENV_NAME" C-m
tmux send-keys -t $SESSION:$WINDOW_2 'nvitop' C-m

# 创建新窗口 Lab 并运行 nvitop
WINDOW_3="Lab"
tmux new-window -t $SESSION -n $WINDOW_3
tmux send-keys -t $SESSION:$WINDOW_3 "conda activate $ENV_NAME" C-m
tmux send-keys -t $SESSION:$WINDOW_3 'clear' C-m

# attach 到第一个窗口 bash
tmux select-window -t $SESSION:$WINDOW_1
tmux attach -t $SESSION
