#!/bin/sh
SESSION="kube"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

case "$1" in
  help)
    echo "[empty] will config kube to aws\n[qts] will config kube to qts\n[stop] - drops tmux session"
    exit 0
  ;;
  stop)
    if [ "$SESSIONEXISTS" != "" ]
    then
      tmux kill-session -t $SESSION
    fi
    exit 0
  ;;
  qts)
    CONFIG="$HOME/.ssh/qts.kube"
  ;;
  *)
    CONFIG="$HOME/.ssh/aws.kube"
  ;;
esac

if [ "$SESSIONEXISTS" = "" ]
then
  tmux new-session -d -s $SESSION "ln -sf $CONFIG $HOME/.kube/config && cd && kubectl get pods -n $KUBE_NAMESPACE && bash -i" \;
fi
tmux attach-session -t $SESSION:0
