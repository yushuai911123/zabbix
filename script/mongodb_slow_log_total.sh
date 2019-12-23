#!/bin/bash
#usage:
#sh mongodb_slow_op.sh DATABASE COMMAND|WRITE PORT
#参数1:数据库名称，yotta metabase | {#DATABASE_NAME}
#参数2:日志信息所属分类，COMMAND WRITE | {#METRIC_NAME}
#参数3:MongoDB服务端口，默认27017

. /srv/zabbix/script/fun_check_stat_file.sh

DATABASE="$1"
METRIC="$2"
PORT="${3:-27017}"


STAT_FILE="/srv/zabbix/var/mongodblog${PORT}.stats"

CHECK_STAT_FILE_FLAG=`fun_check_stat_file ${STAT_FILE} 300`;

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    exit;
fi;

#command 类别的总数
command_total() {
    echo "${grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|awk -vtype="command" '$5==type'|awk -F '[. ]' -vdataname="${DATABASE}" '$8==dataname'|wc -l}"
}

#write 类别的总数
write_total() {
    echo "${grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|awk -F '[. ]' -vdataname="${DATABASE}" '$10==dataname'|wc -l}"
}


case ${METRIC} in
    COMMAND)
        command_total
    ;;

    WRITE)
        write_total
    ;;

    *)
    exit 1
esac







