#!/bin/sh

# the next line runs the mpstat command.  we send its error output
# to /dev/null since it's moot for our purposes.  the last line is 
# the actual row of data. The two last lines look like this:

# 09:57:24 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
# 09:57:24 AM  all    5.06    0.00    0.96    0.26    0.00    0.02    0.00    0.00    0.00   93.70

# by getting the fourth field, we get the %usr cpu, and we send that
# to a simple perl script to output a message based on how high that is.

ssh $1 mpstat 2>/dev/null | tail -1|awk '{print $4}' | ./compare_cpu.pl
