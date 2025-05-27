#!/bin/bash
SESSION="llm"

# 如果会话已经存在，就 attach
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
    tmux attach -t $SESSION
    exit 0
fi

# 创建新的会话 + 第一个 pane
tmux new-session -d -s $SESSION -n main

# 分出第二个 pane（上下分）
tmux split-window -v -t $SESSION

# 缩小上面（nvitop）窗口的高度（10 行）
tmux resize-pane -t $SESSION:0.0 -y 1

# 在上 pane 执行 nvitop
tmux send-keys -t $SESSION:0.0 'nvitop' C-m

# 在下 pane 激活环境并进入工作目录
tmux send-keys -t $SESSION:0.1 'cd ~/LLM-from-scratch && conda activate nanoGPT' C-m
tmux send-keys -t $SESSION:0.1 'clear' C-m

# 启动后焦点停在下 pane
tmux select-pane -t $SESSION:0.1

# attach 进去
tmux attach -t $SESSION

