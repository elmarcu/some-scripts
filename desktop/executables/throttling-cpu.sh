#! /bin/sh
#

MAX_SPEED=1.5GHz
MIN_SPEED=600MHz
TOP_SPEED=2.5GHz
GOVERNOR=ondemand
DEFAULT_GAMER_MIN_SPEED=600MHz
DEFAULT_GAMER_MAX_SPEED=800MHz
DEFAULT_GAMER_GOVERNOR=powersave

GAMER_MIN_SPEED=$2
if [ -z $GAMER_MIN_SPEED ] ; then
  GAMER_MIN_SPEED=$DEFAULT_GAMER_MIN_SPEED
fi

GAMER_MAX_SPEED=$3
if [ -z $GAMER_MAX_SPEED ] ; then
  GAMER_MAX_SPEED=$DEFAULT_GAMER_MAX_SPEED
fi

case "$1" in
  max)
    MAX_SPEED=$TOP_SPEED
  ;;
  gamer|game|custom)
    MAX_SPEED=$GAMER_MAX_SPEED
    MIN_SPEED=$GAMER_MIN_SPEED
    GOVERNOR=$DEFAULT_GAMER_GOVERNOR
  ;;
  powersave|performance)
    GOVERNOR=$1
  ;;
esac

echo "Changing CPU to:"
echo 'GOVERNOR="'$GOVERNOR'"
MIN_SPEED="'$MIN_SPEED'"
MAX_SPEED="'$MAX_SPEED'"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand.service
sudo systemctl reload cpufrequtils.service
