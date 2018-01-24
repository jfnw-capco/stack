HTTP_STATUS=0

while [ $HTTP_STATUS != 200 ]
do
    HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" ${1})
    echo $HTTP_STATUS
    if [ $HTTP_STATUS != 200 ]; then
         sleep 3s
    fi
done