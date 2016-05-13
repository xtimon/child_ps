#!/bin/bash

if ! [ -s "$1" ]
then
  echo 0 0 0 0 0 0 0 0 0
  exit 1
fi

PARENTPID=`cat $1`

if ! [[ $PARENTPID =~ ^-?[0-9]+$ ]]
then
  echo 0 0 0 0 0 0 0 0 0
  exit 1
fi

CPS=`ps xao pid,ppid|awk -v ppid="$PARENTPID" '{if ($2 == ppid) print $1;}'`
 
CPA=(${CPS// / })

PCOUNT=${#CPA[@]}

if [ "$PCOUNT" -eq 0 ]
then
  echo 0 0 0 0 0 0 0 0 0
  exit
fi

RSS=()
for pid in ${CPA[@]}
do
  RSS+=(`ps h -p $pid -o rss`)
done

VSZ=()
for pid in ${CPA[@]}
do
  VSZ+=(`ps h -p $pid -o vsz`)
done

MINRSS=0
MAXRSS=0
for i in ${RSS[@]}; do
    (( $i > MAXRSS || MAXRSS == 0)) && MAXRSS=$i
    (( $i < MINRSS || MINRSS == 0)) && MINRSS=$i
done

MINVSZ=0
MAXVSZ=0
for i in ${VSZ[@]}; do
  (( $i > MAXVSZ || MAXVSZ == 0)) && MAXVSZ=$i
  (( $i < MINVSZ || MINVSZ == 0)) && MINVSZ=$i
done

TOTALRSS=0
for i in "${RSS[@]}"
do
  TOTALRSS=$((TOTALRSS + i))
done

TOTALVSZ=0
for i in "${VSZ[@]}"
do
  TOTALVSZ=$((TOTALVSZ + i))
done

echo $((PCOUNT)) $((TOTALRSS*1024)) $((MAXRSS*1024)) $((MINRSS*1024)) $((TOTALVSZ*1024)) $((MAXVSZ*1024)) $((MINVSZ*1024)) $((TOTALRSS/PCOUNT*1024)) $((TOTALVSZ/PCOUNT*1024))
