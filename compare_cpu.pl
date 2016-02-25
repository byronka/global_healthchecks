#!/bin/perl

# really basic script - compare the cpu usage to some numbers and
# based on that, output an appropriate message if value is too high

$cpu_value = <>;
if ($cpu_value >= 96) {
	print "cpu at $cpu_value\n"
} 
