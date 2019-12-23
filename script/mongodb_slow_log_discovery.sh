#!/bin/bash
#usage:
#sh mongodb_slow_op.sh PORT

METRIC="${1}"
PORT="${2:-27017}"

. /srv/zabbix/script/fun_check_stat_file.sh
STAT_FILE="/srv/zabbix/var/mongodblog${PORT}.stats"

CHECK_STAT_FILE_FLAG=`fun_check_stat_file ${STAT_FILE} 300`;

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    exit;
fi;

commandname() {
    COMMAND_NAME=( $(grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|awk -vtype="command" '$5==type'|egrep "yotta|metabase"|awk '{print $8}'|sort|uniq) )
    LEN_COMMAND=${#COMMAND_NAME[@]}
    printf "{\n"
    printf  '\t'"\"data\":["
    for ((i=0;i<${LEN_COMMAND};i++))
    do
        printf '\n\t\t{'
        printf "\"{#COMMAND_NAME}\":\"${COMMAND_NAME[$i]}\"}"
        if [ $i -lt $[${LEN_COMMAND}-1] ];then
            printf ','
        fi
    done
    printf  "\n\t]\n"
    printf "}\n"
}

writename() {
    WRITE_NAME=( $(grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|egrep "yotta|metabase"|awk '{print $5}'|sort|uniq) )
    LEN_WRITE=${#WRITE_NAME[@]}
    printf "{\n"
    printf  '\t'"\"data\":["
    for ((i=0;i<${LEN_WRITE};i++))
    do
        printf '\n\t\t{'
        printf "\"{#WRITE_NAME}\":\"${WRITE_NAME[$i]}\"}"
        if [ $i -lt $[${LEN_WRITE}-1] ];then
            printf ','
        fi
    done
    printf  "\n\t]\n"
    printf "}\n"
}

case ${METRIC} in
    COMMAND)
        commandname
    ;;

    WRITE)
        writename
    ;;

    *)
    exit 1
esac
