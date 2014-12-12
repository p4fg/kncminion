#!/bin/sh
#set -x

JSON=`/home/pi/bfgminer/bfgminer-rpc -o "{\"command\":\"procs\"}"`
if [ "$?" -gt "0" ]
then
   echo "{}"
else
   echo "${JSON}"
fi
