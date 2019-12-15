#!/bin/bash

CLEOS="/app/bp/nodeos/cleos -u http://127.0.0.1:7000"
TOKEN="YTA"

function monitor()
{
  # $1=$current_num, $2=$next_num, $3=$current_producer, $4=$next_producer
  produced_num=$(($2-$1))
  echo "$3,$produced_num,$1,$(($2-1))"
}

function getbp()
{
  p=`$CLEOS get block $1 2>/dev/null | sed -n '3p' | sed 's/^.*://g' | grep -o '[0-9|a-z]*'`
  if [ $? -ne 0 ];then
    sleep 3
    echo 'no' 
  else
    echo $p
  fi
}

function getbps()
{
  bps=`$CLEOS get schedule | grep -B 50 'pending schedule' | grep "$TOKEN" | awk '{print $1}'`
  echo $bps
}

init_block_num=`$CLEOS get info | grep head_block_num | grep -o '[0-9]*'`
init_block_producer=`getbp $init_block_num `



for i in {1..12}
do
  init_block_num=$(($init_block_num-1))
  current_producer=`getbp $init_block_num `
  if [ $current_producer != $init_block_producer ];then
    current_num=$(($init_block_num+1))
    current_producer=$init_block_producer
    next_num=$current_num
    break
  fi 
done


while true
do
    
  bps=(`getbps`)
  if [[ ${#bps[*]} -ne 21 ]];then
    echo "The number of bp is not equal to 21, should check."
    exit 2
  fi

  find=0
  ibps=(${!bps[*]})
  for i in ${ibps[*]}
  do
    if [ $current_producer == ${bps[$i]} ];then
      find=1
      if [ $i -eq ${ibps[-1]} ];then
        i=-1
      fi
      next_expect_producer=${bps[$(($i+1))]}
      break
    fi
  done

  if [ $find -eq 0 ];then
    echo "The producer $current_producer is not in the schedule, should check."  
    exit 3
  fi

  while true
  do
    next_num=$(($next_num+1))
    next_producer=`getbp $next_num`
    if [ $next_producer == 'no' ];then
      next_num=$(($next_num-1))
      continue
    fi
    if [ $next_producer != $current_producer ];then
      if [ $next_producer != $next_expect_producer ];then
        ilist=(${ibps[*]:$(($i+1))} ${ibps[*]:0:$(($i+1))})
        for ii in ${ilist[*]}
        do
          if [ ${bps[$ii]} != $next_producer ];then
            monitor $current_num $next_num $current_producer ${bps[$ii]}
            current_producer=${bps[$ii]}
            current_num=$next_num
          else
            break
          fi
        done
      fi
      monitor $current_num $next_num $current_producer $next_producer
      current_producer=$next_producer
      current_num=$next_num
      break
    fi 
  done

  #break

done

