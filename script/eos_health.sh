#!/bin/bash
count=`curl -s http://127.0.0.1:7000/v1/chain/get_info  |awk -F':' '{print $4}'|awk -F',' '{print $1}'`
sleep  20
count1=`curl -s http://127.0.0.1:7000/v1/chain/get_info  |awk -F':' '{print $4}'|awk -F',' '{print $1}'` 
diff=`expr $count1 - $count`
warn=`expr $diff - 12`
if [ $warn -lt 0 ];then
    status=0
else
    status=1
fi
echo "$status"
