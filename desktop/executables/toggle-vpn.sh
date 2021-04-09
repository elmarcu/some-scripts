#!/bin/sh
SESSION="vpn"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

case "$1" in
  help)
    echo "[empty] will start vpn aws and qts\n[stop] - stops all vpn"
    exit 0
  ;;
  stop)
    if [ "$SESSIONEXISTS" != "" ]
    then
      tmux kill-session -t $SESSION
    fi
    sudo sh -c "openvpn3 session-manage --disconnect --config AWS"
    sudo killall openvpn
    t=$(ifconfig | grep tun0 | tr ':' ' ' | awk '{print $1}')
    if [ "$t" != "" ]
    then
      xargs sudo ip link delete $t
    fi
  ;;
  *)
    if [ "$SESSIONEXISTS" = "" ]
    then
      tmux new-session -d -s $SESSION 'sudo sh -c "openvpn --config $HOME/.ssh/qts.ovpn"' \; \
        split-window -v 'sudo sh -c "openvpn3 session-start --config AWS && watch openvpn3 sessions-list"' \;
    fi
    tmux attach-session -t $SESSION:0
  ;;
esac
