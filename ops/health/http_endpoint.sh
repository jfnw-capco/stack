#!/bin/bash

URL=${1}
EXPECTED_HTTP_STATUS=${2}
CURRENT_HTTP_STATUS=0
RETRIES=20
ATTEMPTS=0
SLEEP="5s"

while [ $CURRENT_HTTP_STATUS != $EXPECTED_HTTP_STATUS ]
do
    CURRENT_HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" ${URL})
    if [ $CURRENT_HTTP_STATUS != $EXPECTED_HTTP_STATUS ]; then
        ATTEMPTS=$((ATTEMPTS + 1))
        echo "${TRIES} attempt connecting to ${URL} recieved ${CURRENT_HTTP_STATUS}..."
        sleep ${SLEEP}
    fi

    if [ "$ATTEMPTS" -gt "${RETRIES}" ]; then
        echo "Number of tries exceeded"
        exit 1
    fi
done