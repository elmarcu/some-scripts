#! /bin/sh
#

MIN_SPEED=600MHz
MAX_SPEED=1.5GHz
GOVERNOR=ondemand
TOP_SPEED=2.5GHz
TOP_GOVERNOR=performance

if [ ! -z $2 ] ; then
  MIN_SPEED=$2
fi

if [ ! -z $3 ] ; then
  MAX_SPEED=$3
fi

case "$1" in
  max|top)
    MAX_SPEED=$TOP_SPEED
    GOVERNOR=$TOP_GOVERNOR
  ;;
  powersave|performance|ondemand)
    GOVERNOR=$1
  ;;
esac

echo "Changing CPU to:"
echo 'GOVERNOR="'$GOVERNOR'"
MIN_SPEED="'$MIN_SPEED'"
MAX_SPEED="'$MAX_SPEED'"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand.service
sudo systemctl reload cpufrequtils.service
