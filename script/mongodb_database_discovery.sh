#!/bin/bash
#usage:
#sh mongodb_slow_op.sh

DATABASE=( yotta metabase )

LENDATABASE=${#DATABASE[@]}

printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<${LENDATABASE};i++))
do
    printf '\n\t\t{'
    printf "\"{#DATABASE_NAME}\":\"${DATABASE[$i]}\"}"
    if [ $i -lt $[${LENDATABASE}-1] ];then
        printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"