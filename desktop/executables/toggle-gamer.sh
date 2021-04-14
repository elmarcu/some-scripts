#!/bin/sh
SESSION="gamer"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

DEFAULT_GAMER_MIN_SPEED=600MHz
DEFAULT_GAMER_MAX_SPEED=800MHz
DEFAULT_GAMER_GOVERNOR=powersave

case "$1" in
  help)
    echo "[empty] will attach tmux session\n[start] will change cpu throttle to gamer settings\n[stop] restores cpu throttle"
    exit 0
  ;;
  stop)
    if [ "$SESSIONEXISTS" != "" ]
    then
      tmux kill-session -t $SESSION
    fi
    sh $HOME/.executables/throttling-cpu.sh
  ;;
  start)
    if [ "$SESSIONEXISTS" = "" ]
    then
      tmux new-session -d -s $SESSION "watch sh $HOME/.executables/throttling-cpu.sh $DEFAULT_GAMER_GOVERNOR $DEFAULT_GAMER_MIN_SPEED $DEFAULT_GAMER_MAX_SPEED"
    fi
    tmux attach-session -t $SESSION:0
  ;;
  *)
    tmux attach-session -t $SESSION:0
  ;;
esac
