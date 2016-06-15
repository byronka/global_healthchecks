#!/bin/bash

# how long to sleep between hitting up each machine.
SLEEP_TIME=600s

MACHINE_ARRAY_PROD=(
"cs03psndprd801" #production server
"cs03psndprd800" #production server
)

MACHINE_ARRAY_DEV=(
"cs01psnddev800" 
"cs01psnddev810" 
"cs01psnddev900" 
"cs01psnddev910" 
"cs01psndtst800" 
"cs01psndtst810" 
"cs01psndtst900" 
"cs01psndtst910"
)

function check_prod_report_server ()
{
	for i in ${MACHINE_ARRAY_PROD[*]}
	do
		# get the info page for Node on each machine, verify it's up and running
		echo $(date) "checking $i"

		REPORT_SERVER_INFO=$(./get_report_info.sh "http://$i:5000/report-server/info") 
		echo $(date) $REPORT_SERVER_INFO
		IS_NODE_UP=$(echo $REPORT_SERVER_INFO | grep -c "node version" )
		if test $IS_NODE_UP -eq 0
		then 
			echo $(date) "is NodeJS down on $i?" 1>&2
		fi

		sleep $SLEEP_TIME
	done
}

function check_dev_tst_report_servers()
{
	for i in ${MACHINE_ARRAY_DEV[*]}
	do
		# get the info page for Node on each machine, verify it's up and running

		echo $(date) "checking $i"

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
}

while true # loop forever
do
  # the following are function calls.
	check_prod_report_server
	check_dev_tst_report_servers
  echo "." 1>&2
done
