#!/bin/bash
step=1
while true
do
    top -b -n 2 |grep -E "(Mem)|(Cpu)" >  ./tmp
    ifconfig >>  ./tmp
    sleep $step
    ifconfig >>  ./tmp
    cp -p ./tmp info
done
