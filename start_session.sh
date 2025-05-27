#!/bin/bash
SESSION="llm"

# 如果会话已存在，直接 attach
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
    tmux attach -t $SESSION
    exit 0
fi

# 创建新的会话 + 第一个窗口 main
tmux new-session -d -s $SESSION -n bash

# 在第一个窗口的 pane 里执行初始化命令
tmux send-keys -t $SESSION:main 'cd ~/LLM-from-scratch && conda activate nanoGPT' C-m
tmux send-keys -t $SESSION:main 'clear' C-m

# 创建新窗口 GPU 并运行 nvitop
tmux new-window -t $SESSION -n GPU
tmux send-keys -t $SESSION:GPU 'nvitop' C-m

# attach 到第一个窗口 bash
tmux select-window -t $SESSION:bash
tmux attach -t $SESSION
