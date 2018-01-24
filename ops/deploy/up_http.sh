HTTP_STATUS=0

TRIES=0

while [ $HTTP_STATUS != 200 ]
do
    HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" ${1})
    if [ $HTTP_STATUS != 200 ]; then
        TRIES=$((TRIES + 1))
        echo "${TRIES} attempt connecting to ${1}..."
        sleep 5s
    fi

    if [ "$TRIES" -gt "20" ]; then
        echo "Number of tries exceeded"
        exit 1
    fi
done