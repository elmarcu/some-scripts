#! /bin/sh
#
stopped=false
found=false
program=$1
binary=$2
if [ -z $binary ] ; then
  binary="exe"
fi

for i in $(ps aux | grep $program | grep $binary | awk '{print $8}'); do
  found=true
  if [ "TNl" = "$i" ] || [ "Tsl" = "$i" ] || [ "Tl" = "$i" ] || [ "Tl+" = "$i" ] ; then
    stopped=true
  fi
done

if [ "$found" = true ] ; then

  if [ "$stopped" = true ] ; then
    sh $HOME/.executables/throttling-cpu.sh gamer
  else
    sh $HOME/.executables/throttling-cpu.sh
  fi

  if [ "$stopped" = true ] ; then
    echo "Programs changing to running"
    ps aux | grep $program | grep $binary | awk '{print $2}' | xargs kill -CONT
  else
    echo "Programs changing to pausing"
    ps aux | grep $program | grep $binary | awk '{print $2}' | xargs kill -STOP
  fi
  ps aux | grep $program | grep $binary
fi
