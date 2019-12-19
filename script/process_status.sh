#!/bin/bash
#license:GPL
#edit by xuhq
#date:2019.09.06
java_mem(){
	ps aux|grep "java"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$6}; END{print sum}'
}
java_cpu(){
	ps aux|grep "java"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$3}; END{print sum}'
}
mongo_mem(){
	ps aux|grep "mongod"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$6}; END{print sum}'
}
mongo_cpu(){
	ps aux|grep "mongod"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$3}; END{print sum}'
}
eos_mem(){
	ps aux|grep "nodeos"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$6}; END{print sum}'
}
eos_cpu(){
	ps aux|grep "nodeos"|grep -v "grep"|grep -v "processstatus.sh"|awk '{sum+=$3}; END{print sum}'
}
case "$1" in
	java_mem)
		java_mem
		;;
	java_cpu)
		java_cpu
		;;
	mongo_mem)
		mongo_mem
		;;
	mongo_cpu)
		mongo_cpu
		;;
	eos_mem)
		eos_mem
		;;
	eos_cpu)
		eos_cpu
		;;
	*)
		echo "Usage: $0 {java_mem|java_cpu|mongo_mem|mongo_cpu|eos_mem|eos_cpu}"
		;;
esac
