#!/bin/bash
#usage:
#sh mongodb_stats.sh <METRIC> <METHOD> <PORT>

. /home/zabbix/script/fun_check_stat_file.sh

METRIC="$1"
METHOD="$2"
HOSTNAME=127.0.0.1
PORT="${3:-27017}"
STAT_FILE="/home/zabbix/var/mongodb${PORT}.stats"
CHECK_STAT_FILE_FLAG=`fun_check_stat_file ${STAT_FILE} 120`;

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    exit;
fi;

case ${METRIC} in
    opcountersRepl)
    if [ ${METHOD} = "insert" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "insert"|awk '{print $3}'|sed 's/,//'

    elif [ ${METHOD} = "query" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "query"|awk '{print $3}'|sed 's/,//'

    elif [ ${METHOD} = "update" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "update"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "delete" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "delete"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "getmore" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "getmore"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "command" ];then
        cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "command"|awk '{print $3}'|sed 's/,//'
        
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {opcountersRepl insert|opcountersRepl query|opcountersRepl update|opcountersRepl delete|opcountersRepl getmore|opcountersRepl command}\033[0m"
t 1
    fi
    ;;
    
    connections)
    if [ ${METHOD} = "current" ];then
        cat ${STAT_FILE}|grep -A 5 "connections"|grep "current"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "available" ];then
        cat ${STAT_FILE}|grep -A 5 "connections"|grep "available"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "totalCreated" ];then
        cat ${STAT_FILE}|grep -A 5 "connections"|grep "totalCreated"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {connections current|connections available|connections totalCreated}\033[0m"
        exit 1
    fi
    ;;
    
    activeClients)
    if [ ${METHOD} = "total" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "total"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "readers" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "readers"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "writers" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "writers"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {activeClients total|activeClients readers|activeClients writers}\033[0m"
        exit 1
    fi
    ;;
    
    globalLock)
    if [ ${METHOD} = "totalTime" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep "totalTime"|awk '{print $3}'|awk -F '"' '{print $2}'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {globalLock totalTime}\033[0m"
        exit 1
    fi
    ;;
    
    document)
    if [ ${METHOD} = "deleted" ];then
        cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "deleted"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "inserted" ];then
        cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "inserted"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "returned" ];then
        cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "returned"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "updated" ];then
        cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "updated"|awk -F '(' '{print $2}'|sed 's/),//'
        
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {document deleted|document inserted|document returned|document updated}\033[0m"
        exit 1
    fi
    ;;
    
    network)
    if [ ${METHOD} = "bytesIn" ];then
        cat ${STAT_FILE}|grep -w -A 6 "network"|grep "bytesIn"|awk -F'"' '{print $4}'
    
    elif [ ${METHOD} = "bytesOut" ];then
        cat ${STAT_FILE}|grep -w -A 6 "network"|grep "bytesOut"|awk -F'"' '{print $4}'
    
    elif [ ${METHOD} = "numRequests" ];then
        cat ${STAT_FILE}|grep -w -A 6 "network"|grep "numRequests"|awk -F'(' '{print $2}'|sed 's/),//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {network bytesIn|network bytesOut|network numRequests}\033[0m"
        exit 1
    fi
    ;;
    
    mem)
    if [ ${METHOD} = "mapped" ];then
        cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "mapped"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "mappedWithJournal" ];then
        cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "mappedWithJournal"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "virtual" ];then
        cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "virtual"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "resident" ];then
        cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "resident"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {mem mapped|mem mappedWithJournal|mem virtual|mem resident}\033[0m"
        exit 1
    fi
    ;;
    
    opcounters)
    if [ ${METHOD} = "insert" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "insert"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "query" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "query"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "update" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "update"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "delete" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "delete"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "getmore" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "getmore"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "command" ];then
        cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "command"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {opcounters insert|opcounters query|opcounters update|opcounters delete|opcounters getmore|opcounters command}\033[0m"
        exit 1
    fi
    ;;
    
    currentQueue)
    if [ ${METHOD} = "total" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "total"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "readers" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "readers"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "writers" ];then
        cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "writers"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {currentQueue total|currentQueue readers|currentQueue writers}\033[0m"
        exit 1
    fi
    ;;
    
    *)
    echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
    echo -e  "\033[33mUsage: $0 {opcountersRepl insert|opcountersRepl query|opcountersRepl update|opcountersRepl delete|opcountersRepl getmore|opcountersRepl command}\033[0m"
    echo -e  "\033[33mUsage: $0 {connections current|connections available|connections totalCreated}\033[0m"
    echo -e  "\033[33mUsage: $0 {activeClients total|activeClients readers|activeClients writers}\033[0m"
    echo -e  "\033[33mUsage: $0 {globalLock totalTime}\033[0m"
    echo -e  "\033[33mUsage: $0 {document deleted|document inserted|document returned|document updated}\033[0m"
    echo -e  "\033[33mUsage: $0 {network bytesIn|network bytesOut|network numRequests}\033[0m"
    echo -e  "\033[33mUsage: $0 {mem mapped|mem mappedWithJournal|mem virtual|mem resident}\033[0m"
    echo -e  "\033[33mUsage: $0 {opcounters insert|opcounters query|opcounters update|opcounters delete|opcounters getmore|opcounters command}\033[0m"
    echo -e  "\033[33mUsage: $0 {currentQueue total|currentQueue readers|currentQueue writers}\033[0m"
    exit 1
esac
