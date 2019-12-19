#!/bin/bash
#监控 SERVER 端口

PORT=$1
PORTNUM=$(netstat -ltnp|grep "$PORT"|wc -l)
if [ ${PORTNUM} -eq 0 ]; then
    echo 0
else
    echo 1
fi
