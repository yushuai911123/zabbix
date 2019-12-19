#!/bin/bash

CURR_MIN="`date +%M`";
CURR_HOUR="`date +%H`";
INTERVAL=0;
EXE_FALG=0;
COMMAND_LINE='';

FILE_PATH="/srv/zabbix/script/cron.d/"

cd ${FILE_PATH} || exit 1;

if [ `ls -ld m*sh 2>/dev/null|awk '/\<m[0-9][0-9]*_/ {print $0}'  | wc -l` -ge 1 ] ;then
    ls -ld m*sh 2>/dev/null |awk '{if($NF ~/\<m[0-9][0-9]*_/)print $NF}'| while read LINE
    do
        INTERVAL="`echo $LINE |awk -F'_' '{print substr($1,2)}'`";
        MIN_EXE_FALG="`expr ${CURR_MIN} % ${INTERVAL}`";

        if [ "${MIN_EXE_FALG}" -eq "0" ] ;then
            COMMAND_LINE="nohup  `echo ${FILE_PATH}${LINE}` &";
            eval $COMMAND_LINE;
        fi;
    done;
fi;

