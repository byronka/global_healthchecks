#!/bin/sh

# how long to sleep between hitting up each machine.
SLEEP_TIME=30s

MACHINE_ARRAY=(
"cs01psnddev800" 
"cs01psnddev810" 
"cs01psnddev900" 
"cs01psnddev910" 
"cs01psndtst800" 
"cs01psndtst810" 
"cs01psndtst900" 
"cs01psndtst910"
)

while true # loop forever
do
	for i in ${MACHINE_ARRAY[*]}
	do
		# get the info page for Node on each machine, verify it's up and running

		IS_NODE_UP=$(./get_report_info.sh "http://$i:5000/report-server/info" | grep -c "node version" )
		if test $IS_NODE_UP -eq 0
		then 
			echo $(date) "is NodeJS down on $i?"
		fi

		CPU_STATE=$(./get_cpu_state.sh "US\bkatz"@$i)   # use mpstat and ssh to get cpu state on each machine
		if test -n "$CPU_STATE"
			then 
				echo $(date) $CPU_STATE on $i
		fi
		sleep $SLEEP_TIME
	done
done
