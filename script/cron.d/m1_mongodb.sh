#!/bin/bash
#usage:
#sh mongodb.sh

gen_mongodb_status(){
    PORT="${1}"
    LOG_FILE="/app/zabbix/var/mongodb${PORT}.stats"
    HOSTNAME="127.0.0.1";

/app/mongodb-4.0.10/bin/mongo ${HOSTNAME}:${PORT} >${LOG_FILE} <<EOF
db.serverStatus();
exit
EOF
chown zabbix.zabbix ${LOG_FILE}
}

netstat -tnlp|awk '/LISTEN/ && /mongod\>/ {print $4}'|awk -F':' '{print $2}'|while read LINE
do
    echo "the port is $LINE";
    gen_mongodb_status ${LINE};
done;

