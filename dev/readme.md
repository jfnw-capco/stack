# Commands

docker-compose -p "api" up --scale app=3 -d

curl -H Host:api.delineate.io http://localhost:80
