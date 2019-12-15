#!/bin/bash
#监控区块链出块的脚本
#nohup sh /app/zabbix/script/produce.sh >> /app/zabbix/var/BlockOutNum.stats &
#TYPE: [discovery] | [name num|height1|height2]

TYPE=$1
C_NAME=$2
NUM=$3

. /app/zabbix/script/fun_check_stat_file.sh
bon_file="/app/zabbix/var/BlockOutNum.stats"

is_process() {
    pronum=$(ps -ef|grep "produce.sh"|grep -v "grep"|wc -l)
    [ ${pronum} -gt 0 ] && return 0
    return 1
}

is_process || { echo "produce.sh没有运行，请先输入nohup sh /app/zabbix/script/produce.sh >> /app/zabbix/var/BlockOutNum.stats &命令运行监本。"; exit 1; }

CHECK_STAT_FILE_FLAG=$(fun_check_stat_file ${bon_file} 120)

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    echo 10
    exit;
fi;

is_rownum() {
    rownum=$(cat ${bon_file} | wc -l)
    [ ${rownum} -ge 21 ] && return 0
    return 1
}

is_rownum || { echo "${bon_file}文件内容少于21行，请等待一段时间在运行脚本。"; exit 1; }


file=( $(tail -n 21 ${bon_file}) )
declare -a account_info=()
for(( i=0;i<21;i++ ));
do
    account_info[$i]=$(echo ${file[$i]} |awk -F"," '{print $1, $2, $3, $4}')
done

account_discovery() {
    printf "{\n"
    printf  '\t'"\"data\":["
    for(( i=0;i<21;i++ ));
    do
        printf '\n\t\t{'
        account_name=$(echo ${account_info[$i]}|awk '{print $1}')
        printf "\"{#ACCOUNT_NAME}\":\"${account_name}\"}"
        if [ $i -lt 20 ]; then
            printf ','
        fi
    done
    printf  "\n\t]\n"
    printf "}\n"
}


st_num() {
if [ x${NUM} = x"num" ]; then
    for(( i=0;i<21;i++ ));
    do
        acc_name=$(echo ${account_info[$i]}|awk '{print $1}')
        if [ x"${C_NAME}" = x"${acc_name}" ]; then
            echo ${account_info[$i]}|awk '{print $2}'
        fi
    done
elif [ x${NUM} = x"height1" ]; then
    for(( i=0;i<21;i++ ));
    do
        acc_name=$(echo ${account_info[$i]}|awk '{print $1}')
        if [ x"${C_NAME}" = x"${acc_name}" ]; then
            echo ${account_info[$i]}|awk '{print $3}'
        fi
    done
elif [ x${NUM} = x"height2" ]; then
    for(( i=0;i<21;i++ ));
    do
        acc_name=$(echo ${account_info[$i]}|awk '{print $1}')
        if [ x"${C_NAME}" = x"${acc_name}" ]; then
            echo ${account_info[$i]}|awk '{print $4}'
        fi
    done
else
    exit 1;

fi
}


case ${TYPE} in
    discovery)
        account_discovery
    ;;

    name)
        st_num
    ;;

    *)
    exit 1
esac

