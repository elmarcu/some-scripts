#!/bin/sh
SESSION="purevpn"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

case "$1" in
  help)
    echo "[empty] will attach tmux session\n[US|BR|CH] will start vpn\n[stop] - stops all vpn"
    exit 0
  ;;
  stop)
    if [ "$SESSIONEXISTS" != "" ]
    then
      tmux kill-session -t $SESSION
    fi
    purevpn -d
    sudo systemctl stop purevpn
  ;;
  US|BR|CA)
    sudo systemctl start purevpn
    if [ "$SESSIONEXISTS" = "" ]
    then
      tmux new-session -d -s $SESSION "purevpn -c $1 && watch purevpn -s"
    fi
    tmux attach-session -t $SESSION:0
  ;;
  *)
    tmux attach-session -t $SESSION:0
  ;;
esac
