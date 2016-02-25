#!/bin/sh

# how long to sleep between hitting up each machine.
SLEEP_TIME=60s

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

		REPORT_SERVER_INFO=$(./get_report_info.sh "http://$i:5000/report-server/info") 
		echo $(date) $REPORT_SERVER_INFO
		IS_NODE_UP=$(echo $REPORT_SERVER_INFO | grep -c "node version" )
		if test $IS_NODE_UP -eq 0
		then 
			echo $(date) "is NodeJS down on $i?" 1>&2
		fi

    # use mpstat and ssh to get cpu state on each machine
		MPSTAT_VALUE=$(ssh "US\bkatz"@$i mpstat 2>/dev/null)
		echo $(date) $MPSTAT_VALUE
		CPU_STATE=$(echo $MPSTAT_VALUE | tail -1 | awk '{print $4}' | ./compare_cpu.pl)
		if test -n "$CPU_STATE"
			then 
				echo $(date) $CPU_STATE on $i 1>&2
		fi
		sleep $SLEEP_TIME
	done
done
