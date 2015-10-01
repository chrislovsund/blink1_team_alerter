#!/bin/bash -e

i="0"

while [ $i -lt 3 ]
do
  eject
  eject -t
  sleep 3
  i=$[$i+1]
done
