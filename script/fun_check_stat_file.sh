fun_check_stat_file(){
    CHECK_STAT_FILE="$1";
    CHECK_INTERVAL="${2:-120}";

    if [ ! -f ${CHECK_STAT_FILE} ] ;then
        echo -1;
        return;
    fi;

#    FILE_MODIFY_TIME="`stat ${CHECK_STAT_FILE} | awk -F'[： ]' '/最近更改/{print $2" "substr($3,1,8);}'`";
    FILE_MODIFY_TIME="`stat ${CHECK_STAT_FILE}|egrep '最近更改|Modify'|awk -F'[： ]' '{print $2" "substr($3,1,8);}'`";
    FILE_MODIFY_TIME_SECONDS="`date -d "${FILE_MODIFY_TIME}" +%s`";
    CURRENT_TIME_SECONDS="`date +%s`";

    if [ `expr ${CURRENT_TIME_SECONDS} - ${FILE_MODIFY_TIME_SECONDS}` -lt  ${CHECK_INTERVAL} ] ;then
        echo 1;
        return;
    else
        echo 0;
        return;
    fi;
}
