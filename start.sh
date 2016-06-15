#!/bin/bash

# start the program, sending repetitive unimportant stuff to out.txt
# and error messages (important stuff) to err.txt.  That way you can see
# that the program is still running in one, what it's up to, but see
# the valuable stuff in another file.

./overall.sh > out.txt 2>err.txt
