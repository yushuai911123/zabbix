#!/bin/bash
count1=`curl -s http://127.0.0.1:7000/v1/chain/get_info  |awk -F':' '{print $4}'|awk -F',' '{print $1}'`
count2=`curl -s http://47.93.13.197:8888/v1/chain/get_info |awk -F':' '{print $4}'|awk -F',' '{print $1}'`
diff=`expr $count2 - $count1`
if [ $diff -gt 1200 ];then
    status=0
else
    status=1
fi
echo "$status"
