#!/bin/bash

IPADDR=$1
REACH=$2
RETRIES=5

# Calls the standard ping and gets the result 
    ping -c $RETRIES $IPADDR
    RESULT=$?
    echo $RESULT

# Checks no error if expected to be reachable
    if [ $RESULT -gt "0" ] && [ "${REACHABLE}" == "Y" ]; then
        echo "${IPADDR} as expected to be pingable"
        exit $RESULT 
    fi

# Checks for an error if expected not to be reachable
    if [ $RESULT -eq 0 ] && [ "$REACHABLE" -eq "N"]; then
        exit 1000 
    fi