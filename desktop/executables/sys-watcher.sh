#!/bin/sh
SESSION="system"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [ "$SESSIONEXISTS" = "" ]
then
  tmux new-session -d -s $SESSION 'watch -n 5 sensors $(sensors | grep core)' \; \
    split-window -v -p 85 'htop' \; \
    split-window -v 'bash' \; \
    select-pane -t 0 \; \
    split-window -h -p 55 'watch -n 5 -c "cpufreq-info -c 0 | grep -A3 current\ policy"' \; \
    split-window -h 'watch  -n 120 df -h /dev/sda*' \; \
    select-pane -t 4 \;
fi
tmux attach-session -t $SESSION:0