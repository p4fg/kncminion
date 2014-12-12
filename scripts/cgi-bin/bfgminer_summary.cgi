#!/bin/sh
#set -x

JSON=`/home/pi/bfgminer/bfgminer-rpc -o "{\"command\":\"summary\"}"`
if [ "$?" -gt "0" ]
then
   echo "{}"
else
   echo "${JSON}"
fi
